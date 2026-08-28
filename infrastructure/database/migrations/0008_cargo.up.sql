-- Cargo: parcel forwarding from China to Tajikistan and Russia.
--
-- The shopper buys on a Chinese marketplace, ships to YouShop's warehouse
-- address in China, and registers the parcel here with its tracking code.
-- The operator weighs it on arrival; the price is weight × the destination's
-- per-kilo rate. This is a service YouShop resells, so tariffs and the
-- warehouse address are operator-editable data, not constants.

CREATE TABLE IF NOT EXISTS cargo_tariffs (
    destination         char(2) PRIMARY KEY REFERENCES countries(code) ON DELETE CASCADE,
    rate_per_kg         numeric(12,2) NOT NULL DEFAULT 0 CHECK (rate_per_kg >= 0),
    -- Where the shopper tells the Chinese seller to ship. Free text because
    -- it is a Chinese postal address, shown verbatim and copied by the user.
    warehouse_address   text NOT NULL DEFAULT '',
    contact_phone       varchar(32) NOT NULL DEFAULT '',
    estimated_days_min  int,
    estimated_days_max  int,
    is_active           boolean NOT NULL DEFAULT false,
    updated_at          timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS cargo_shipments (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    -- The Chinese carrier's tracking number. Often unknown when the parcel
    -- is registered and filled in later, so it is nullable rather than
    -- blocking registration.
    track_code    varchar(100),
    product_link  text,
    description   text NOT NULL,
    destination   char(2) NOT NULL REFERENCES countries(code),
    -- Both stay 0 until the operator weighs the parcel at the warehouse;
    -- cost is always weight × the destination's rate at that moment, never
    -- back-dated if the tariff later changes.
    weight_kg     numeric(10,3) NOT NULL DEFAULT 0 CHECK (weight_kg >= 0),
    cost          numeric(12,2) NOT NULL DEFAULT 0 CHECK (cost >= 0),
    status        varchar(20) NOT NULL DEFAULT 'new'
                      CHECK (status IN ('new','received','shipped','arrived','delivered','cancelled')),
    note          text,
    created_at    timestamptz NOT NULL DEFAULT now(),
    updated_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_cargo_shipments_user ON cargo_shipments(user_id);
CREATE INDEX IF NOT EXISTS idx_cargo_shipments_status ON cargo_shipments(status);

-- Seeded inactive with empty details: the endpoints hide a destination
-- until an operator has actually filled in a warehouse address and a rate,
-- so the feature cannot quote a price of zero to a real customer.
INSERT INTO cargo_tariffs (destination) VALUES ('TJ'), ('RU')
ON CONFLICT (destination) DO NOTHING;
