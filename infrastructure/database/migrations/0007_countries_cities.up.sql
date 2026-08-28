-- Two-country support: YouShop serves Tajikistan and Russia, so a delivery
-- address, a store and a user each belong to a country, and the country
-- decides the currency, the phone dial code and where a map opens.
--
-- Everything here is additive: new tables, and new columns that default to
-- 'TJ' so every row that already exists stays valid and keeps its current
-- meaning (the app was Tajikistan-only until now).

CREATE TABLE IF NOT EXISTS countries (
    code          char(2) PRIMARY KEY,
    name_tg       varchar(100) NOT NULL,
    name_ru       varchar(100) NOT NULL,
    name_en       varchar(100) NOT NULL,
    currency_code char(3) NOT NULL,
    -- Rendered before the amount for RUB ("₽") style suffixes are handled in
    -- the app; kept here so a third country needs no client release.
    currency_tg   varchar(32) NOT NULL,
    currency_ru   varchar(32) NOT NULL,
    currency_en   varchar(32) NOT NULL,
    dial_code     varchar(8) NOT NULL,
    -- Where the address map/geocoder should centre when the user has no GPS
    -- fix yet, and how far out to start.
    center_lat    numeric(9,6) NOT NULL,
    center_lng    numeric(9,6) NOT NULL,
    is_active     boolean NOT NULL DEFAULT true,
    sort_order    int NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS cities (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    country_code char(2) NOT NULL REFERENCES countries(code) ON DELETE CASCADE,
    name_tg      varchar(120) NOT NULL,
    name_ru      varchar(120) NOT NULL,
    name_en      varchar(120) NOT NULL,
    lat          numeric(9,6) NOT NULL,
    lng          numeric(9,6) NOT NULL,
    is_active    boolean NOT NULL DEFAULT true,
    sort_order   int NOT NULL DEFAULT 0,
    UNIQUE (country_code, name_en)
);
CREATE INDEX IF NOT EXISTS idx_cities_country ON cities(country_code) WHERE is_active;

ALTER TABLE addresses ADD COLUMN IF NOT EXISTS country char(2) NOT NULL DEFAULT 'TJ';
ALTER TABLE stores    ADD COLUMN IF NOT EXISTS country char(2) NOT NULL DEFAULT 'TJ';
ALTER TABLE users     ADD COLUMN IF NOT EXISTS country char(2) NOT NULL DEFAULT 'TJ';
CREATE INDEX IF NOT EXISTS idx_stores_country ON stores(country) WHERE deleted_at IS NULL;

INSERT INTO countries (code, name_tg, name_ru, name_en, currency_code,
                       currency_tg, currency_ru, currency_en,
                       dial_code, center_lat, center_lng, sort_order)
VALUES
    ('TJ', 'Тоҷикистон', 'Таджикистан', 'Tajikistan', 'TJS',
     'сомонӣ', 'сомони', 'TJS', '+992', 38.560000, 68.787000, 1),
    ('RU', 'Русия', 'Россия', 'Russia', 'RUB',
     'рубл', '₽', 'RUB', '+7', 55.755800, 37.617600, 2)
ON CONFLICT (code) DO NOTHING;

INSERT INTO cities (country_code, name_tg, name_ru, name_en, lat, lng, sort_order) VALUES
    ('TJ', 'Душанбе',     'Душанбе',     'Dushanbe',    38.560000, 68.787000, 1),
    ('TJ', 'Хуҷанд',      'Худжанд',     'Khujand',     40.283300, 69.633300, 2),
    ('TJ', 'Бохтар',      'Бохтар',      'Bokhtar',     37.836100, 68.780000, 3),
    ('TJ', 'Кӯлоб',       'Куляб',       'Kulob',       37.914200, 69.780300, 4),
    ('TJ', 'Истаравшан',  'Истаравшан',  'Istaravshan', 39.911100, 69.007800, 5),
    ('TJ', 'Турсунзода',  'Турсунзаде',  'Tursunzoda',  38.510000, 68.230000, 6),
    ('TJ', 'Хоруғ',       'Хорог',       'Khorugh',     37.489400, 71.551700, 7),
    ('TJ', 'Панҷакент',   'Пенджикент',  'Panjakent',   39.495800, 67.610600, 8),
    ('TJ', 'Исфара',      'Исфара',      'Isfara',      40.126900, 70.623100, 9),
    ('TJ', 'Ваҳдат',      'Вахдат',      'Vahdat',      38.553100, 69.017200, 10),
    ('TJ', 'Ҳисор',       'Гиссар',      'Hisor',       38.526700, 68.550000, 11),
    ('TJ', 'Конибодом',   'Канибадам',   'Konibodom',   40.283900, 70.427800, 12),
    ('TJ', 'Норак',       'Нурек',       'Norak',       38.388100, 69.318900, 13),
    ('RU', 'Москва',            'Москва',            'Moscow',           55.755800, 37.617600, 1),
    ('RU', 'Санкт-Петербург',   'Санкт-Петербург',   'Saint Petersburg', 59.934300, 30.335100, 2),
    ('RU', 'Новосибирск',       'Новосибирск',       'Novosibirsk',      55.030200, 82.920700, 3),
    ('RU', 'Екатеринбург',      'Екатеринбург',      'Yekaterinburg',    56.838400, 60.605700, 4),
    ('RU', 'Қазон',             'Казань',            'Kazan',            55.796100, 49.106400, 5),
    ('RU', 'Нижний Новгород',   'Нижний Новгород',   'Nizhny Novgorod',  56.326900, 44.006500, 6),
    ('RU', 'Челябинск',         'Челябинск',         'Chelyabinsk',      55.164400, 61.436800, 7),
    ('RU', 'Самара',            'Самара',            'Samara',           53.195000, 50.101800, 8),
    ('RU', 'Омск',              'Омск',              'Omsk',             54.989200, 73.368400, 9),
    ('RU', 'Ростов-на-Дону',    'Ростов-на-Дону',    'Rostov-on-Don',    47.222400, 39.718900, 10),
    ('RU', 'Уфа',               'Уфа',               'Ufa',              54.735100, 55.958700, 11),
    ('RU', 'Красноярск',        'Красноярск',        'Krasnoyarsk',      56.010900, 92.852600, 12),
    ('RU', 'Перм',              'Пермь',             'Perm',             58.010500, 56.229400, 13),
    ('RU', 'Воронеж',           'Воронеж',           'Voronezh',         51.672000, 39.184300, 14),
    ('RU', 'Волгоград',         'Волгоград',         'Volgograd',        48.708000, 44.513300, 15),
    ('RU', 'Краснодар',         'Краснодар',         'Krasnodar',        45.035400, 38.975300, 16),
    ('RU', 'Саратов',           'Саратов',           'Saratov',          51.533600, 46.034300, 17),
    ('RU', 'Тюмен',             'Тюмень',            'Tyumen',           57.153300, 65.534300, 18),
    ('RU', 'Тольятти',          'Тольятти',          'Tolyatti',         53.507800, 49.420400, 19),
    ('RU', 'Ижевск',            'Ижевск',            'Izhevsk',          56.852700, 53.204500, 20)
ON CONFLICT (country_code, name_en) DO NOTHING;
