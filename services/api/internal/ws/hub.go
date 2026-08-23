// Package ws implements the realtime WebSocket endpoints from
// docs/API_SPEC.md (WS /ws/orders/:orderId, WS /ws/support/:conversationId).
// Phase 2 wires the order-status channel end to end (order cancellation
// pushes a live update); the support chat channel is Phase 5 scope per
// docs/ARCHITECTURE.md's feature matrix, so only the shared Hub primitive
// is provided for it to build on later.
package ws

import (
	"sync"

	"github.com/gorilla/websocket"
)

// Hub is a minimal, real (not mocked) pub/sub registry of WebSocket
// connections grouped by room key (e.g. an order id). It is safe for
// concurrent use.
type Hub struct {
	mu    sync.RWMutex
	rooms map[string]map[*websocket.Conn]bool
}

// NewHub builds an empty Hub.
func NewHub() *Hub {
	return &Hub{rooms: make(map[string]map[*websocket.Conn]bool)}
}

// Join registers a connection under room.
func (h *Hub) Join(room string, conn *websocket.Conn) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.rooms[room] == nil {
		h.rooms[room] = make(map[*websocket.Conn]bool)
	}
	h.rooms[room][conn] = true
}

// HasRoom reports whether room currently has at least one connection.
func (h *Hub) HasRoom(room string) bool {
	h.mu.RLock()
	defer h.mu.RUnlock()
	return len(h.rooms[room]) > 0
}

// Leave unregisters a connection from room.
func (h *Hub) Leave(room string, conn *websocket.Conn) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if peers, ok := h.rooms[room]; ok {
		delete(peers, conn)
		if len(peers) == 0 {
			delete(h.rooms, room)
		}
	}
}

// Broadcast sends a JSON text message to every connection currently in room.
// Write errors are treated as "peer gone" and the connection is dropped
// from the room rather than propagated, since a broadcast should never fail
// just because one viewer disconnected.
func (h *Hub) Broadcast(room string, message []byte) {
	h.mu.RLock()
	peers := make([]*websocket.Conn, 0, len(h.rooms[room]))
	for conn := range h.rooms[room] {
		peers = append(peers, conn)
	}
	h.mu.RUnlock()

	for _, conn := range peers {
		if err := conn.WriteMessage(websocket.TextMessage, message); err != nil {
			h.Leave(room, conn)
			_ = conn.Close()
		}
	}
}
