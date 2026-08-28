# Google Play Store Listing — YouShop

Package: `tj.tajikshop.app` · Category: **Shopping** · Content rating
target: **Everyone** (no user-generated public content beyond moderated
reviews; no violence/gambling).

> **Decide the package name before the first upload.** `applicationId` is
> permanent once an app is published — Google Play will never let it change,
> and a new one means a new listing with zero installs and zero reviews. The
> current value still says `tajikshop`, which no longer matches the app's
> name or its two-country scope; `tj.youshop.app` (or a domain you own)
> would age better. It is a one-line change in
> `apps/mobile/android/app/build.gradle.kts` **today** and impossible
> tomorrow.

The Play Console listing form is filled in per language. Below is
ready-to-paste copy for all three languages the app ships with — Tajik
(primary), Russian, and English.

## App name

- TJ: YouShop — маркетплейс ва карго
- RU: YouShop — маркетплейс и карго
- EN: YouShop — Marketplace & Cargo

(Play limits the visible title to 30 characters; the short form **YouShop**
is what actually renders on the store listing icon.)

## Short description (max 80 characters)

- TJ: Хариду фурӯш дар Тоҷикистон ва Русия, плюс карго аз Хитой
- RU: Покупки в Таджикистане и России, плюс карго из Китая
- EN: Shop in Tajikistan and Russia, plus cargo from China

## Full description (max 4000 characters)

### Tajik

```
YouShop — маркетплейс барои Тоҷикистон ва Русия.

Дар як барнома: хариди мол аз дӯконҳо ва фурӯшандагони маҳаллӣ, пайгирии
фармоиш, ва интиқоли посылка аз Хитой.

Хусусиятҳо:
• Ду кишвар — Тоҷикистон ва Русия, бо шаҳрҳо, суроғаҳо ва асъори худ
  (сомонӣ ё рубл)
• Воридшавӣ бо почтаи электронӣ ва рамзи яквақта — бе SMS
• Ҷустуҷӯи зуд ва филтрҳои мувофиқ
• Сканери barcode барои санҷиши нарх дар дӯкон
• Пайгирии зинда фармоиш — аз тасдиқ то расонидан
• Карго аз Хитой: суроғаи анбори мо, ҳисоби нарх аз рӯи вазн, пайгирии
  посылка то дари хона
• Системаи бонусӣ, промокодҳо ва пешниҳодҳои шахсӣ
• Нигоҳ доштани якчанд суроға барои расонидан
• Забонҳо: тоҷикӣ, русӣ, англисӣ

Ҷойгиршавӣ: Душанбе, Хуҷанд, Бохтар, Кӯлоб ва шаҳрҳои дигари Тоҷикистон;
Москва, Санкт-Петербург, Қазон ва шаҳрҳои дигари Русия.
```

### Russian

```
YouShop — маркетплейс для Таджикистана и России.

В одном приложении: покупки у местных магазинов и продавцов, отслеживание
заказов и доставка посылок из Китая.

Возможности:
• Две страны — Таджикистан и Россия, со своими городами, адресами и
  валютой (сомони или рубли)
• Вход по email с одноразовым кодом — без SMS
• Быстрый поиск и удобные фильтры
• Сканер штрих-кодов для проверки цены в магазине
• Отслеживание заказа в реальном времени — от подтверждения до доставки
• Карго из Китая: адрес нашего склада, расчёт цены по весу, отслеживание
  посылки до двери
• Бонусная программа, промокоды и персональные предложения
• Несколько сохранённых адресов доставки
• Языки: таджикский, русский, английский

География: Душанбе, Худжанд, Бохтар, Куляб и другие города Таджикистана;
Москва, Санкт-Петербург, Казань и другие города России.
```

### English

```
YouShop is a marketplace for Tajikistan and Russia.

One app for buying from local stores and sellers, tracking your orders, and
forwarding parcels from China.

Features:
• Two countries — Tajikistan and Russia, each with its own cities,
  addresses and currency (somoni or rubles)
• Sign in with your email and a one-time code — no SMS
• Fast search with useful filters
• Barcode scanner to check in-store prices
• Live order tracking from confirmation to delivery
• Cargo from China: our warehouse address, price calculated by weight, and
  parcel tracking to your door
• Bonus programme, promo codes and personal offers
• Multiple saved delivery addresses
• Languages: Tajik, Russian, English

Coverage: Dushanbe, Khujand, Bokhtar, Kulob and other Tajik cities; Moscow,
Saint Petersburg, Kazan and other Russian cities.
```

## Graphic assets

- App icon: `apps/mobile/assets/branding/app_icon.png` (transparent) /
  `app_icon_flattened.png` (on-brand background) — see
  `docs/BRANDING.md` for how these feed the actual launcher icons.
- Feature graphic (1024×500) and phone/tablet screenshots: not yet
  produced — these require running the finished app and are a Phase 9 task
  once the mobile UI is stable enough to screenshot (see PROJECT_STATE.md).

## Required URLs

The API serves all three at its own origin, so there is nothing extra to
host:

- Privacy policy: `https://<api-host>/privacy`
- Terms of use: `https://<api-host>/terms`
- Account deletion: `https://<api-host>/delete-account`

Play requires the privacy-policy URL on the listing and, for any app with
accounts, the deletion URL in Play Console → App content → Data deletion.

## Data safety / permissions

See `docs/GOOGLE_PLAY_DATA_SAFETY.md`. It must match what the app actually
collects — Google rejects listings whose form and behaviour disagree.

## Signing

The release workflow signs with the **debug** keystore unless the four
`ANDROID_KEYSTORE_*` repository secrets are set, and Play rejects a
debug-signed bundle. See `docs/DEPLOYMENT.md` for creating the upload
keystore and setting those secrets.
