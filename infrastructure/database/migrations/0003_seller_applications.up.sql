-- Seller ("become a seller") applications: GPS or social-link store info,
-- passport document keys, and a client-computed liveness/face-match score
-- from the mobile app's on-device verification step. Documents are stored
-- as private object-storage keys (never a public URL — see
-- internal/storage's PresignGet) since passport scans are sensitive PII.
CREATE TABLE seller_applications (
    id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                 uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    birth_date              date NOT NULL,
    store_lat               numeric(9,6),
    store_lng               numeric(9,6),
    store_website           text,
    store_instagram         text,
    store_telegram          text,
    store_whatsapp          text,
    passport_front_key      text NOT NULL,
    passport_back_key       text NOT NULL,
    selfie_with_passport_key text NOT NULL,
    live_selfie_key         text NOT NULL,
    liveness_passed         boolean NOT NULL DEFAULT false,
    face_match_score        numeric(4,3),
    status                  varchar(20) NOT NULL DEFAULT 'pending'
                                CHECK (status IN ('pending','approved','rejected')),
    rejection_reason        text,
    reviewed_at             timestamptz,
    created_at              timestamptz NOT NULL DEFAULT now(),
    updated_at              timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id)
);
CREATE INDEX idx_seller_applications_status ON seller_applications(status);
