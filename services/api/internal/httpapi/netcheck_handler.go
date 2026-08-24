package httpapi

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// NetCheckHandler implements GET /debug/netcheck: a temporary diagnostic
// that GETs a handful of external hosts from wherever the backend is
// actually running and reports success/failure/latency for each. Telegram
// OTP delivery has failed with TLS handshake timeouts (direct) and then a
// bare EOF (via a Cloudflare Worker relay) that never even reached the
// Worker's own logs — this endpoint answers the open question of whether
// the backend's host can reach *any* external HTTPS server at all, or only
// specific ones, without needing to go through the app/OTP flow/rate limits
// to find out. Safe to open directly in a browser; no auth, no side
// effects. Remove once outbound connectivity is understood and fixed.
type NetCheckHandler struct {
	client *http.Client
}

// NewNetCheckHandler builds a NetCheckHandler.
func NewNetCheckHandler() *NetCheckHandler {
	return &NetCheckHandler{client: &http.Client{Timeout: 8 * time.Second}}
}

type netCheckResult struct {
	Label  string `json:"label"`
	URL    string `json:"url"`
	OK     bool   `json:"ok"`
	Status int    `json:"status,omitempty"`
	Error  string `json:"error,omitempty"`
	Ms     int64  `json:"ms"`
}

// Check handles GET /debug/netcheck.
func (h *NetCheckHandler) Check(c *gin.Context) {
	targets := []struct{ Label, URL string }{
		{"github_api", "https://api.github.com"},
		{"google", "https://www.google.com"},
		{"telegram_gateway", "https://gatewayapi.telegram.org/"},
		{"telegram_bot_api", "https://api.telegram.org/"},
		{"cloudflare_worker_debug", "https://marketplace.ehsonmahmadmurodov.workers.dev/__debug"},
	}

	results := make([]netCheckResult, 0, len(targets))
	for _, t := range targets {
		start := time.Now()
		req, err := http.NewRequestWithContext(c.Request.Context(), http.MethodGet, t.URL, nil)
		if err != nil {
			results = append(results, netCheckResult{Label: t.Label, URL: t.URL, OK: false, Error: err.Error()})
			continue
		}
		resp, err := h.client.Do(req)
		ms := time.Since(start).Milliseconds()
		if err != nil {
			results = append(results, netCheckResult{Label: t.Label, URL: t.URL, OK: false, Error: err.Error(), Ms: ms})
			continue
		}
		resp.Body.Close()
		results = append(results, netCheckResult{Label: t.Label, URL: t.URL, OK: true, Status: resp.StatusCode, Ms: ms})
	}

	c.JSON(http.StatusOK, gin.H{"results": results})
}
