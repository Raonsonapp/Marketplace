-- Maps a phone number to the Telegram chat that confirmed it, so the
-- Telegram-Bot OTP delivery path (docs/SMS_PROVIDERS.md) knows where to
-- send the code once a user has opened the verification bot and pressed
-- Start. One phone can only be linked to one chat at a time; re-linking
-- (e.g. a different Telegram account confirming the same phone later)
-- overwrites the previous chat_id.

CREATE TABLE telegram_links (
    phone               varchar(20) PRIMARY KEY,
    chat_id             bigint NOT NULL,
    telegram_username   varchar(255),
    linked_at           timestamptz NOT NULL DEFAULT now()
);
