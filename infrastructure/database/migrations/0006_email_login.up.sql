-- Email-based login. The OTP code is now delivered to the user's email
-- (Apps Script MailApp relay) rather than by SMS/Telegram, so the value
-- keyed on in otp_codes is an email address, not a phone number:
--   * widen otp_codes.phone (varchar(20)) to hold an email address;
--   * relax users.phone NOT NULL, since an email-registered account has no
--     phone until the user adds one to their profile.
-- Both are widening/relaxing changes: every existing phone-keyed row stays
-- valid and readable.
ALTER TABLE otp_codes ALTER COLUMN phone TYPE varchar(255);
ALTER TABLE users ALTER COLUMN phone DROP NOT NULL;

-- Email is the login lookup key now, so it needs to be indexed for it.
-- (users.email is already UNIQUE, which provides the index; this is a
-- no-op guard for databases where that constraint was ever dropped.)
CREATE INDEX IF NOT EXISTS idx_users_email_active ON users(email) WHERE deleted_at IS NULL;
