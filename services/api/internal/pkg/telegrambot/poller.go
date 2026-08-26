// Package telegrambot receives updates from a Telegram bot (long polling —
// no public webhook needed, so it works from any single-instance
// deployment including a Hugging Face Space) and turns each `/start
// <payload>` message into a phone->chat_id link, completing the other half
// of otp.TelegramBotSender's delivery flow (see docs/SMS_PROVIDERS.md).
package telegrambot

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
	"time"

	"tajikshop/api/internal/pkg/otp"
)

// LinkStore persists a confirmed phone->chat_id link, via
// internal/repository.TelegramLinkLookupAdapter.
type LinkStore interface {
	Upsert(ctx context.Context, phone string, chatID int64, username string) error
}

// Poller long-polls Telegram's getUpdates endpoint for messages sent to the
// verification bot.
type Poller struct {
	token      string
	store      LinkStore
	httpClient *http.Client
	baseURL    string
}

// NewPoller builds a Poller for the bot identified by token
// (TELEGRAM_BOT_TOKEN).
func NewPoller(token string, store LinkStore) *Poller {
	return &Poller{
		token:      token,
		store:      store,
		httpClient: &http.Client{Timeout: 35 * time.Second},
		baseURL:    "https://api.telegram.org",
	}
}

type telegramUpdate struct {
	UpdateID int64 `json:"update_id"`
	Message  *struct {
		Text string `json:"text"`
		Chat struct {
			ID int64 `json:"id"`
		} `json:"chat"`
		From struct {
			Username string `json:"username"`
		} `json:"from"`
	} `json:"message"`
}

type getUpdatesResponse struct {
	OK     bool             `json:"ok"`
	Result []telegramUpdate `json:"result"`
}

// Run polls until ctx is cancelled. Meant to be started in its own
// goroutine from cmd/server/main.go, mirroring internal/jobs's background
// task pattern.
func (p *Poller) Run(ctx context.Context) {
	var offset int64
	for {
		select {
		case <-ctx.Done():
			return
		default:
		}

		updates, err := p.getUpdates(ctx, offset)
		if err != nil {
			if ctx.Err() != nil {
				return
			}
			log.Printf("telegrambot: getUpdates: %v", err)
			time.Sleep(5 * time.Second)
			continue
		}

		for _, u := range updates {
			offset = u.UpdateID + 1
			p.handleUpdate(ctx, u)
		}
	}
}

func (p *Poller) getUpdates(ctx context.Context, offset int64) ([]telegramUpdate, error) {
	url := fmt.Sprintf("%s/bot%s/getUpdates?offset=%d&timeout=30", p.baseURL, p.token, offset)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, err
	}
	resp, err := p.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	var parsed getUpdatesResponse
	if err := json.Unmarshal(body, &parsed); err != nil {
		return nil, fmt.Errorf("parse response: %w", err)
	}
	if !parsed.OK {
		return nil, fmt.Errorf("telegram API returned ok=false: %s", string(body))
	}
	return parsed.Result, nil
}

func (p *Poller) handleUpdate(ctx context.Context, u telegramUpdate) {
	if u.Message == nil {
		return
	}
	text := strings.TrimSpace(u.Message.Text)
	if !strings.HasPrefix(text, "/start") {
		return
	}
	payload := strings.TrimSpace(strings.TrimPrefix(text, "/start"))
	if payload == "" {
		p.reply(ctx, u.Message.Chat.ID, "Барои тасдиқи рақами телефон, лутфан аз барномаи YouShop \"Гирифтани рамз\"-ро пахш кунед.")
		return
	}

	phone, err := otp.DecodePhoneFromStartPayload(payload)
	if err != nil {
		log.Printf("telegrambot: bad start payload %q: %v", payload, err)
		return
	}

	if err := p.store.Upsert(ctx, phone, u.Message.Chat.ID, u.Message.From.Username); err != nil {
		log.Printf("telegrambot: link %s: %v", phone, err)
		p.reply(ctx, u.Message.Chat.ID, "Хатогӣ рӯй дод. Лутфан аз нав кӯшиш кунед.")
		return
	}

	p.reply(ctx, u.Message.Chat.ID, "✅ Рақами телефони шумо тасдиқ шуд. Ба барномаи YouShop баргардед ва \"Гирифтани рамз\"-ро аз нав пахш кунед.")
}

// Owner alerts (new seller application, new support message) are sent by
// AdminNotifier (adminnotify.go), which — unlike this poller's own direct
// calls — can route through the OTP relay when api.telegram.org is
// unreachable from this host.

func (p *Poller) reply(ctx context.Context, chatID int64, text string) {
	body, err := json.Marshal(map[string]any{"chat_id": chatID, "text": text})
	if err != nil {
		return
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		p.baseURL+"/bot"+p.token+"/sendMessage", strings.NewReader(string(body)))
	if err != nil {
		return
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := p.httpClient.Do(req)
	if err != nil {
		log.Printf("telegrambot: reply to %d failed: %v", chatID, err)
		return
	}
	defer resp.Body.Close()
}
