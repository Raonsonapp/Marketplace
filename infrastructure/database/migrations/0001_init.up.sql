-- TajikShop initial schema
-- Conventions: uuid PKs, numeric(12,2) money in TJS, soft delete via deleted_at.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ========== Identity & access ==========

CREATE TABLE users (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phone           varchar(20) NOT NULL UNIQUE,
    full_name       varchar(255),
    email           varchar(255) UNIQUE,
    role            varchar(20) NOT NULL DEFAULT 'customer'
                        CHECK (role IN ('customer','store_manager','courier','support_agent','admin')),
    avatar_url      text,
    language        varchar(5) NOT NULL DEFAULT 'tj' CHECK (language IN ('tj','ru','en')),
    google_id       varchar(255) UNIQUE,
    is_active       boolean NOT NULL DEFAULT true,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    deleted_at      timestamptz
);
CREATE INDEX idx_users_phone ON users(phone) WHERE deleted_at IS NULL;

CREATE TABLE user_sessions (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    refresh_token_hash  text NOT NULL,
    device_id           varchar(255),
    device_name         varchar(255),
    ip                  inet,
    user_agent          text,
    expires_at          timestamptz NOT NULL,
    revoked_at          timestamptz,
    created_at          timestamptz NOT NULL DEFAULT now(),
    last_used_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_sessions_user ON user_sessions(user_id);
CREATE INDEX idx_sessions_token_hash ON user_sessions(refresh_token_hash);

CREATE TABLE otp_codes (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    phone           varchar(20) NOT NULL,
    code_hash       text NOT NULL,
    purpose         varchar(20) NOT NULL DEFAULT 'login' CHECK (purpose IN ('login','register')),
    attempts        int NOT NULL DEFAULT 0,
    max_attempts    int NOT NULL DEFAULT 5,
    expires_at      timestamptz NOT NULL,
    consumed_at     timestamptz,
    created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_otp_phone ON otp_codes(phone, created_at DESC);

CREATE TABLE device_tokens (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    fcm_token   text NOT NULL,
    platform    varchar(20) NOT NULL DEFAULT 'android',
    created_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, fcm_token)
);

-- ========== Location ==========

CREATE TABLE addresses (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    city        varchar(100) NOT NULL,
    street      text NOT NULL,
    house       varchar(50),
    apartment   varchar(50),
    entrance    varchar(20),
    floor       varchar(20),
    intercom    varchar(50),
    comment     text,
    lat         numeric(9,6),
    lng         numeric(9,6),
    is_default  boolean NOT NULL DEFAULT false,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    deleted_at  timestamptz
);
CREATE INDEX idx_addresses_user ON addresses(user_id) WHERE deleted_at IS NULL;

CREATE TABLE stores (
    id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name                    varchar(255) NOT NULL,
    slug                    varchar(255) NOT NULL UNIQUE,
    logo_url                text,
    address                 text,
    city                    varchar(100) NOT NULL,
    lat                     numeric(9,6),
    lng                     numeric(9,6),
    phone                   varchar(20),
    is_delivery_available   boolean NOT NULL DEFAULT true,
    is_pickup_available     boolean NOT NULL DEFAULT true,
    is_active               boolean NOT NULL DEFAULT true,
    created_at              timestamptz NOT NULL DEFAULT now(),
    updated_at              timestamptz NOT NULL DEFAULT now(),
    deleted_at              timestamptz
);
CREATE INDEX idx_stores_city ON stores(city) WHERE deleted_at IS NULL;

CREATE TABLE store_hours (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id    uuid NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    day_of_week smallint NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    opens_at    time,
    closes_at   time,
    is_closed   boolean NOT NULL DEFAULT false,
    UNIQUE (store_id, day_of_week)
);

CREATE TABLE delivery_zones (
    id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id                    uuid NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    name                        varchar(255) NOT NULL,
    polygon                     jsonb NOT NULL, -- GeoJSON Polygon, provider-agnostic
    delivery_fee                numeric(12,2) NOT NULL DEFAULT 0 CHECK (delivery_fee >= 0),
    min_order_amount            numeric(12,2) NOT NULL DEFAULT 0 CHECK (min_order_amount >= 0),
    free_delivery_threshold     numeric(12,2) CHECK (free_delivery_threshold IS NULL OR free_delivery_threshold >= 0),
    estimated_minutes_min       int,
    estimated_minutes_max       int,
    is_active                   boolean NOT NULL DEFAULT true,
    created_at                  timestamptz NOT NULL DEFAULT now(),
    updated_at                  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_delivery_zones_store ON delivery_zones(store_id);

-- ========== Catalog ==========

CREATE TABLE brands (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name        varchar(255) NOT NULL UNIQUE,
    logo_url    text,
    is_active   boolean NOT NULL DEFAULT true,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE categories (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id   uuid REFERENCES categories(id) ON DELETE SET NULL,
    name_tj     varchar(255) NOT NULL,
    name_ru     varchar(255),
    slug        varchar(255) NOT NULL UNIQUE,
    icon_url    text,
    sort_order  int NOT NULL DEFAULT 0,
    is_active   boolean NOT NULL DEFAULT true,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_categories_parent ON categories(parent_id);

CREATE TABLE products (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sku             varchar(100) NOT NULL UNIQUE,
    barcode         varchar(64),
    brand_id        uuid REFERENCES brands(id) ON DELETE SET NULL,
    category_id     uuid NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name_tj         varchar(500) NOT NULL,
    name_ru         varchar(500),
    description_tj  text,
    description_ru  text,
    unit            varchar(20) NOT NULL DEFAULT 'pcs' CHECK (unit IN ('pcs','kg','g','l','ml')),
    weight          numeric(10,3),
    volume          numeric(10,3),
    base_price      numeric(12,2) NOT NULL CHECK (base_price >= 0),
    old_price       numeric(12,2) CHECK (old_price IS NULL OR old_price >= 0),
    tags            text[] NOT NULL DEFAULT '{}',
    rating_avg      numeric(3,2) NOT NULL DEFAULT 0,
    rating_count    int NOT NULL DEFAULT 0,
    is_active       boolean NOT NULL DEFAULT true,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    deleted_at      timestamptz
);
CREATE INDEX idx_products_category ON products(category_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_products_brand ON products(brand_id);
CREATE INDEX idx_products_barcode ON products(barcode);
CREATE INDEX idx_products_tags ON products USING gin(tags);
CREATE INDEX idx_products_name_tj_trgm ON products USING gin (name_tj gin_trgm_ops);
CREATE INDEX idx_products_name_ru_trgm ON products USING gin (name_ru gin_trgm_ops);

CREATE TABLE product_images (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id  uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    url         text NOT NULL,
    sort_order  int NOT NULL DEFAULT 0,
    created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_product_images_product ON product_images(product_id);

CREATE TABLE inventory (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    store_id        uuid NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    price           numeric(12,2) NOT NULL CHECK (price >= 0),
    old_price       numeric(12,2) CHECK (old_price IS NULL OR old_price >= 0),
    stock_qty       int NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    is_available    boolean NOT NULL DEFAULT true,
    updated_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (product_id, store_id)
);
CREATE INDEX idx_inventory_store ON inventory(store_id);
CREATE INDEX idx_inventory_product ON inventory(product_id);

-- ========== Shopping ==========

CREATE TABLE favorites (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    created_at  timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, product_id)
);

CREATE TABLE carts (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    store_id    uuid REFERENCES stores(id) ON DELETE SET NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE cart_items (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id         uuid NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    product_id      uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity        int NOT NULL CHECK (quantity > 0),
    saved_for_later boolean NOT NULL DEFAULT false,
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (cart_id, product_id)
);

-- ========== Promotions & loyalty (referenced by orders) ==========

CREATE TABLE promo_codes (
    id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code                    varchar(50) NOT NULL UNIQUE,
    discount_type           varchar(20) NOT NULL CHECK (discount_type IN ('percentage','fixed')),
    discount_value          numeric(12,2) NOT NULL CHECK (discount_value >= 0),
    min_order_amount        numeric(12,2) NOT NULL DEFAULT 0,
    max_discount_amount     numeric(12,2),
    starts_at               timestamptz,
    ends_at                 timestamptz,
    usage_limit             int,
    per_user_limit          int NOT NULL DEFAULT 1,
    applicable_categories   uuid[] NOT NULL DEFAULT '{}',
    applicable_products     uuid[] NOT NULL DEFAULT '{}',
    applicable_stores       uuid[] NOT NULL DEFAULT '{}',
    is_active               boolean NOT NULL DEFAULT true,
    created_at              timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE loyalty_accounts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    balance         numeric(12,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
    lifetime_earned numeric(12,2) NOT NULL DEFAULT 0,
    tier            varchar(20) NOT NULL DEFAULT 'standard',
    updated_at      timestamptz NOT NULL DEFAULT now()
);

-- ========== Orders & delivery ==========

CREATE TABLE couriers (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         uuid NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    vehicle_type    varchar(50),
    is_active       boolean NOT NULL DEFAULT true,
    current_lat     numeric(9,6),
    current_lng     numeric(9,6),
    updated_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE orders (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number        varchar(20) NOT NULL UNIQUE,
    user_id             uuid NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    store_id            uuid NOT NULL REFERENCES stores(id) ON DELETE RESTRICT,
    address_id          uuid REFERENCES addresses(id) ON DELETE SET NULL,
    delivery_method     varchar(20) NOT NULL CHECK (delivery_method IN ('delivery','pickup')),
    status              varchar(30) NOT NULL DEFAULT 'pending'
                            CHECK (status IN ('pending','confirmed','preparing','ready',
                                'courier_assigned','picked_up','delivering','delivered','cancelled')),
    payment_method      varchar(30) NOT NULL DEFAULT 'cash_on_delivery',
    payment_status      varchar(20) NOT NULL DEFAULT 'pending' CHECK (payment_status IN ('pending','paid','failed','refunded')),
    subtotal            numeric(12,2) NOT NULL CHECK (subtotal >= 0),
    discount_amount     numeric(12,2) NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
    delivery_fee        numeric(12,2) NOT NULL DEFAULT 0 CHECK (delivery_fee >= 0),
    bonus_used          numeric(12,2) NOT NULL DEFAULT 0 CHECK (bonus_used >= 0),
    bonus_earned        numeric(12,2) NOT NULL DEFAULT 0 CHECK (bonus_earned >= 0),
    promo_code_id       uuid REFERENCES promo_codes(id) ON DELETE SET NULL,
    total               numeric(12,2) NOT NULL CHECK (total >= 0),
    scheduled_at        timestamptz,
    courier_id          uuid REFERENCES couriers(id) ON DELETE SET NULL,
    delivery_note       text,
    cancelled_reason    text,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_orders_user ON orders(user_id, created_at DESC);
CREATE INDEX idx_orders_store ON orders(store_id);
CREATE INDEX idx_orders_status ON orders(status);

CREATE TABLE order_items (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id      uuid NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    name_snapshot   varchar(500) NOT NULL,
    unit_price      numeric(12,2) NOT NULL CHECK (unit_price >= 0),
    quantity        int NOT NULL CHECK (quantity > 0),
    total_price     numeric(12,2) NOT NULL CHECK (total_price >= 0)
);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

CREATE TABLE order_status_history (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id    uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    status      varchar(30) NOT NULL,
    note        text,
    changed_by  uuid REFERENCES users(id) ON DELETE SET NULL,
    created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_order_status_history_order ON order_status_history(order_id);

CREATE TABLE delivery_slots (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    store_id        uuid NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    date            date NOT NULL,
    start_time      time NOT NULL,
    end_time        time NOT NULL,
    capacity        int NOT NULL DEFAULT 0,
    booked_count    int NOT NULL DEFAULT 0
);
CREATE INDEX idx_delivery_slots_store_date ON delivery_slots(store_id, date);

CREATE TABLE receipts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id        uuid NOT NULL UNIQUE REFERENCES orders(id) ON DELETE CASCADE,
    receipt_number  varchar(30) NOT NULL UNIQUE,
    issued_at       timestamptz NOT NULL DEFAULT now(),
    payload         jsonb NOT NULL
);

CREATE TABLE promo_code_usage (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    promo_code_id   uuid NOT NULL REFERENCES promo_codes(id) ON DELETE CASCADE,
    user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id        uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    used_at         timestamptz NOT NULL DEFAULT now(),
    UNIQUE (promo_code_id, order_id)
);
CREATE INDEX idx_promo_usage_user ON promo_code_usage(promo_code_id, user_id);

CREATE TABLE loyalty_transactions (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    loyalty_account_id  uuid NOT NULL REFERENCES loyalty_accounts(id) ON DELETE CASCADE,
    order_id            uuid REFERENCES orders(id) ON DELETE SET NULL,
    type                varchar(20) NOT NULL CHECK (type IN ('earn','spend','expire','adjust','campaign')),
    amount              numeric(12,2) NOT NULL,
    balance_after       numeric(12,2) NOT NULL,
    description         text,
    expires_at          timestamptz,
    created_at          timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_loyalty_tx_account ON loyalty_transactions(loyalty_account_id, created_at DESC);

CREATE TABLE discounts (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name            varchar(255) NOT NULL,
    scope           varchar(20) NOT NULL CHECK (scope IN ('user','category','product','campaign')),
    user_id         uuid REFERENCES users(id) ON DELETE CASCADE,
    category_id     uuid REFERENCES categories(id) ON DELETE CASCADE,
    product_id      uuid REFERENCES products(id) ON DELETE CASCADE,
    discount_type   varchar(20) NOT NULL CHECK (discount_type IN ('percentage','fixed')),
    discount_value  numeric(12,2) NOT NULL CHECK (discount_value >= 0),
    starts_at       timestamptz,
    ends_at         timestamptz,
    is_active       boolean NOT NULL DEFAULT true,
    created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_discounts_user ON discounts(user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_discounts_category ON discounts(category_id) WHERE category_id IS NOT NULL;
CREATE INDEX idx_discounts_product ON discounts(product_id) WHERE product_id IS NOT NULL;

-- ========== Engagement ==========

CREATE TABLE reviews (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id      uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_item_id   uuid NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    rating          smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
    text            text,
    status          varchar(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','approved','hidden')),
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    UNIQUE (user_id, product_id, order_item_id)
);
CREATE INDEX idx_reviews_product ON reviews(product_id) WHERE status = 'approved';

CREATE TABLE review_images (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    review_id   uuid NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    url         text NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE notifications (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type        varchar(30) NOT NULL,
    title       varchar(255) NOT NULL,
    body        text,
    data        jsonb NOT NULL DEFAULT '{}',
    is_read     boolean NOT NULL DEFAULT false,
    created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_notifications_user ON notifications(user_id, created_at DESC);

CREATE TABLE notification_preferences (
    user_id             uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    orders              boolean NOT NULL DEFAULT true,
    promotions          boolean NOT NULL DEFAULT true,
    personal_offers     boolean NOT NULL DEFAULT true,
    bonus_updates       boolean NOT NULL DEFAULT true,
    new_products        boolean NOT NULL DEFAULT true
);

-- ========== Support ==========

CREATE TABLE support_conversations (
    id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id            uuid REFERENCES orders(id) ON DELETE SET NULL,
    status              varchar(20) NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed')),
    assigned_agent_id   uuid REFERENCES users(id) ON DELETE SET NULL,
    created_at          timestamptz NOT NULL DEFAULT now(),
    updated_at          timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_support_conv_user ON support_conversations(user_id);

CREATE TABLE support_messages (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id uuid NOT NULL REFERENCES support_conversations(id) ON DELETE CASCADE,
    sender_id       uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sender_role     varchar(20) NOT NULL,
    text            text,
    image_url       text,
    is_read         boolean NOT NULL DEFAULT false,
    created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_support_messages_conv ON support_messages(conversation_id, created_at);

-- ========== Governance ==========

CREATE TABLE audit_logs (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_id    uuid REFERENCES users(id) ON DELETE SET NULL,
    action      varchar(100) NOT NULL,
    entity_type varchar(50) NOT NULL,
    entity_id   uuid,
    metadata    jsonb NOT NULL DEFAULT '{}',
    created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
