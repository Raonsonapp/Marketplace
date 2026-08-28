DROP INDEX IF EXISTS idx_users_email_active;
-- Not reversed: users.phone NOT NULL and otp_codes.phone varchar(20) cannot
-- be restored without discarding rows that no longer satisfy them (accounts
-- registered by email, OTP rows keyed by an address longer than 20 chars).
