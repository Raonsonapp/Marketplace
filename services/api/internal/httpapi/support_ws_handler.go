package httpapi

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/service"
	"tajikshop/api/internal/ws"
)

// SupportWSHandler implements WS /ws/support/:conversationId: an
// authenticated, ownership-checked realtime feed of one conversation's
// messages. Unlike OrderWSHandler (which polls the DB since order status
// changes from elsewhere in the system), new messages only ever enter
// through SupportHandler.PostMessage, which broadcasts directly on the same
// ws.Hub room — so no poller is needed here, only the room membership.
type SupportWSHandler struct {
	hub      *ws.Hub
	support  *service.SupportService
	tokenMgr *auth.TokenManager
	upgrader websocket.Upgrader
}

// NewSupportWSHandler builds a SupportWSHandler.
func NewSupportWSHandler(hub *ws.Hub, support *service.SupportService, tokenMgr *auth.TokenManager) *SupportWSHandler {
	return &SupportWSHandler{
		hub: hub, support: support, tokenMgr: tokenMgr,
		upgrader: websocket.Upgrader{
			ReadBufferSize:  1024,
			WriteBufferSize: 1024,
			// Same rationale as OrderWSHandler: auth is via the token, not
			// same-origin, so origin checking is intentionally permissive.
			CheckOrigin: func(r *http.Request) bool { return true },
		},
	}
}

// Serve handles GET /ws/support/:conversationId. The access token is passed
// as `?token=`, mirroring OrderWSHandler.Serve exactly (browser/native
// WebSocket clients cannot set an Authorization header on the upgrade
// request).
func (h *SupportWSHandler) Serve(c *gin.Context) {
	conversationID, valid := dto.ParseUUID(c.Param("conversationId"))
	if !valid {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	claims, err := h.tokenMgr.ParseAccessToken(c.Query("token"))
	if err != nil {
		c.AbortWithStatus(http.StatusUnauthorized)
		return
	}
	if _, err := h.support.GetConversation(c.Request.Context(), claims.UserID, conversationID); err != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	conn, err := h.upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}
	defer conn.Close()

	room := conversationID.String()
	h.hub.Join(room, conn)
	defer h.hub.Leave(room, conn)

	// Inbound frames aren't part of this channel's contract (messages are
	// sent via POST /support/conversations/:id/messages); simply drain them
	// so a client that pings/keeps-alive doesn't error out the connection,
	// and detect disconnects.
	for {
		if _, _, err := conn.ReadMessage(); err != nil {
			return
		}
	}
}
