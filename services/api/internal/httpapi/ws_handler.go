package httpapi

import (
	"context"
	"encoding/json"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/gorilla/websocket"

	"tajikshop/api/internal/auth"
	"tajikshop/api/internal/httpapi/dto"
	"tajikshop/api/internal/service"
	"tajikshop/api/internal/ws"
)

// OrderWSHandler implements WS /ws/orders/:orderId: an authenticated,
// ownership-checked live feed of one order's status. Support chat
// (WS /ws/support/:conversationId) is Phase 5 scope per
// docs/ARCHITECTURE.md's feature matrix and is not wired here; it can reuse
// the same ws.Hub primitive when that feature lands.
type OrderWSHandler struct {
	hub      *ws.Hub
	orders   *service.OrderService
	tokenMgr *auth.TokenManager
	upgrader websocket.Upgrader

	mu      sync.Mutex
	pollers map[string]context.CancelFunc
}

// NewOrderWSHandler builds an OrderWSHandler.
func NewOrderWSHandler(hub *ws.Hub, orders *service.OrderService, tokenMgr *auth.TokenManager) *OrderWSHandler {
	return &OrderWSHandler{
		hub: hub, orders: orders, tokenMgr: tokenMgr,
		upgrader: websocket.Upgrader{
			ReadBufferSize:  1024,
			WriteBufferSize: 1024,
			// Mobile/native clients and any web origin explicitly listed in
			// CORS_ORIGINS are both acceptable; a same-origin check isn't
			// meaningful for a Bearer-token API, so origin is intentionally
			// not restricted here (auth is enforced via the token instead).
			CheckOrigin: func(r *http.Request) bool { return true },
		},
		pollers: make(map[string]context.CancelFunc),
	}
}

// Serve handles GET /ws/orders/:id. The access token is passed as
// `?token=` since browser/native WebSocket clients cannot set an
// Authorization header on the upgrade request.
func (h *OrderWSHandler) Serve(c *gin.Context) {
	orderID, valid := dto.ParseUUID(c.Param("id"))
	if !valid {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	claims, err := h.tokenMgr.ParseAccessToken(c.Query("token"))
	if err != nil {
		c.AbortWithStatus(http.StatusUnauthorized)
		return
	}
	order, err := h.orders.Get(c.Request.Context(), claims.UserID, orderID)
	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	conn, err := h.upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		return
	}
	defer conn.Close()

	room := orderID.String()
	h.hub.Join(room, conn)
	defer h.hub.Leave(room, conn)
	h.ensurePoller(room, orderID, claims.UserID)

	h.sendStatus(conn, order.Status)

	// Keep the connection open until the client disconnects; inbound
	// messages aren't part of this channel's contract, so they're simply
	// drained.
	for {
		if _, _, err := conn.ReadMessage(); err != nil {
			return
		}
	}
}

func (h *OrderWSHandler) sendStatus(conn *websocket.Conn, status string) {
	b, _ := json.Marshal(map[string]string{"status": status})
	_ = conn.WriteMessage(websocket.TextMessage, b)
}

// ensurePoller starts one background goroutine per order room that polls
// the order's status and broadcasts changes, stopping itself once the room
// empties. This keeps the channel genuinely live without requiring every
// service that can change order status to know about the WS layer.
func (h *OrderWSHandler) ensurePoller(room string, orderID, userID uuid.UUID) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if _, exists := h.pollers[room]; exists {
		return
	}
	ctx, cancel := context.WithCancel(context.Background())
	h.pollers[room] = cancel
	go h.pollLoop(ctx, room, orderID, userID)
}

func (h *OrderWSHandler) pollLoop(ctx context.Context, room string, orderID, userID uuid.UUID) {
	ticker := time.NewTicker(3 * time.Second)
	defer ticker.Stop()
	lastStatus := ""
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			order, err := h.orders.Get(ctx, userID, orderID)
			if err != nil {
				continue
			}
			if order.Status != lastStatus {
				lastStatus = order.Status
				b, _ := json.Marshal(map[string]string{"status": order.Status})
				h.hub.Broadcast(room, b)
			}
			h.mu.Lock()
			empty := !h.hub.HasRoom(room)
			h.mu.Unlock()
			if empty {
				h.stopPoller(room)
				return
			}
		}
	}
}

func (h *OrderWSHandler) stopPoller(room string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if cancel, ok := h.pollers[room]; ok {
		cancel()
		delete(h.pollers, room)
	}
}
