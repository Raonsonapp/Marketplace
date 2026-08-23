-- TajikShop Phase 2 development seed data.
-- All names/phones/addresses below are fictional, for local development and testing only.
-- Safe to re-run: every INSERT is idempotent via ON CONFLICT.

BEGIN;

-- ========== Stores ==========
INSERT INTO stores (id, name, slug, address, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active)
VALUES ('00000000-0000-0000-0001-000000000001', 'TajikShop Душанбе Марказ', 'dushanbe-center', 'кӯчаи Рӯдакӣ, 25', 'Душанбе', 38.5598, 68.787, '+992370010001', true, true, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO stores (id, name, slug, address, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active)
VALUES ('00000000-0000-0000-0001-000000000002', 'TajikShop Хуҷанд', 'khujand-main', 'кӯчаи Ленин, 12', 'Хуҷанд', 40.2833, 69.6333, '+992340010002', true, true, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO stores (id, name, slug, address, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active)
VALUES ('00000000-0000-0000-0001-000000000003', 'TajikShop Вахдат', 'vahdat-market', 'кӯчаи Истиқлол, 5', 'Ваҳдат', 38.5597, 69.0286, '+992318010003', true, true, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO stores (id, name, slug, address, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active)
VALUES ('00000000-0000-0000-0001-000000000004', 'TajikShop Ҳисор', 'hisor-plaza', 'кӯчаи Сомонӣ, 8', 'Ҳисор', 38.4531, 68.5322, '+992318010004', true, true, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO stores (id, name, slug, address, city, lat, lng, phone, is_delivery_available, is_pickup_available, is_active)
VALUES ('00000000-0000-0000-0001-000000000005', 'TajikShop Кӯлоб', 'kulob-central', 'кӯчаи Айнӣ, 3', 'Кӯлоб', 37.9139, 69.7822, '+992332010005', true, true, true)
ON CONFLICT (slug) DO NOTHING;

-- Store hours: every day 08:00-22:00, no closures.
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 0, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 1, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 2, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 3, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 4, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 5, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 6, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 0, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 1, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 2, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 3, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 4, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 5, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 6, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 0, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 1, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 2, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 3, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 4, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 5, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 6, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 0, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 1, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 2, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 3, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 4, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 5, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 6, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 0, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 1, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 2, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 3, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 4, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 5, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;
INSERT INTO store_hours (store_id, day_of_week, opens_at, closes_at, is_closed)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 6, '08:00', '22:00', false
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
ON CONFLICT (store_id, day_of_week) DO NOTHING;

-- Delivery zones: one citywide bounding-box polygon per store.
INSERT INTO delivery_zones (store_id, name, polygon, delivery_fee, min_order_amount, free_delivery_threshold, estimated_minutes_min, estimated_minutes_max, is_active)
SELECT '00000000-0000-0000-0001-000000000001'::uuid, 'Шаҳр', '{"type":"Polygon","coordinates":[[[68.637,38.409800000000004],[68.93700000000001,38.409800000000004],[68.93700000000001,38.7098],[68.637,38.7098],[68.637,38.409800000000004]]]}'::jsonb, 15.00, 30.00, 300.00, 30, 75, true
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000001'::uuid)
AND NOT EXISTS (SELECT 1 FROM delivery_zones WHERE store_id = '00000000-0000-0000-0001-000000000001'::uuid);
INSERT INTO delivery_zones (store_id, name, polygon, delivery_fee, min_order_amount, free_delivery_threshold, estimated_minutes_min, estimated_minutes_max, is_active)
SELECT '00000000-0000-0000-0001-000000000002'::uuid, 'Шаҳр', '{"type":"Polygon","coordinates":[[[69.4833,40.1333],[69.78330000000001,40.1333],[69.78330000000001,40.433299999999996],[69.4833,40.433299999999996],[69.4833,40.1333]]]}'::jsonb, 15.00, 30.00, 300.00, 30, 75, true
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000002'::uuid)
AND NOT EXISTS (SELECT 1 FROM delivery_zones WHERE store_id = '00000000-0000-0000-0001-000000000002'::uuid);
INSERT INTO delivery_zones (store_id, name, polygon, delivery_fee, min_order_amount, free_delivery_threshold, estimated_minutes_min, estimated_minutes_max, is_active)
SELECT '00000000-0000-0000-0001-000000000003'::uuid, 'Шаҳр', '{"type":"Polygon","coordinates":[[[68.87859999999999,38.4097],[69.1786,38.4097],[69.1786,38.7097],[68.87859999999999,38.7097],[68.87859999999999,38.4097]]]}'::jsonb, 15.00, 30.00, 300.00, 30, 75, true
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000003'::uuid)
AND NOT EXISTS (SELECT 1 FROM delivery_zones WHERE store_id = '00000000-0000-0000-0001-000000000003'::uuid);
INSERT INTO delivery_zones (store_id, name, polygon, delivery_fee, min_order_amount, free_delivery_threshold, estimated_minutes_min, estimated_minutes_max, is_active)
SELECT '00000000-0000-0000-0001-000000000004'::uuid, 'Шаҳр', '{"type":"Polygon","coordinates":[[[68.3822,38.3031],[68.68220000000001,38.3031],[68.68220000000001,38.6031],[68.3822,38.6031],[68.3822,38.3031]]]}'::jsonb, 15.00, 30.00, 300.00, 30, 75, true
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000004'::uuid)
AND NOT EXISTS (SELECT 1 FROM delivery_zones WHERE store_id = '00000000-0000-0000-0001-000000000004'::uuid);
INSERT INTO delivery_zones (store_id, name, polygon, delivery_fee, min_order_amount, free_delivery_threshold, estimated_minutes_min, estimated_minutes_max, is_active)
SELECT '00000000-0000-0000-0001-000000000005'::uuid, 'Шаҳр', '{"type":"Polygon","coordinates":[[[69.6322,37.7639],[69.93220000000001,37.7639],[69.93220000000001,38.0639],[69.6322,38.0639],[69.6322,37.7639]]]}'::jsonb, 15.00, 30.00, 300.00, 30, 75, true
WHERE EXISTS (SELECT 1 FROM stores WHERE id = '00000000-0000-0000-0001-000000000005'::uuid)
AND NOT EXISTS (SELECT 1 FROM delivery_zones WHERE store_id = '00000000-0000-0000-0001-000000000005'::uuid);

-- ========== Brands ==========
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000001', 'Файзи Хуҷанд', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000002', 'Ваҳдат Агро', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000003', 'Помир Фреш', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000004', 'Дӯстӣ Milk', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000005', 'Кӯҳсор', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000006', 'Сомон Foods', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000007', 'TajMilk', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000008', 'Суғд Нонворӣ', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000009', 'Green Vahdat', true)
ON CONFLICT (name) DO NOTHING;
INSERT INTO brands (id, name, is_active) VALUES ('00000000-0000-0000-0002-000000000010', 'Кӯлоб Органик', true)
ON CONFLICT (name) DO NOTHING;

-- ========== Categories ==========
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000001', 'Хӯрокворӣ', 'Groceries', 'groceries', 1, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000002', 'Нӯшокиҳо', 'Beverages', 'beverages', 2, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000003', 'Мева', 'Fruit', 'fruits', 3, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000004', 'Сабзавот', 'Vegetables', 'vegetables', 4, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000005', 'Шириниҳо', 'Sweets', 'sweets', 5, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000006', 'Маҳсулоти ширӣ', 'Dairy', 'dairy', 6, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000007', 'Гӯшт', 'Meat', 'meat', 7, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000008', 'Маҳсулоти рӯзгор', 'Household', 'household', 8, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000009', 'Косметика', 'Cosmetics', 'cosmetics', 9, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000010', 'Гигиена', 'Hygiene', 'hygiene', 10, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000011', 'Барои кӯдакон', 'Kids', 'kids', 11, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000012', 'Маҳсулоти хона', 'Home goods', 'home-goods', 12, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000013', 'Нонворӣ', 'Bakery', 'bakery', 13, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000014', 'Мурғ ва тухм', 'Poultry & eggs', 'poultry-eggs', 14, true)
ON CONFLICT (slug) DO NOTHING;
INSERT INTO categories (id, name_tj, name_ru, slug, sort_order, is_active)
VALUES ('00000000-0000-0000-0003-000000000015', 'Ҳайвоноти хонагӣ', 'Pet products', 'pet-products', 15, true)
ON CONFLICT (slug) DO NOTHING;

-- ========== Products ==========
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000001', 'TS-00001', '2990000000001', NULL::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Орди гандум', 'kg', 12.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000002', 'TS-00002', '2990000000002', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Шакар', 'kg', 9.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000003', 'TS-00003', '2990000000003', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Намак', 'kg', 3.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000004', 'TS-00004', '2990000000004', NULL::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Равғани офтобпарст', 'l', 22.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000005', 'TS-00005', '2990000000005', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Биринҷи девзира', 'kg', 28.0, 33.6, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000006', 'TS-00006', '2990000000006', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Макарон', 'pcs', 8.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000007', 'TS-00007', '2990000000007', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Лӯбиё', 'kg', 18.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000008', 'TS-00008', '2990000000008', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000001'::uuid, 'Нахуд', 'kg', 16.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000001'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000009', 'TS-00009', '2990000000009', NULL::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Оби маъдании Зулол', 'l', 4.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000010', 'TS-00010', '2990000000010', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Шарбати себ', 'l', 15.0, 18.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000011', 'TS-00011', '2990000000011', NULL::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Нӯшокии газдор Кола', 'l', 12.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000012', 'TS-00012', '2990000000012', NULL::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Чойи сиёҳ', 'pcs', 25.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000013', 'TS-00013', '2990000000013', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Чойи сабз', 'pcs', 27.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000014', 'TS-00014', '2990000000014', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Қаҳваи растворимӣ', 'pcs', 45.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000015', 'TS-00015', '2990000000015', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Компоти меваҷот', 'l', 18.0, 21.6, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000016', 'TS-00016', '2990000000016', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000002'::uuid, 'Лимонади хонагӣ', 'l', 10.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000002'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000017', 'TS-00017', '2990000000017', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Себи сурх', 'kg', 14.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000018', 'TS-00018', '2990000000018', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Ноки тобистона', 'kg', 16.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000019', 'TS-00019', '2990000000019', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Ангури бедона', 'kg', 22.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000020', 'TS-00020', '2990000000020', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Банан', 'kg', 18.5, 22.2, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000021', 'TS-00021', '2990000000021', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Афлесун', 'kg', 15.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000022', 'TS-00022', '2990000000022', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Хурмо', 'kg', 24.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000023', 'TS-00023', '2990000000023', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Анор', 'kg', 20.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000024', 'TS-00024', '2990000000024', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000003'::uuid, 'Тарбуз', 'kg', 6.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000003'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000025', 'TS-00025', '2990000000025', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Картошка', 'kg', 5.5, 6.6, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000026', 'TS-00026', '2990000000026', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Пиёзи зард', 'kg', 4.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000027', 'TS-00027', '2990000000027', NULL::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Сирпиёз', 'kg', 25.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000028', 'TS-00028', '2990000000028', NULL::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Помидор', 'kg', 9.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000029', 'TS-00029', '2990000000029', NULL::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Бодиринг', 'kg', 8.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000030', 'TS-00030', '2990000000030', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Карами сафед', 'kg', 4.5, 5.4, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000031', 'TS-00031', '2990000000031', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Сабзӣ', 'kg', 5.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000032', 'TS-00032', '2990000000032', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000004'::uuid, 'Қалампири булғорӣ', 'kg', 17.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000004'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000033', 'TS-00033', '2990000000033', '00000000-0000-0000-0002-000000000008'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Шоколади Помир', 'pcs', 18.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000034', 'TS-00034', '2990000000034', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Печеньеи ватанӣ', 'kg', 32.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000035', 'TS-00035', '2990000000035', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Мармелад', 'kg', 28.0, 33.6, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000036', 'TS-00036', '2990000000036', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Ҳалвои офтобпарст', 'kg', 35.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000037', 'TS-00037', '2990000000037', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Вафли бо шир', 'pcs', 14.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000038', 'TS-00038', '2990000000038', NULL::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Конфети ассортӣ', 'kg', 55.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000039', 'TS-00039', '2990000000039', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Торти шоколадӣ', 'pcs', 85.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000040', 'TS-00040', '2990000000040', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000005'::uuid, 'Асали кӯҳӣ', 'kg', 95.0, 114.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000005'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000041', 'TS-00041', '2990000000041', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Шири тару тоза', 'l', 12.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000042', 'TS-00042', '2990000000042', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Йогурти мевагӣ', 'pcs', 8.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000043', 'TS-00043', '2990000000043', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Панири гӯсфандӣ', 'kg', 65.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000044', 'TS-00044', '2990000000044', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Сметана', 'pcs', 15.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000045', 'TS-00045', '2990000000045', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Каймоқ', 'kg', 45.0, 54.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000046', 'TS-00046', '2990000000046', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Равғани маска', 'kg', 75.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000047', 'TS-00047', '2990000000047', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Творог', 'kg', 38.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000048', 'TS-00048', '2990000000048', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000006'::uuid, 'Кефир', 'l', 11.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000006'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000049', 'TS-00049', '2990000000049', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Гӯшти гов', 'kg', 95.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000050', 'TS-00050', '2990000000050', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Гӯшти гӯсфанд', 'kg', 110.0, 132.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000051', 'TS-00051', '2990000000051', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Гӯшти мурғ', 'kg', 45.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000052', 'TS-00052', '2990000000052', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Колбасаи докторӣ', 'kg', 68.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000053', 'TS-00053', '2990000000053', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Сосиска', 'kg', 55.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000054', 'TS-00054', '2990000000054', NULL::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Гӯшти қима', 'kg', 90.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000055', 'TS-00055', '2990000000055', '00000000-0000-0000-0002-000000000008'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Ветчина', 'kg', 72.0, 86.4, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000056', 'TS-00056', '2990000000056', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000007'::uuid, 'Моҳии яхкардашуда', 'kg', 60.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000007'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000057', 'TS-00057', '2990000000057', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Собуни зарфшӯӣ', 'pcs', 12.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000058', 'TS-00058', '2990000000058', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Порошоки ҷомашӯӣ', 'kg', 38.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000059', 'TS-00059', '2990000000059', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Хушбӯйкунандаи ҳаво', 'pcs', 22.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000060', 'TS-00060', '2990000000060', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Қоғази тувалет', 'pcs', 15.0, 18.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000061', 'TS-00061', '2990000000061', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Дастмоли коғазӣ', 'pcs', 10.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000062', 'TS-00062', '2990000000062', NULL::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Халтаи партов', 'pcs', 14.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000063', 'TS-00063', '2990000000063', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Шамъ', 'pcs', 6.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000064', 'TS-00064', '2990000000064', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000008'::uuid, 'Батарейка', 'pcs', 9.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000008'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000065', 'TS-00065', '2990000000065', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Крем барои рӯй', 'pcs', 42.0, 50.4, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000066', 'TS-00066', '2990000000066', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Шампуни мӯй', 'pcs', 28.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000067', 'TS-00067', '2990000000067', NULL::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Атри занона', 'pcs', 120.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000068', 'TS-00068', '2990000000068', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Лосиони бадан', 'pcs', 35.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000069', 'TS-00069', '2990000000069', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Помада', 'pcs', 25.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000070', 'TS-00070', '2990000000070', NULL::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Лак барои нохун', 'pcs', 18.0, 21.6, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000071', 'TS-00071', '2990000000071', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Крем барои дастҳо', 'pcs', 20.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000072', 'TS-00072', '2990000000072', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000009'::uuid, 'Гели душ', 'pcs', 30.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000009'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000073', 'TS-00073', '2990000000073', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Хамираи дандон', 'pcs', 14.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000074', 'TS-00074', '2990000000074', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Щеткаи дандон', 'pcs', 9.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000075', 'TS-00075', '2990000000075', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Собуни ҳаммом', 'pcs', 7.5, 9.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000076', 'TS-00076', '2990000000076', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Дезодорант', 'pcs', 24.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000077', 'TS-00077', '2990000000077', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Дастмоли тар', 'pcs', 12.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000078', 'TS-00078', '2990000000078', '00000000-0000-0000-0002-000000000008'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Прокладкаи гигиенӣ', 'pcs', 16.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000079', 'TS-00079', '2990000000079', NULL::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Ватаи гӯш', 'pcs', 8.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000080', 'TS-00080', '2990000000080', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000010'::uuid, 'Ришгираки якборамасрафӣ', 'pcs', 11.0, 13.2, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000010'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000081', 'TS-00081', '2990000000081', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Тагбанди кӯдакона', 'pcs', 65.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000082', 'TS-00082', '2990000000082', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Хӯроки кӯдакона', 'pcs', 32.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000083', 'TS-00083', '2990000000083', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Шираи кӯдакона', 'pcs', 85.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000084', 'TS-00084', '2990000000084', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Асбоби бозӣ', 'pcs', 45.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000085', 'TS-00085', '2990000000085', NULL::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Шампуни кӯдакона', 'pcs', 26.0, 31.2, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000086', 'TS-00086', '2990000000086', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Бутилкаи кӯдакона', 'pcs', 38.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000087', 'TS-00087', '2990000000087', NULL::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Пудраи кӯдак', 'pcs', 22.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000088', 'TS-00088', '2990000000088', NULL::uuid, '00000000-0000-0000-0003-000000000011'::uuid, 'Дастмоли тари кӯдакона', 'pcs', 18.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000011'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000089', 'TS-00089', '2990000000089', NULL::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Зарфи ошпазӣ', 'pcs', 150.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000090', 'TS-00090', '2990000000090', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Табақча', 'pcs', 25.0, 30.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000091', 'TS-00091', '2990000000091', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Пиёла', 'pcs', 15.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000092', 'TS-00092', '2990000000092', NULL::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Қошуқ', 'pcs', 8.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000093', 'TS-00093', '2990000000093', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Корд', 'pcs', 35.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000094', 'TS-00094', '2990000000094', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Чойник', 'pcs', 95.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000095', 'TS-00095', '2990000000095', NULL::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Сатил', 'pcs', 40.0, 48.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000096', 'TS-00096', '2990000000096', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000012'::uuid, 'Термос', 'pcs', 110.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000012'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000097', 'TS-00097', '2990000000097', '00000000-0000-0000-0002-000000000003'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Нони ансамбурӣ', 'pcs', 4.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000098', 'TS-00098', '2990000000098', '00000000-0000-0000-0002-000000000008'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Лаваш', 'pcs', 6.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000099', 'TS-00099', '2990000000099', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Кулчаи Хуҷанд', 'pcs', 5.5, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000100', 'TS-00100', '2990000000100', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Круассон', 'pcs', 12.0, 14.4, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000101', 'TS-00101', '2990000000101', NULL::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Пирожки бо гӯшт', 'pcs', 8.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000102', 'TS-00102', '2990000000102', NULL::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Пряник', 'kg', 30.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000103', 'TS-00103', '2990000000103', '00000000-0000-0000-0002-000000000009'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Булочка бо мураббо', 'pcs', 7.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000104', 'TS-00104', '2990000000104', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000013'::uuid, 'Тортики хурд', 'pcs', 10.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000013'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000105', 'TS-00105', '2990000000105', NULL::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Тухми мурғ', 'pcs', 1.5, 1.8, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000106', 'TS-00106', '2990000000106', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Гӯшти мурғи яхкардашуда', 'kg', 42.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000107', 'TS-00107', '2990000000107', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Рони мурғ', 'kg', 38.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000108', 'TS-00108', '2990000000108', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Синаи мурғ', 'kg', 50.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000109', 'TS-00109', '2990000000109', '00000000-0000-0000-0002-000000000001'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Гӯшти бедана', 'kg', 85.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000110', 'TS-00110', '2990000000110', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Тухми бедана', 'pcs', 2.5, 3.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000111', 'TS-00111', '2990000000111', '00000000-0000-0000-0002-000000000007'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Мурғи пухта', 'pcs', 55.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000112', 'TS-00112', '2990000000112', '00000000-0000-0000-0002-000000000005'::uuid, '00000000-0000-0000-0003-000000000014'::uuid, 'Ҷигари мурғ', 'kg', 35.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000014'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000113', 'TS-00113', '2990000000113', '00000000-0000-0000-0002-000000000002'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Хӯроки саг', 'kg', 48.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000114', 'TS-00114', '2990000000114', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Хӯроки гурба', 'kg', 52.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000115', 'TS-00115', '2990000000115', '00000000-0000-0000-0002-000000000010'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Қуми гурба', 'kg', 30.0, 36.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000116', 'TS-00116', '2990000000116', NULL::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Асбоби бозии ҳайвонот', 'pcs', 20.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000117', 'TS-00117', '2990000000117', '00000000-0000-0000-0002-000000000006'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Тасмаи саг', 'pcs', 35.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000118', 'TS-00118', '2990000000118', '00000000-0000-0000-0002-000000000004'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Шампуни ҳайвонот', 'pcs', 28.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000119', 'TS-00119', '2990000000119', NULL::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Косаи хӯрокхӯрӣ', 'pcs', 22.0, NULL, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;
INSERT INTO products (id, sku, barcode, brand_id, category_id, name_tj, unit, base_price, old_price, is_active)
SELECT '00000000-0000-0000-0004-000000000120', 'TS-00120', '2990000000120', '00000000-0000-0000-0002-000000000008'::uuid, '00000000-0000-0000-0003-000000000015'::uuid, 'Витамини ҳайвонот', 'pcs', 40.0, 48.0, true
WHERE EXISTS (SELECT 1 FROM categories WHERE id = '00000000-0000-0000-0003-000000000015'::uuid)
ON CONFLICT (sku) DO NOTHING;

-- ========== Inventory (per-store price/stock) ==========
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000001'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 12.28, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000001'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000001'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 12.75, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000001'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000001'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 12.82, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000001'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000001'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 12.52, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000001'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000002'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 9.43, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000002'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000002'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 8.68, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000002'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000002'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.74, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000002'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000003'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 3.6, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000003'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000003'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 3.57, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000003'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000003'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 3.72, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000003'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000003'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 3.64, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000003'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000004'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 22.14, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000004'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000004'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 20.91, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000004'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000004'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 23.4, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000004'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000005'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 27.16, 32.59, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000005'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000005'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 27.19, 32.63, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000005'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000005'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 29.96, 35.95, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000005'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000005'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 28.38, 34.06, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000005'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000005'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 29.8, 35.76, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000005'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000006'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 9.05, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000006'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000006'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.88, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000006'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000006'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 8.15, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000006'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000007'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 17.72, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000007'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000007'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 18.52, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000007'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000007'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 19.27, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000007'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000007'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 18.81, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000007'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000007'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 18.77, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000007'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000008'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 16.21, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000008'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000008'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 15.72, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000008'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000008'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 16.17, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000008'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000009'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 4.41, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000009'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000009'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 4.32, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000009'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000010'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 14.51, 17.41, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000010'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000010'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 15.37, 18.44, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000010'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000010'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 15.78, 18.94, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000010'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000011'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 11.95, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000011'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000011'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 12.13, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000011'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000011'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 11.48, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000011'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000011'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 12.94, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000011'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000012'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 24.37, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000012'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000012'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 24.21, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000012'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000012'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 24.66, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000012'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000012'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 26.59, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000012'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000013'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 28.9, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000013'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000013'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 26.48, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000013'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000013'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 27.35, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000013'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000013'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 28.68, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000013'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000013'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 26.98, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000013'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000014'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 46.83, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000014'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000014'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 48.57, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000014'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000014'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 46.62, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000014'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000015'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 19.37, 23.24, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000015'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000015'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 18.82, 22.58, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000015'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000015'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 17.23, 20.68, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000015'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000016'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 10.61, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000016'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000016'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 10.38, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000016'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000016'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 10.02, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000016'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000016'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 9.82, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000016'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000017'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 14.06, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000017'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000017'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 14.33, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000017'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000018'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 15.75, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000018'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000018'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 16.6, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000018'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000018'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 16.15, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000018'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000019'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 22.68, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000019'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000019'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 23.75, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000019'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000020'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 18.46, 22.15, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000020'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000020'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 18.63, 22.36, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000020'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000020'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 19.27, 23.12, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000020'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000020'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 19.94, 23.93, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000020'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000020'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 19.15, 22.98, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000020'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000021'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 14.96, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000021'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000021'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 15.27, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000021'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000022'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 24.78, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000022'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000022'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 24.38, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000022'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000022'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 25.62, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000022'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000023'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 21.16, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000023'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000023'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 19.87, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000023'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000024'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 6.77, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000024'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000024'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 6.18, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000024'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000024'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 6.64, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000024'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000025'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 5.32, 6.38, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000025'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000025'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 5.49, 6.59, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000025'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000025'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 5.92, 7.1, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000025'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000026'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 4.21, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000026'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000026'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 4.01, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000026'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000026'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 4.19, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000026'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000027'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 24.33, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000027'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000027'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 26.29, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000027'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000027'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 26.36, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000027'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000028'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 8.68, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000028'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000028'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 8.6, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000028'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000028'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 8.81, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000028'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000029'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 8.1, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000029'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000029'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 8.52, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000029'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000029'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 9.03, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000029'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000029'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 8.38, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000029'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000030'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 4.38, 5.26, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000030'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000030'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 4.3, 5.16, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000030'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000030'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 4.53, 5.44, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000030'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000030'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 4.74, 5.69, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000030'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000030'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 4.63, 5.56, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000030'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000031'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 4.92, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000031'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000031'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 5.03, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000031'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000032'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 17.53, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000032'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000032'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 18.02, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000032'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000032'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 18.14, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000032'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000032'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 16.83, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000032'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000032'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 16.87, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000032'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000033'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 18.08, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000033'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000033'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 18.68, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000033'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000033'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 18.54, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000033'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000034'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 31.27, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000034'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000034'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 32.81, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000034'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000034'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 31.74, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000034'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000034'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 32.24, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000034'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000035'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 28.48, 34.18, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000035'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000035'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 28.85, 34.62, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000035'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000035'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 29.05, 34.86, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000035'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000035'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 29.54, 35.45, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000035'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000035'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 26.69, 32.03, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000035'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000036'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 37.28, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000036'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000036'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 34.13, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000036'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000036'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 35.0, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000036'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000036'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 34.36, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000036'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000037'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 13.7, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000037'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000037'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 15.04, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000037'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000038'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 53.2, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000038'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000038'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 57.02, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000038'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000038'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 56.51, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000038'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000038'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 58.62, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000038'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000039'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 83.61, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000039'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000039'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 90.03, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000039'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000039'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 89.21, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000039'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000039'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 86.1, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000039'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000039'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 83.78, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000039'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000040'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 101.28, 121.54, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000040'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000040'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 92.11, 110.53, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000040'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000040'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 98.82, 118.58, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000040'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000041'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 11.92, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000041'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000041'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 12.05, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000041'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000041'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 12.7, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000041'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000042'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.4, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000042'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000042'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 9.02, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000042'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000042'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 8.54, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000042'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000042'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 8.89, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000042'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000042'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 8.74, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000042'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000043'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 62.0, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000043'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000043'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 67.4, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000043'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000043'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 65.17, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000043'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000043'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 68.85, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000043'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000044'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 15.5, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000044'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000044'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 15.94, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000044'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000044'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 14.35, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000044'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000044'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 14.89, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000044'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000044'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 14.89, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000044'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000045'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 45.5, 54.6, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000045'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000045'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 45.91, 55.09, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000045'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000045'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 44.06, 52.87, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000045'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000045'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 47.16, 56.59, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000045'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000046'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 72.48, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000046'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000046'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 72.37, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000046'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000046'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 75.78, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000046'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000047'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 40.87, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000047'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000047'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 40.69, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000047'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000047'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 39.45, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000047'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000048'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 10.6, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000048'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000048'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 10.88, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000048'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000048'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 11.31, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000048'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000048'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 10.95, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000048'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000049'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 100.74, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000049'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000049'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 96.3, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000049'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000049'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 102.12, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000049'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000050'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 113.31, 135.97, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000050'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000050'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 115.58, 138.7, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000050'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000050'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 110.73, 132.88, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000050'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000050'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 112.97, 135.56, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000050'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000051'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 44.18, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000051'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000051'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 46.08, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000051'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000051'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 44.97, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000051'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000052'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 67.74, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000052'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000052'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 67.61, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000052'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000052'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 70.8, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000052'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000053'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 55.74, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000053'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000053'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 53.97, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000053'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000053'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 56.87, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000053'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000053'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 55.45, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000053'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000053'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 54.35, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000053'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000054'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 91.98, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000054'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000054'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 90.48, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000054'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000054'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 91.94, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000054'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000055'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 69.53, 83.44, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000055'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000055'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 71.35, 85.62, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000055'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000055'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 73.42, 88.1, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000055'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000055'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 74.86, 89.83, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000055'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000056'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 61.6, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000056'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000056'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 61.09, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000056'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000056'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 64.65, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000056'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000057'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 11.68, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000057'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000057'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 11.83, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000057'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000057'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 12.49, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000057'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000058'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 38.42, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000058'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000058'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 37.78, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000058'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000058'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 40.75, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000058'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000058'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 36.66, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000058'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000059'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 23.22, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000059'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000059'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 21.14, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000059'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000059'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 21.24, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000059'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000059'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 22.09, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000059'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000060'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 15.93, 19.12, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000060'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000060'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 14.85, 17.82, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000060'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000060'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 14.37, 17.24, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000060'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000060'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 14.44, 17.33, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000060'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000060'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 14.66, 17.59, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000060'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000061'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 9.73, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000061'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000061'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 9.5, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000061'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000061'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 10.4, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000061'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000062'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 14.59, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000062'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000062'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 14.86, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000062'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000062'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 14.98, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000062'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000063'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 6.41, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000063'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000063'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 5.81, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000063'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000063'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 6.32, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000063'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000063'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 6.28, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000063'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000063'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 6.42, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000063'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000064'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 9.89, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000064'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000064'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 9.64, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000064'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000065'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 43.2, 51.84, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000065'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000065'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 41.15, 49.38, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000065'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000065'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 44.46, 53.35, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000065'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000065'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 43.11, 51.73, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000065'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000066'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 27.26, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000066'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000066'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 28.19, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000066'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000066'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 28.39, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000066'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000066'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 27.87, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000066'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000066'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 27.77, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000066'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000067'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 124.34, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000067'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000067'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 126.69, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000067'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000067'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 114.57, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000067'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000068'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 37.19, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000068'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000068'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 37.75, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000068'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000068'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 37.21, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000068'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000069'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 25.77, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000069'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000069'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 25.78, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000069'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000069'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 23.92, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000069'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000069'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 25.53, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000069'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000070'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 18.76, 22.51, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000070'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000070'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 18.39, 22.07, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000070'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000070'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 18.05, 21.66, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000070'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000070'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 19.42, 23.3, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000070'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000071'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 21.42, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000071'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000071'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 20.32, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000071'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000072'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 30.65, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000072'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000072'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 29.24, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000072'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000072'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 30.48, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000072'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000072'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 31.87, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000072'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000073'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 14.62, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000073'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000073'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 14.37, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000073'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000073'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 14.19, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000073'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000073'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 14.11, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000073'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000074'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 9.64, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000074'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000074'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 8.77, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000074'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000074'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 8.83, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000074'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000075'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 7.85, 9.42, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000075'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000075'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.02, 9.62, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000075'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000075'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 7.5, 9.0, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000075'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000076'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 24.37, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000076'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000076'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 23.84, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000076'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000076'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 23.11, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000076'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000077'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 13.29, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000077'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000077'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 12.0, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000077'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000078'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 15.37, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000078'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000078'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 16.97, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000078'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000078'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 16.31, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000078'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000079'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 7.84, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000079'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000079'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.56, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000079'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000079'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 8.38, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000079'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000079'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 8.62, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000079'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000080'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 11.44, 13.73, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000080'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000080'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 10.91, 13.09, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000080'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000081'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 63.81, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000081'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000081'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 66.53, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000081'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000081'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 63.27, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000081'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000082'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 32.98, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000082'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000082'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 32.47, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000082'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000083'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 83.56, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000083'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000083'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 88.12, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000083'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000083'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 85.89, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000083'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000084'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 46.49, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000084'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000084'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 46.79, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000084'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000084'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 47.7, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000084'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000084'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 48.6, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000084'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000084'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 45.58, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000084'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000085'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 28.06, 33.67, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000085'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000085'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 24.77, 29.72, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000085'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000085'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 26.92, 32.3, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000085'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000085'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 24.73, 29.68, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000085'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000086'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 40.21, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000086'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000086'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 39.93, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000086'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000087'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 22.84, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000087'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000087'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 23.09, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000087'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000087'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 23.3, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000087'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000087'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 21.18, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000087'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000087'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 22.75, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000087'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000088'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 17.31, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000088'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000088'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 17.86, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000088'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000088'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 17.51, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000088'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000088'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 18.94, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000088'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000089'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 161.36, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000089'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000089'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 157.06, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000089'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000089'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 158.18, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000089'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000089'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 161.28, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000089'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000089'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 157.21, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000089'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000090'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 23.8, 28.56, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000090'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000090'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 24.15, 28.98, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000090'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000090'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 25.94, 31.13, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000090'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000090'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 24.6, 29.52, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000090'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000091'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 14.3, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000091'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000091'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 14.89, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000091'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000091'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 14.68, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000091'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000092'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 7.65, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000092'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000092'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.64, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000092'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000092'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 7.84, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000092'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000093'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 36.3, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000093'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000093'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 36.42, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000093'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000093'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 35.16, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000093'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000094'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 97.85, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000094'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000094'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 90.65, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000094'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000094'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 92.93, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000094'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000095'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 39.91, 47.89, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000095'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000095'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 39.87, 47.84, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000095'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000095'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 39.43, 47.32, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000095'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000096'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 105.22, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000096'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000096'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 107.98, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000096'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000097'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 4.22, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000097'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000097'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 3.97, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000097'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000097'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 4.21, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000097'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000097'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 3.8, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000097'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000097'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 4.31, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000097'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000098'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 5.71, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000098'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000098'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 6.31, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000098'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000098'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 5.95, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000098'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000098'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 5.91, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000098'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000098'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 6.28, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000098'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000099'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 5.55, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000099'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000099'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 5.59, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000099'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000100'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 12.4, 14.88, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000100'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000100'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 12.96, 15.55, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000100'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000100'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 12.03, 14.44, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000100'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000100'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 11.57, 13.88, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000100'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000100'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 12.82, 15.38, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000100'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000101'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 7.73, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000101'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000101'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 8.26, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000101'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000101'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 8.34, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000101'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000102'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 31.59, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000102'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000102'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 30.18, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000102'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000102'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 30.11, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000102'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000102'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 30.27, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000102'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000102'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 31.35, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000102'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000103'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 7.28, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000103'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000103'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 6.71, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000103'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000103'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 6.73, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000103'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000103'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 6.74, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000103'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000104'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 10.74, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000104'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000104'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 9.93, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000104'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000104'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 9.96, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000104'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000105'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 1.49, 1.79, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000105'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000105'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 1.52, 1.82, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000105'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000105'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 1.55, 1.86, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000105'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000105'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 1.59, 1.91, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000105'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000106'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 44.51, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000106'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000106'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 44.37, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000106'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000106'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 43.59, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000106'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000106'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 40.04, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000106'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000106'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 44.43, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000106'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000107'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 39.57, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000107'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000107'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 40.65, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000107'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000108'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 51.18, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000108'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000108'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 47.95, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000108'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000109'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 84.91, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000109'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000109'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 84.52, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000109'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000110'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 2.43, 2.92, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000110'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000110'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 2.58, 3.1, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000110'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000110'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 2.4, 2.88, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000110'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000111'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 53.79, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000111'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000111'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 53.06, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000111'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000111'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 53.04, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000111'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000111'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 57.1, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000111'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000112'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 33.28, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000112'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000112'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 37.55, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000112'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000112'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 33.87, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000112'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000112'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 34.57, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000112'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000112'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 35.51, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000112'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000113'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 49.99, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000113'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000113'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 49.09, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000113'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000113'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 50.63, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000113'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000114'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 52.51, NULL, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000114'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000114'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 53.29, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000114'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000115'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 28.58, 34.3, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000115'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000115'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 29.17, 35.0, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000115'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000115'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 30.29, 36.35, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000115'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000115'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 32.09, 38.51, 0, false
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000115'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000116'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 20.53, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000116'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000116'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 19.2, NULL, 100, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000116'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000117'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 36.79, NULL, 0, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000117'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000117'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 35.66, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000117'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000117'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 37.37, NULL, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000117'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000118'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 27.13, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000118'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000118'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 27.23, NULL, 5, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000118'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000118'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 29.37, NULL, 60, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000118'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000119'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 22.23, NULL, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000119'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000119'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 23.07, NULL, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000119'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000120'::uuid, '00000000-0000-0000-0001-000000000005'::uuid, 40.29, 48.35, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000120'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000120'::uuid, '00000000-0000-0000-0001-000000000003'::uuid, 40.3, 48.36, 12, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000120'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000120'::uuid, '00000000-0000-0000-0001-000000000004'::uuid, 42.14, 50.57, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000120'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000120'::uuid, '00000000-0000-0000-0001-000000000002'::uuid, 38.29, 45.95, 40, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000120'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;
INSERT INTO inventory (product_id, store_id, price, old_price, stock_qty, is_available)
SELECT '00000000-0000-0000-0004-000000000120'::uuid, '00000000-0000-0000-0001-000000000001'::uuid, 38.39, 46.07, 25, true
WHERE EXISTS (SELECT 1 FROM products WHERE id = '00000000-0000-0000-0004-000000000120'::uuid)
ON CONFLICT (product_id, store_id) DO NOTHING;

-- ========== Promo codes ==========
INSERT INTO promo_codes (code, discount_type, discount_value, min_order_amount, max_discount_amount, usage_limit, per_user_limit, is_active)
VALUES ('WELCOME10', 'percentage', 10.00, 50.00, 50.00, 1000, 1, true)
ON CONFLICT (code) DO NOTHING;
INSERT INTO promo_codes (code, discount_type, discount_value, min_order_amount, usage_limit, per_user_limit, is_active)
VALUES ('SAVE20', 'fixed', 20.00, 150.00, 500, 3, true)
ON CONFLICT (code) DO NOTHING;

-- ========== Demo users + loyalty accounts (fictional test phones) ==========
INSERT INTO users (id, phone, full_name, role, language)
VALUES ('00000000-0000-0000-0005-000000000001'::uuid, '+992900000001', 'Фарход Раҳимов', 'customer', 'tj')
ON CONFLICT (phone) DO NOTHING;
INSERT INTO users (id, phone, full_name, role, language)
VALUES ('00000000-0000-0000-0005-000000000002'::uuid, '+992900000002', 'Мадина Каримова', 'customer', 'tj')
ON CONFLICT (phone) DO NOTHING;
INSERT INTO users (id, phone, full_name, role, language)
VALUES ('00000000-0000-0000-0005-000000000003'::uuid, '+992900000003', 'Ҷамшед Назаров', 'customer', 'tj')
ON CONFLICT (phone) DO NOTHING;

INSERT INTO loyalty_accounts (user_id, balance, lifetime_earned, tier)
SELECT '00000000-0000-0000-0005-000000000001'::uuid, 45.0, 45.0, 'standard'
WHERE EXISTS (SELECT 1 FROM users WHERE id = '00000000-0000-0000-0005-000000000001'::uuid)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO loyalty_accounts (user_id, balance, lifetime_earned, tier)
SELECT '00000000-0000-0000-0005-000000000002'::uuid, 120.5, 200.0, 'standard'
WHERE EXISTS (SELECT 1 FROM users WHERE id = '00000000-0000-0000-0005-000000000002'::uuid)
ON CONFLICT (user_id) DO NOTHING;
INSERT INTO loyalty_accounts (user_id, balance, lifetime_earned, tier)
SELECT '00000000-0000-0000-0005-000000000003'::uuid, 0.0, 0.0, 'standard'
WHERE EXISTS (SELECT 1 FROM users WHERE id = '00000000-0000-0000-0005-000000000003'::uuid)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO addresses (user_id, city, street, house, is_default, lat, lng)
SELECT '00000000-0000-0000-0005-000000000001'::uuid, 'Душанбе', 'кӯчаи Айнӣ', '44', true, 38.5731, 68.7864
WHERE EXISTS (SELECT 1 FROM users WHERE id = '00000000-0000-0000-0005-000000000001'::uuid)
AND NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = '00000000-0000-0000-0005-000000000001'::uuid);
INSERT INTO addresses (user_id, city, street, house, apartment, is_default, lat, lng)
SELECT '00000000-0000-0000-0005-000000000002'::uuid, 'Хуҷанд', 'кӯчаи Ленин', '10', '5', true, 40.2864, 69.6350
WHERE EXISTS (SELECT 1 FROM users WHERE id = '00000000-0000-0000-0005-000000000002'::uuid)
AND NOT EXISTS (SELECT 1 FROM addresses WHERE user_id = '00000000-0000-0000-0005-000000000002'::uuid);

COMMIT;

