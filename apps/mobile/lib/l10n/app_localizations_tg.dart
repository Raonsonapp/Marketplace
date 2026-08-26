// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appTitle => 'YouShop';

  @override
  String get navHome => 'Асосӣ';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Сабад';

  @override
  String get navOrders => 'Фармоишҳо';

  @override
  String get navProfile => 'Профил';

  @override
  String get commonLoading => 'Бор карда истодааст…';

  @override
  String get commonEmptyTitle => 'Ин ҷо ҳанӯз чизе нест';

  @override
  String get commonEmptyMessage => 'Дар айни замон маълумот дастрас нест.';

  @override
  String get commonErrorTitle => 'Хатогӣ рӯй дод';

  @override
  String get commonErrorGeneric =>
      'Чизе нодуруст шуд. Лутфан аз нав кӯшиш кунед.';

  @override
  String get commonRetry => 'Аз нав кӯшиш кунед';

  @override
  String get commonCancel => 'Бекор кардан';

  @override
  String get commonConfirm => 'Тасдиқ';

  @override
  String get commonSave => 'Нигоҳ доштан';

  @override
  String get commonEdit => 'Таҳрир';

  @override
  String get commonDelete => 'Нест кардан';

  @override
  String get commonAdd => 'Илова кардан';

  @override
  String get commonDone => 'Тайёр';

  @override
  String get commonBack => 'Бозгашт';

  @override
  String get commonSeeAll => 'Ҳамаашро дидан';

  @override
  String get commonContinue => 'Идома';

  @override
  String get commonClose => 'Пӯшидан';

  @override
  String get commonYes => 'Ҳа';

  @override
  String get commonNo => 'Не';

  @override
  String get commonSearch => 'Ҷустуҷӯ';

  @override
  String get commonOptional => '(ихтиёрӣ)';

  @override
  String get offlineBannerMessage => 'Пайвасти интернет нест';

  @override
  String get networkErrorTimeout =>
      'Пайваст ба сервер қатъ шуд. Лутфан пайвасти интернети худро санҷед.';

  @override
  String get networkErrorNoConnection =>
      'Интернет дастрас нест. Лутфан пайвасти худро санҷед ва аз нав кӯшиш кунед.';

  @override
  String get networkErrorCancelled => 'Дархост бекор карда шуд.';

  @override
  String get networkErrorUnknown =>
      'Хатогии номаълуми шабака рӯй дод. Лутфан аз нав кӯшиш кунед.';

  @override
  String get authWelcomeTitle => 'Хуш омадед ба YouShop';

  @override
  String get authWelcomeSubtitle =>
      'Барои идома додан рақами телефони худро ворид кунед';

  @override
  String get authPhoneLabel => 'Рақами телефон';

  @override
  String get authPhoneHint => '90 123 45 67';

  @override
  String get authPhoneInvalid =>
      'Рақами телефон нодуруст аст. Намуна: +992 90 123 45 67';

  @override
  String get authSendCode => 'Гирифтани рамз';

  @override
  String get authOpenTelegramBot => 'Кушодани бот дар Telegram';

  @override
  String get authOtpTitle => 'Рамзи тасдиқро ворид кунед';

  @override
  String authOtpSubtitle(String phone) {
    return 'Рамзи тасдиқро на бо SMS, балки тавассути бот дар Telegram барои рақами $phone фиристодем. Telegram-ро кушоед — паём аз бот бояд аллакай омада бошад.';
  }

  @override
  String get authOtpInvalid => 'Рамз нодуруст аст. Лутфан аз нав кӯшиш кунед.';

  @override
  String get authOtpExpired => 'Мӯҳлати рамз гузашт. Рамзи нав дархост кунед.';

  @override
  String get authResendCode => 'Фиристодани рамз аз нав';

  @override
  String authResendCodeIn(int seconds) {
    return 'Аз нав фиристодан пас аз $seconds сония';
  }

  @override
  String get authVerify => 'Тасдиқ кардан';

  @override
  String get authChangeNumber => 'Тағйир додани рақам';

  @override
  String get authLogout => 'Баромадан';

  @override
  String get authLogoutConfirm => 'Шумо мутмаин ҳастед, ки мехоҳед бароед?';

  @override
  String get authCompleteRegTitle => 'Почтаи электрониро ворид кунед';

  @override
  String get authCompleteRegSubtitle =>
      'Марҳилаи охирин: барои огоҳиномаҳо ва барқарорсозии дастрасӣ почтаи электрониатонро гузоред';

  @override
  String get authEmailHint => 'example@gmail.com';

  @override
  String get authEmailInvalid => 'Почтаи электронӣ нодуруст аст';

  @override
  String get authSignInRequiredTitle => 'Бояд ворид шавед';

  @override
  String get authSignInRequiredMessage =>
      'Барои идома додан лутфан ворид шавед';

  @override
  String get authSignIn => 'Ворид шудан';

  @override
  String get onboardingTitle1 => 'Хариди маҳсулот аз хона';

  @override
  String get onboardingBody1 =>
      'Ҳазорон маҳсулоти тару тоза ва рӯзмарраро аз мағозаҳои наздики худ фармоиш диҳед';

  @override
  String get onboardingTitle2 => 'Расонидани тез';

  @override
  String get onboardingBody2 =>
      'Фармоиши шумо дар муддати кӯтоҳтарин ба назди шумо расонида мешавад';

  @override
  String get onboardingTitle3 => 'TajBonus-ро ҷамъ кунед';

  @override
  String get onboardingBody3 =>
      'Бо ҳар харид бонус ҷамъ кунед ва дар фармоишҳои оянда истифода баред';

  @override
  String get onboardingSkip => 'Гузаштан';

  @override
  String get onboardingNext => 'Баъдӣ';

  @override
  String get onboardingStart => 'Оғоз кардан';

  @override
  String get homeGreeting => 'Салом!';

  @override
  String get homeSectionCategories => 'Категорияҳо';

  @override
  String get homeSectionPopular => 'Маҳсулоти маъмул';

  @override
  String get homeSectionDiscounted => 'Бо тахфиф';

  @override
  String get homeSectionRecommended => 'Тавсияи мо';

  @override
  String get homeSectionRecentlyViewed => 'Ба наздикӣ дидаед';

  @override
  String get homeSectionPersonalOffers => 'Пешниҳодҳои шахсии шумо';

  @override
  String get homeSectionNearbyStores => 'Мағозаҳои наздик';

  @override
  String get homeSectionFeaturedBrands => 'Брендҳои маъруф';

  @override
  String get homeSectionBuyAgain => 'Боз харидорӣ кунед';

  @override
  String get homeEmptyFeed =>
      'Хуруҷи асосӣ дар айни замон холӣ аст. Лутфан баъдтар аз нав ворид шавед.';

  @override
  String get catalogTitle => 'Каталог';

  @override
  String get catalogEmptyCategories => 'Категорияҳо ёфт нашуданд';

  @override
  String get categoryProductsEmpty => 'Дар ин категория маҳсулот нест';

  @override
  String get searchHint => 'Маҳсулотро ҷустуҷӯ кунед';

  @override
  String get searchRecent => 'Ҷустуҷӯҳои охирин';

  @override
  String get searchClearRecent => 'Пок кардан';

  @override
  String get searchSuggestions => 'Пешниҳодҳо';

  @override
  String get searchNoResults => 'Аз рӯи дархости шумо чизе ёфт нашуд';

  @override
  String searchResultsCount(int count) {
    return '$count натиҷа ёфт шуд';
  }

  @override
  String get productAddToCart => 'Илова ба сабад';

  @override
  String get productOutOfStock => 'Дар анбор нест';

  @override
  String get productInStock => 'Дар анбор ҳаст';

  @override
  String get productQuantity => 'Миқдор';

  @override
  String get productDescription => 'Тавсиф';

  @override
  String get productRelated => 'Маҳсулоти монанд';

  @override
  String get productAddedToCart => 'Ба сабад илова карда шуд';

  @override
  String get productFavoriteAdded => 'Ба дӯстдоштаҳо илова карда шуд';

  @override
  String get productFavoriteRemoved => 'Аз дӯстдоштаҳо нест карда шуд';

  @override
  String productDiscountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get productUnavailableTitle => 'Маҳсулот дастрас нест';

  @override
  String get productUnavailableMessage =>
      'Мутаассифона, ин маҳсулот дар айни замон дастрас нест.';

  @override
  String get favoritesTitle => 'Дӯстдоштаҳо';

  @override
  String get favoritesEmptyTitle => 'Дӯстдоштаҳо холӣ аст';

  @override
  String get favoritesEmptyMessage =>
      'Маҳсулотеро, ки маъқул мешаванд, бо аломати дил нигоҳ доред';

  @override
  String get cartTitle => 'Сабад';

  @override
  String get cartEmptyTitle => 'Сабади шумо холӣ аст';

  @override
  String get cartEmptyMessage => 'Барои оғоз маҳсулот илова кунед';

  @override
  String get cartRemoveItem => 'Нест кардан';

  @override
  String get cartSaveForLater => 'Барои баъд нигоҳ доштан';

  @override
  String get cartMoveToCart => 'Ба сабад гузарондан';

  @override
  String get cartSavedForLaterTitle => 'Барои баъд нигоҳ дошташуда';

  @override
  String get cartPromoCodeLabel => 'Рамзи промо';

  @override
  String get cartPromoCodeHint => 'Рамзро ворид кунед';

  @override
  String get cartPromoCodeApply => 'Татбиқ кардан';

  @override
  String get cartPromoCodeApplied => 'Рамзи промо татбиқ карда шуд';

  @override
  String get cartPromoCodeRemove => 'Нест кардан';

  @override
  String get cartPromoCodeInvalid =>
      'Рамзи промо нодуруст ё мӯҳлаташ гузаштааст';

  @override
  String get cartSubtotal => 'Ҷамъи маҳсулот';

  @override
  String get cartDiscount => 'Тахфиф';

  @override
  String get cartDeliveryFee => 'Ҳаққи расонидан';

  @override
  String get cartTotal => 'Ҳамагӣ';

  @override
  String get cartServerCalculatedNote =>
      'Нархҳо аз ҷониби сервер ҳисоб карда мешаванд';

  @override
  String get cartCheckoutButton => 'Ба гузаронидан';

  @override
  String get cartClearConfirm => 'Сабадро тоза кардан?';

  @override
  String get checkoutTitle => 'Гузаронидан';

  @override
  String get checkoutDeliveryMethod => 'Тарзи расонидан';

  @override
  String get checkoutDeliveryMethodDelivery => 'Расонидан';

  @override
  String get checkoutDeliveryMethodPickup => 'Аз мағоза гирифтан';

  @override
  String get checkoutAddressTitle => 'Суроға';

  @override
  String get checkoutAddressSelect => 'Суроғаро интихоб кунед';

  @override
  String get checkoutAddressAdd => 'Суроғаи нав илова кунед';

  @override
  String get checkoutAddressEmpty => 'Шумо ҳанӯз суроға илова накардаед';

  @override
  String get checkoutTimeTitle => 'Вақти расонидан';

  @override
  String get checkoutTimeAsap => 'Ҳарчи зудтар';

  @override
  String get checkoutTimeScheduled => 'Вақти муайян';

  @override
  String get checkoutPaymentTitle => 'Тарзи пардохт';

  @override
  String get checkoutPaymentCashOnDelivery =>
      'Пардохт ҳангоми расонидан (нақд)';

  @override
  String get checkoutQuoteTitle => 'Пешнамоиши фармоиш';

  @override
  String get checkoutPlaceOrder => 'Фармоиш додан';

  @override
  String get checkoutOrderSuccessTitle => 'Фармоиш қабул карда шуд!';

  @override
  String checkoutOrderSuccessMessage(String orderNumber) {
    return 'Фармоиши шумо №$orderNumber қабул карда шуд ва дар ҳоли коркард аст';
  }

  @override
  String get checkoutViewOrder => 'Дидани фармоиш';

  @override
  String get checkoutBackToHome => 'Бозгашт ба саҳифаи асосӣ';

  @override
  String get addressLabelHome => 'Хона';

  @override
  String get addressLabelWork => 'Кор';

  @override
  String get addressLabelOther => 'Дигар';

  @override
  String get addressCity => 'Шаҳр';

  @override
  String get addressStreet => 'Кӯча';

  @override
  String get addressHouse => 'Хонаи';

  @override
  String get addressApartment => 'Утоқи';

  @override
  String get addressEntrance => 'Даромадгоҳ';

  @override
  String get addressFloor => 'Ошёна';

  @override
  String get addressComment => 'Шарҳ';

  @override
  String get addressSetDefault => 'Ҳамчун асосӣ таъин кардан';

  @override
  String get addressDefault => 'Асосӣ';

  @override
  String get addressDelete => 'Суроғаро нест кардан';

  @override
  String get ordersTitle => 'Фармоишҳо';

  @override
  String get ordersTabActive => 'Фаъол';

  @override
  String get ordersTabCompleted => 'Иҷрошуда';

  @override
  String get ordersTabCancelled => 'Бекоршуда';

  @override
  String get ordersEmptyActive => 'Фармоиши фаъол надоред';

  @override
  String get ordersEmptyCompleted => 'Фармоиши иҷрошуда надоред';

  @override
  String get ordersEmptyCancelled => 'Фармоиши бекоршуда надоред';

  @override
  String orderNumber(String number) {
    return 'Фармоиши №$number';
  }

  @override
  String get orderDetailTitle => 'Тафсилоти фармоиш';

  @override
  String get orderItemsTitle => 'Маҳсулот';

  @override
  String get orderStatusHistory => 'Таърихи ҳолат';

  @override
  String get orderCancel => 'Бекор кардани фармоиш';

  @override
  String get orderCancelReasonHint => 'Сабаби бекоркуниро нависед';

  @override
  String get orderReorder => 'Такрори фармоиш';

  @override
  String get orderReceipt => 'Чек';

  @override
  String get orderStatusPending => 'Дар интизорӣ';

  @override
  String get orderStatusConfirmed => 'Тасдиқшуда';

  @override
  String get orderStatusPreparing => 'Дар ҳоли омодасозӣ';

  @override
  String get orderStatusReady => 'Тайёр';

  @override
  String get orderStatusCourierAssigned => 'Курйер таъин шуд';

  @override
  String get orderStatusPickedUp => 'Курйер гирифт';

  @override
  String get orderStatusDelivering => 'Дар роҳи расонидан';

  @override
  String get orderStatusDelivered => 'Расонида шуд';

  @override
  String get orderStatusCancelled => 'Бекоршуда';

  @override
  String get profileTitle => 'Профил';

  @override
  String get profileEditTitle => 'Таҳрири профил';

  @override
  String get profileFullName => 'Ному насаб';

  @override
  String get profileEmail => 'Почтаи электронӣ';

  @override
  String get profilePhone => 'Рақами телефон';

  @override
  String get profileLanguage => 'Забон';

  @override
  String get profileAddresses => 'Суроғаҳои ман';

  @override
  String get profileMyOrders => 'Фармоишҳои ман';

  @override
  String get profileFavorites => 'Дӯстдоштаҳо';

  @override
  String get profileSettings => 'Танзимот';

  @override
  String get profileSaved => 'Профил нигоҳ дошта шуд';

  @override
  String get profileGuestTitle => 'Меҳмон';

  @override
  String get profileGuestMessage => 'Барои дидани профили худ ворид шавед';

  @override
  String get languageSelectTitle => 'Забонро интихоб кунед';

  @override
  String get languageTajik => 'Тоҷикӣ';

  @override
  String get languageRussian => 'Русӣ';

  @override
  String get languageEnglish => 'Англисӣ';

  @override
  String get profileTheme => 'Мавзӯъ';

  @override
  String get themeDark => 'Торик';

  @override
  String get themeLight => 'Равшан';

  @override
  String get themeSystem => 'Мувофиқи система';

  @override
  String get splashTagline => 'Хариди осон, расонидани тез';

  @override
  String get barcodeScanTitle => 'Сканери рамз';

  @override
  String get barcodeScanInstructions =>
      'Рамзи маҳсулотро дар чорчӯба ҷойгир кунед';

  @override
  String get barcodeCameraPermissionTitle => 'Дастрасӣ ба камера лозим аст';

  @override
  String get barcodeCameraPermissionMessage =>
      'Барои сканеркунии рамзи маҳсулот лутфан ба камера дастрасӣ диҳед';

  @override
  String get barcodeCameraPermissionGrant => 'Додани дастрасӣ';

  @override
  String get barcodeCameraPermissionOpenSettings => 'Кушодани танзимот';

  @override
  String get barcodeNotFoundTitle => 'Маҳсулот ёфт нашуд';

  @override
  String barcodeNotFoundMessage(String code) {
    return 'Мутаассифона, ягон маҳсулот бо рамзи $code ёфт нашуд';
  }

  @override
  String get barcodeScanAgain => 'Аз нав сканер кардан';

  @override
  String get barcodeResultTitle => 'Натиҷаи сканер';

  @override
  String get barcodeToggleFlash => 'Чарроғак';

  @override
  String get barcodeSwitchCamera => 'Иваз кардани камера';

  @override
  String get orderTrackingTitle => 'Пайгирии фармоиш';

  @override
  String get orderTrackingLive => 'Зинда';

  @override
  String get storesMapTitle => 'Мағозаҳои наздик';

  @override
  String get storesMapPermissionTitle => 'Дастрасӣ ба ҷойгиршавӣ лозим аст';

  @override
  String get storesMapPermissionMessage =>
      'Барои нишон додани мағозаҳои наздик дар харита лутфан ба ҷойгиршавии худ дастрасӣ диҳед';

  @override
  String get storesMapPermissionGrant => 'Додани дастрасӣ';

  @override
  String get storesMapPermissionOpenSettings => 'Кушодани танзимот';

  @override
  String get storesMapChooseManually => 'Ба ҷои он суроға интихоб кунед';

  @override
  String get storesMapEmptyTitle => 'Дар наздикӣ мағоза ёфт нашуд';

  @override
  String storeDistanceAway(String km) {
    return '$km км дуртар';
  }

  @override
  String get storeDeliveryAvailable => 'Расонидан дастрас аст';

  @override
  String get storePickupAvailable => 'Гирифтан аз мағоза дастрас аст';

  @override
  String get storeSells => 'Ин мағоза чӣ мефурӯшад';

  @override
  String get storeBrowseCatalog => 'Дидани каталог';

  @override
  String get loyaltyTitle => 'TajBonus';

  @override
  String get loyaltyBalance => 'Тавозун';

  @override
  String loyaltyLifetimeEarned(String amount) {
    return 'Дар маҷмӯъ ба даст омад: $amount';
  }

  @override
  String get loyaltyTransactionsTitle => 'Таърихи амалиёт';

  @override
  String get loyaltyEmptyTransactionsTitle => 'Ҳанӯз амалиёте нест';

  @override
  String get loyaltyEmptyTransactionsMessage =>
      'Бо харидҳои худ TajBonus ҷамъ кунед — амалиётҳои шумо дар ин ҷо пайдо мешаванд';

  @override
  String get loyaltyTypeEarn => 'Ҷамъшуда';

  @override
  String get loyaltyTypeSpend => 'Истифодашуда';

  @override
  String get loyaltyTypeExpire => 'Мӯҳлаташ гузашт';

  @override
  String get loyaltyTypeAdjust => 'Ислоҳшуда';

  @override
  String get loyaltyTypeCampaign => 'Бонуси акция';

  @override
  String get loyaltyTierStandard => 'Стандартӣ';

  @override
  String get loyaltyTierSilver => 'Нуқрагӣ';

  @override
  String get loyaltyTierGold => 'Тиллоӣ';

  @override
  String get loyaltyTierPlatinum => 'Платинагӣ';

  @override
  String get promotionsTitle => 'Пешниҳодҳо';

  @override
  String get promotionsEmptyTitle => 'Пешниҳоде нест';

  @override
  String get promotionsEmptyMessage =>
      'Дар айни замон пешниҳоди фаъол надоред. Баъдтар аз нав санҷед.';

  @override
  String promotionsValidUntil(String date) {
    return 'То $date амал мекунад';
  }

  @override
  String promotionsCopyCode(String code) {
    return 'Нусхабардории рамз: $code';
  }

  @override
  String get promotionsCodeCopied => 'Рамз нусхабардорӣ шуд';

  @override
  String get reviewsTitle => 'Шарҳҳо';

  @override
  String get reviewsEmptyTitle => 'Ҳанӯз шарҳе нест';

  @override
  String get reviewsEmptyMessage =>
      'Аввалин шахсе бошед, ки дар бораи ин маҳсулот шарҳ менависад';

  @override
  String get reviewsAnonymousReviewer => 'Харидор';

  @override
  String get reviewsHelpful => 'Фоиданок';

  @override
  String get reviewsLeaveReview => 'Шарҳ навиштан';

  @override
  String get reviewsWriteTitle => 'Шарҳ навиштан';

  @override
  String reviewsForPurchase(String productName) {
    return 'Шарҳ барои: $productName';
  }

  @override
  String get reviewsTextLabel => 'Шарҳи шумо';

  @override
  String get reviewsTextHint => 'Дар бораи маҳсулот нависед…';

  @override
  String get reviewsImageUrlLabel => 'Суратро замима кунед';

  @override
  String get reviewsImageUrlHint => 'Пайванди сурат (URL)';

  @override
  String get reviewsSubmit => 'Фиристодани шарҳ';

  @override
  String get reviewsSubmitSuccess => 'Ташаккур! Шарҳи шумо фиристода шуд';

  @override
  String get reviewsDuplicateError =>
      'Шумо аллакай барои ин харид шарҳ навиштаед';

  @override
  String get notificationsTitle => 'Огоҳномаҳо';

  @override
  String get notificationsEmptyTitle => 'Огоҳнома нест';

  @override
  String get notificationsEmptyMessage =>
      'Огоҳномаҳои шумо дар ин ҷо пайдо мешаванд';

  @override
  String get notificationsPreferencesTitle => 'Танзими огоҳномаҳо';

  @override
  String get notificationsPrefOrders => 'Фармоишҳо';

  @override
  String get notificationsPrefPromotions => 'Тахфифҳо ва акцияҳо';

  @override
  String get notificationsPrefPersonalOffers => 'Пешниҳодҳои шахсӣ';

  @override
  String get notificationsPrefBonusUpdates => 'Тағйироти TajBonus';

  @override
  String get notificationsPrefNewProducts => 'Маҳсулоти нав';

  @override
  String get supportTitle => 'Дастгирӣ';

  @override
  String get supportNewConversation => 'Муроҷиати нав';

  @override
  String get supportEmptyTitle => 'Ҳанӯз муроҷиате нест';

  @override
  String get supportEmptyMessage => 'Агар савол дошта бошед, бо мо тамос гиред';

  @override
  String get supportStatusOpen => 'Фаъол';

  @override
  String get supportStatusClosed => 'Пӯшидашуда';

  @override
  String get supportChatTitle => 'Чат бо дастгирӣ';

  @override
  String get supportChatEmptyTitle => 'Паём нест';

  @override
  String get supportChatEmptyMessage => 'Паёми аввалини худро фиристед';

  @override
  String get supportChatInputHint => 'Паём нависед…';

  @override
  String get sellerMenuTitle => 'Шудан ба фурӯшанда';

  @override
  String get sellerIntroBody => 'Дар YouShop фурӯш кунед: ҷойгиршавии GPS-и мағозаатонро ё истиноде, ки харидорон шуморо ёбанд, гузоред, шиносномаатонро тасдиқ кунед ва бо санҷиши зуди чеҳра шахсияти худро исбот кунед — ҳама ройгон, дар дохили барнома.';

  @override
  String get sellerIntroStart => 'Оғоз кардан';

  @override
  String get sellerStoreInfoTitle => 'Мағозаи шумо';

  @override
  String get sellerStoreInfoSubtitle => 'Ҷойгиршавии GPS-и мағозаатонро гузоред ё — агар мағозаи воқеӣ надошта бошед — истиноди вебсайт, Instagram, Telegram ё WhatsApp-и худро.';

  @override
  String get sellerUseMyLocation => 'Ҷойгиршавии ҳозираи худро истифода баред';

  @override
  String get sellerLocationCaptured => 'Ҷойгиршавӣ нигоҳ дошта шуд';

  @override
  String get sellerWebsiteLabel => 'Вебсайт';

  @override
  String get sellerInstagramLabel => 'Instagram';

  @override
  String get sellerTelegramLabel => 'Telegram';

  @override
  String get sellerWhatsappLabel => 'WhatsApp';

  @override
  String get sellerStoreInfoRequiredError => 'Ҷойгиршавии мағоза ё ҳадди ақал як истиноди тамос гузоред';

  @override
  String get sellerDocumentsTitle => 'Ҳуҷҷатҳо';

  @override
  String get sellerBirthDateLabel => 'Санаи таваллуд';

  @override
  String get sellerBirthDateNotSet => 'Гузошта нашудааст';

  @override
  String get sellerPassportFrontLabel => 'Шиноснома — саҳифаи пеш';

  @override
  String get sellerPassportBackLabel => 'Шиноснома — саҳифаи пас';

  @override
  String get sellerSelfieWithPassportLabel => 'Селфӣ бо шиноснома дар даст';

  @override
  String get sellerCapturePhoto => 'Акс гирифтан';

  @override
  String get sellerRetakePhoto => 'Аз нав гирифтан';

  @override
  String get sellerDocumentsIncompleteError => 'Лутфан ҳар се аксро ва санаи таваллудро гузоред';

  @override
  String get sellerFaceTitle => 'Санҷиши чеҳра';

  @override
  String get sellerFaceInstructionLookNormal => 'Ба камера оромона нигоҳ кунед, баъд тугмаи аксбардориро пахш кунед';

  @override
  String get sellerFaceInstructionBlink => 'Акнун чашмакашед ва боз тугмаро пахш кунед';

  @override
  String get sellerFaceCapture => 'Аксбардорӣ';

  @override
  String get sellerFaceProcessing => 'Тафтиш шуда истодааст…';

  @override
  String get sellerFaceFailed => 'Тасдиқ карда натавонистем, ки ин шумоед. Мутмаин шавед, ки чеҳраатон хуб равшан ва пурра дида мешавад, ва аз нав кӯшиш кунед.';

  @override
  String get sellerSubmitApplication => 'Дархостро фиристодан';

  @override
  String get sellerUnderageError => 'Синну соли фурушанда бояд на камтар аз 18 сол бошад';

  @override
  String get sellerApplicationExistsError => 'Шумо аллакай дархости фурушандашавӣ фиристодаед';

  @override
  String get sellerStatusTitle => 'Дархости фурушандашавӣ';

  @override
  String get sellerStatusPending => 'Дархости шумо дар ҳоли баррасӣ аст. Пас аз тасдиқ ба шумо хабар медиҳем.';

  @override
  String get sellerStatusApproved => 'Табрик! Шумо ҳоло фурӯшанда дар YouShop ҳастед.';

  @override
  String get sellerStatusRejected => 'Дархости шумо тасдиқ карда нашуд.';
}
