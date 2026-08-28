// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'YouShop';

  @override
  String get navHome => 'Главная';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navCart => 'Корзина';

  @override
  String get navOrders => 'Заказы';

  @override
  String get navProfile => 'Профиль';

  @override
  String get commonLoading => 'Загрузка…';

  @override
  String get commonEmptyTitle => 'Здесь пока пусто';

  @override
  String get commonEmptyMessage => 'Данные сейчас недоступны.';

  @override
  String get commonErrorTitle => 'Произошла ошибка';

  @override
  String get commonErrorGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonConfirm => 'Подтвердить';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonEdit => 'Изменить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonAdd => 'Добавить';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonSeeAll => 'Смотреть все';

  @override
  String get commonContinue => 'Продолжить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Нет';

  @override
  String get commonSearch => 'Поиск';

  @override
  String get commonOptional => '(необязательно)';

  @override
  String get offlineBannerMessage => 'Нет подключения к интернету';

  @override
  String get networkErrorTimeout =>
      'Связь с сервером прервана. Проверьте подключение к интернету.';

  @override
  String get networkErrorNoConnection =>
      'Интернет недоступен. Проверьте соединение и попробуйте снова.';

  @override
  String get networkErrorCancelled => 'Запрос отменён.';

  @override
  String get networkErrorUnknown =>
      'Неизвестная ошибка сети. Попробуйте ещё раз.';

  @override
  String get authWelcomeTitle => 'Добро пожаловать в YouShop';

  @override
  String get authWelcomeSubtitle => 'Введите номер телефона, чтобы продолжить';

  @override
  String get authWelcomeSubtitleEmail => 'Введите свой email, чтобы продолжить';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPhoneLabel => 'Номер телефона';

  @override
  String get authPhoneHint => '90 123 45 67';

  @override
  String get authPhoneInvalid =>
      'Неверный номер телефона. Пример: +992 90 123 45 67';

  @override
  String get authSendCode => 'Получить код';

  @override
  String get authOpenTelegramBot => 'Открыть бота в Telegram';

  @override
  String get authOtpTitle => 'Введите код подтверждения';

  @override
  String authOtpSubtitle(String email) {
    return 'Мы отправили код подтверждения на $email. Проверьте почту — если письма нет, загляните в папку «Спам».';
  }

  @override
  String get authOtpInvalid => 'Неверный код. Попробуйте ещё раз.';

  @override
  String get authOtpExpired => 'Срок действия кода истёк. Запросите новый код.';

  @override
  String get authResendCode => 'Отправить код повторно';

  @override
  String authResendCodeIn(int seconds) {
    return 'Повторная отправка через $seconds сек.';
  }

  @override
  String get authVerify => 'Подтвердить';

  @override
  String get authChangeNumber => 'Изменить email';

  @override
  String get authLogout => 'Выйти';

  @override
  String get authCompleteRegTitle => 'Введите email';

  @override
  String get authCompleteRegSubtitle =>
      'Последний шаг: укажите email для уведомлений и восстановления доступа';

  @override
  String get authEmailHint => 'example@gmail.com';

  @override
  String get authEmailInvalid => 'Неверный email';

  @override
  String get authLogoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get authSignInRequiredTitle => 'Требуется вход';

  @override
  String get authSignInRequiredMessage =>
      'Пожалуйста, войдите, чтобы продолжить';

  @override
  String get authSignIn => 'Войти';

  @override
  String get onboardingTitle1 => 'Покупки не выходя из дома';

  @override
  String get onboardingBody1 =>
      'Заказывайте тысячи свежих и повседневных товаров из ближайших магазинов';

  @override
  String get onboardingTitle2 => 'Быстрая доставка';

  @override
  String get onboardingBody2 => 'Ваш заказ будет доставлен в кратчайшие сроки';

  @override
  String get onboardingTitle3 => 'Копите TajBonus';

  @override
  String get onboardingBody3 =>
      'Получайте бонусы за каждую покупку и используйте их в будущих заказах';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get homeGreeting => 'Привет!';

  @override
  String get homeSectionCategories => 'Категории';

  @override
  String get homeSectionPopular => 'Популярные товары';

  @override
  String get homeSectionDiscounted => 'Со скидкой';

  @override
  String get homeSectionRecommended => 'Рекомендуем';

  @override
  String get homeSectionRecentlyViewed => 'Недавно просмотренные';

  @override
  String get homeSectionPersonalOffers => 'Персональные предложения';

  @override
  String get homeSectionNearbyStores => 'Магазины рядом';

  @override
  String get homeSectionFeaturedBrands => 'Популярные бренды';

  @override
  String get homeSectionBuyAgain => 'Купить снова';

  @override
  String get homeEmptyFeed =>
      'Главная лента сейчас пуста. Пожалуйста, зайдите позже.';

  @override
  String get catalogTitle => 'Каталог';

  @override
  String get catalogEmptyCategories => 'Категории не найдены';

  @override
  String get categoryProductsEmpty => 'В этой категории нет товаров';

  @override
  String get searchHint => 'Искать товары';

  @override
  String get searchRecent => 'Недавние запросы';

  @override
  String get searchClearRecent => 'Очистить';

  @override
  String get searchSuggestions => 'Предложения';

  @override
  String get searchNoResults => 'По вашему запросу ничего не найдено';

  @override
  String searchResultsCount(int count) {
    return 'Найдено результатов: $count';
  }

  @override
  String get productAddToCart => 'В корзину';

  @override
  String get productOutOfStock => 'Нет в наличии';

  @override
  String get productInStock => 'В наличии';

  @override
  String get productQuantity => 'Количество';

  @override
  String get productDescription => 'Описание';

  @override
  String get productRelated => 'Похожие товары';

  @override
  String get productAddedToCart => 'Добавлено в корзину';

  @override
  String get productFavoriteAdded => 'Добавлено в избранное';

  @override
  String get productFavoriteRemoved => 'Удалено из избранного';

  @override
  String productDiscountBadge(int percent) {
    return '-$percent%';
  }

  @override
  String get productUnavailableTitle => 'Товар недоступен';

  @override
  String get productUnavailableMessage =>
      'К сожалению, этот товар сейчас недоступен.';

  @override
  String get favoritesTitle => 'Избранное';

  @override
  String get favoritesEmptyTitle => 'В избранном пусто';

  @override
  String get favoritesEmptyMessage =>
      'Сохраняйте понравившиеся товары нажатием на сердечко';

  @override
  String get cartTitle => 'Корзина';

  @override
  String get cartEmptyTitle => 'Ваша корзина пуста';

  @override
  String get cartEmptyMessage => 'Добавьте товары, чтобы начать';

  @override
  String get cartRemoveItem => 'Удалить';

  @override
  String get cartSaveForLater => 'Отложить';

  @override
  String get cartMoveToCart => 'Вернуть в корзину';

  @override
  String get cartSavedForLaterTitle => 'Отложенные товары';

  @override
  String get cartPromoCodeLabel => 'Промокод';

  @override
  String get cartPromoCodeHint => 'Введите код';

  @override
  String get cartPromoCodeApply => 'Применить';

  @override
  String get cartPromoCodeApplied => 'Промокод применён';

  @override
  String get cartPromoCodeRemove => 'Удалить';

  @override
  String get cartPromoCodeInvalid => 'Промокод недействителен или истёк';

  @override
  String get cartSubtotal => 'Сумма товаров';

  @override
  String get cartDiscount => 'Скидка';

  @override
  String get cartDeliveryFee => 'Стоимость доставки';

  @override
  String get cartTotal => 'Итого';

  @override
  String get cartServerCalculatedNote => 'Цены рассчитываются сервером';

  @override
  String get cartCheckoutButton => 'Оформить заказ';

  @override
  String get cartClearConfirm => 'Очистить корзину?';

  @override
  String get checkoutTitle => 'Оформление заказа';

  @override
  String get checkoutDeliveryMethod => 'Способ получения';

  @override
  String get checkoutDeliveryMethodDelivery => 'Доставка';

  @override
  String get checkoutDeliveryMethodPickup => 'Самовывоз';

  @override
  String get checkoutAddressTitle => 'Адрес';

  @override
  String get checkoutAddressSelect => 'Выберите адрес';

  @override
  String get checkoutAddressAdd => 'Добавить новый адрес';

  @override
  String get checkoutAddressEmpty => 'Вы ещё не добавили адрес';

  @override
  String get checkoutTimeTitle => 'Время доставки';

  @override
  String get checkoutTimeAsap => 'Как можно быстрее';

  @override
  String get checkoutTimeScheduled => 'Выбрать время';

  @override
  String get checkoutPaymentTitle => 'Способ оплаты';

  @override
  String get checkoutPaymentCashOnDelivery => 'Оплата наличными при получении';

  @override
  String get checkoutQuoteTitle => 'Предпросмотр заказа';

  @override
  String get checkoutPlaceOrder => 'Оформить заказ';

  @override
  String get checkoutOrderSuccessTitle => 'Заказ принят!';

  @override
  String checkoutOrderSuccessMessage(String orderNumber) {
    return 'Ваш заказ №$orderNumber принят и обрабатывается';
  }

  @override
  String get checkoutViewOrder => 'Посмотреть заказ';

  @override
  String get checkoutBackToHome => 'Вернуться на главную';

  @override
  String get addressLabelHome => 'Дом';

  @override
  String get addressLabelWork => 'Работа';

  @override
  String get addressLabelOther => 'Другое';

  @override
  String get addressCity => 'Город';

  @override
  String get addressCountry => 'Страна';

  @override
  String get addressStreet => 'Улица';

  @override
  String get addressHouse => 'Дом';

  @override
  String get addressApartment => 'Квартира';

  @override
  String get addressEntrance => 'Подъезд';

  @override
  String get addressFloor => 'Этаж';

  @override
  String get addressComment => 'Комментарий';

  @override
  String get addressSetDefault => 'Сделать основным';

  @override
  String get addressDefault => 'Основной';

  @override
  String get addressDelete => 'Удалить адрес';

  @override
  String get ordersTitle => 'Заказы';

  @override
  String get ordersTabActive => 'Активные';

  @override
  String get ordersTabCompleted => 'Завершённые';

  @override
  String get ordersTabCancelled => 'Отменённые';

  @override
  String get ordersEmptyActive => 'У вас нет активных заказов';

  @override
  String get ordersEmptyCompleted => 'У вас нет завершённых заказов';

  @override
  String get ordersEmptyCancelled => 'У вас нет отменённых заказов';

  @override
  String orderNumber(String number) {
    return 'Заказ №$number';
  }

  @override
  String get orderDetailTitle => 'Детали заказа';

  @override
  String get orderItemsTitle => 'Товары';

  @override
  String get orderStatusHistory => 'История статуса';

  @override
  String get orderCancel => 'Отменить заказ';

  @override
  String get orderCancelReasonHint => 'Укажите причину отмены';

  @override
  String get orderReorder => 'Повторить заказ';

  @override
  String get orderReceipt => 'Чек';

  @override
  String get orderStatusPending => 'В ожидании';

  @override
  String get orderStatusConfirmed => 'Подтверждён';

  @override
  String get orderStatusPreparing => 'Готовится';

  @override
  String get orderStatusReady => 'Готов';

  @override
  String get orderStatusCourierAssigned => 'Курьер назначен';

  @override
  String get orderStatusPickedUp => 'Курьер забрал';

  @override
  String get orderStatusDelivering => 'В пути';

  @override
  String get orderStatusDelivered => 'Доставлен';

  @override
  String get orderStatusCancelled => 'Отменён';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileEditTitle => 'Редактировать профиль';

  @override
  String get profileFullName => 'Полное имя';

  @override
  String get profileEmail => 'Электронная почта';

  @override
  String get profilePhone => 'Номер телефона';

  @override
  String get profileLanguage => 'Язык';

  @override
  String get profileCountry => 'Страна и валюта';

  @override
  String get profileAddresses => 'Мои адреса';

  @override
  String get profileMyOrders => 'Мои заказы';

  @override
  String get profileFavorites => 'Избранное';

  @override
  String get profileSettings => 'Настройки';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get profileGuestTitle => 'Гость';

  @override
  String get profileGuestMessage => 'Войдите, чтобы увидеть свой профиль';

  @override
  String get languageSelectTitle => 'Выберите язык';

  @override
  String get languageTajik => 'Таджикский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get profileTheme => 'Тема';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeSystem => 'Как в системе';

  @override
  String get splashTagline => 'Лёгкие покупки, быстрая доставка';

  @override
  String get barcodeScanTitle => 'Сканер штрихкода';

  @override
  String get barcodeScanInstructions => 'Наведите камеру на штрихкод товара';

  @override
  String get barcodeCameraPermissionTitle => 'Требуется доступ к камере';

  @override
  String get barcodeCameraPermissionMessage =>
      'Чтобы отсканировать штрихкод товара, разрешите доступ к камере';

  @override
  String get barcodeCameraPermissionGrant => 'Разрешить доступ';

  @override
  String get barcodeCameraPermissionOpenSettings => 'Открыть настройки';

  @override
  String get barcodeNotFoundTitle => 'Товар не найден';

  @override
  String barcodeNotFoundMessage(String code) {
    return 'К сожалению, товар со штрихкодом $code не найден';
  }

  @override
  String get barcodeScanAgain => 'Сканировать снова';

  @override
  String get barcodeResultTitle => 'Результат сканирования';

  @override
  String get barcodeToggleFlash => 'Фонарик';

  @override
  String get barcodeSwitchCamera => 'Сменить камеру';

  @override
  String get orderTrackingTitle => 'Отслеживание заказа';

  @override
  String get orderTrackingLive => 'Онлайн';

  @override
  String get storesMapTitle => 'Магазины рядом';

  @override
  String get storesMapPermissionTitle => 'Требуется доступ к геолокации';

  @override
  String get storesMapPermissionMessage =>
      'Чтобы показать магазины рядом с вами на карте, разрешите доступ к геолокации';

  @override
  String get storesMapPermissionGrant => 'Разрешить доступ';

  @override
  String get storesMapPermissionOpenSettings => 'Открыть настройки';

  @override
  String get storesMapChooseManually => 'Выбрать адрес вручную';

  @override
  String get storesMapEmptyTitle => 'Поблизости магазины не найдены';

  @override
  String storeDistanceAway(String km) {
    return '$km км от вас';
  }

  @override
  String get storeDeliveryAvailable => 'Доступна доставка';

  @override
  String get storePickupAvailable => 'Доступен самовывоз';

  @override
  String get storeSells => 'Что продаёт этот магазин';

  @override
  String get storeBrowseCatalog => 'Смотреть каталог';

  @override
  String get loyaltyTitle => 'TajBonus';

  @override
  String get loyaltyBalance => 'Баланс';

  @override
  String loyaltyLifetimeEarned(String amount) {
    return 'Всего накоплено: $amount';
  }

  @override
  String get loyaltyTransactionsTitle => 'История операций';

  @override
  String get loyaltyEmptyTransactionsTitle => 'Пока нет операций';

  @override
  String get loyaltyEmptyTransactionsMessage =>
      'Совершайте покупки и копите TajBonus — здесь появятся ваши операции';

  @override
  String get loyaltyTypeEarn => 'Начислено';

  @override
  String get loyaltyTypeSpend => 'Списано';

  @override
  String get loyaltyTypeExpire => 'Срок истёк';

  @override
  String get loyaltyTypeAdjust => 'Корректировка';

  @override
  String get loyaltyTypeCampaign => 'Бонус акции';

  @override
  String get loyaltyTierStandard => 'Стандарт';

  @override
  String get loyaltyTierSilver => 'Серебряный';

  @override
  String get loyaltyTierGold => 'Золотой';

  @override
  String get loyaltyTierPlatinum => 'Платиновый';

  @override
  String get promotionsTitle => 'Предложения';

  @override
  String get promotionsEmptyTitle => 'Пока нет предложений';

  @override
  String get promotionsEmptyMessage =>
      'Сейчас у вас нет активных предложений. Загляните позже.';

  @override
  String promotionsValidUntil(String date) {
    return 'Действует до $date';
  }

  @override
  String promotionsCopyCode(String code) {
    return 'Скопировать код: $code';
  }

  @override
  String get promotionsCodeCopied => 'Код скопирован';

  @override
  String get reviewsTitle => 'Отзывы';

  @override
  String get reviewsEmptyTitle => 'Пока нет отзывов';

  @override
  String get reviewsEmptyMessage =>
      'Будьте первым, кто оставит отзыв об этом товаре';

  @override
  String get reviewsAnonymousReviewer => 'Покупатель';

  @override
  String get reviewsHelpful => 'Полезно';

  @override
  String get reviewsLeaveReview => 'Оставить отзыв';

  @override
  String get reviewsWriteTitle => 'Написать отзыв';

  @override
  String reviewsForPurchase(String productName) {
    return 'Отзыв о покупке: $productName';
  }

  @override
  String get reviewsTextLabel => 'Ваш отзыв';

  @override
  String get reviewsTextHint => 'Расскажите о товаре…';

  @override
  String get reviewsImageUrlLabel => 'Прикрепить фото';

  @override
  String get reviewsImageUrlHint => 'Ссылка на фото (URL)';

  @override
  String get reviewsSubmit => 'Отправить отзыв';

  @override
  String get reviewsSubmitSuccess => 'Спасибо! Ваш отзыв отправлен';

  @override
  String get reviewsDuplicateError => 'Вы уже оставили отзыв об этой покупке';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmptyTitle => 'Нет уведомлений';

  @override
  String get notificationsEmptyMessage => 'Здесь появятся ваши уведомления';

  @override
  String get notificationsPreferencesTitle => 'Настройки уведомлений';

  @override
  String get notificationsPrefOrders => 'Заказы';

  @override
  String get notificationsPrefPromotions => 'Скидки и акции';

  @override
  String get notificationsPrefPersonalOffers => 'Персональные предложения';

  @override
  String get notificationsPrefBonusUpdates => 'Изменения TajBonus';

  @override
  String get notificationsPrefNewProducts => 'Новые товары';

  @override
  String get supportTitle => 'Поддержка';

  @override
  String get supportNewConversation => 'Новое обращение';

  @override
  String get supportEmptyTitle => 'Пока нет обращений';

  @override
  String get supportEmptyMessage => 'Если у вас есть вопрос, свяжитесь с нами';

  @override
  String get supportStatusOpen => 'Активно';

  @override
  String get supportStatusClosed => 'Закрыто';

  @override
  String get supportChatTitle => 'Чат с поддержкой';

  @override
  String get supportChatEmptyTitle => 'Нет сообщений';

  @override
  String get supportChatEmptyMessage => 'Отправьте своё первое сообщение';

  @override
  String get supportChatInputHint => 'Напишите сообщение…';

  @override
  String get sellerMenuTitle => 'Стать продавцом';

  @override
  String get sellerIntroBody =>
      'Продавайте на YouShop: укажите местоположение магазина или ссылку, по которой вас найдут покупатели, подтвердите паспорт и личность через быструю проверку лица — всё бесплатно, прямо в приложении.';

  @override
  String get sellerIntroStart => 'Начать';

  @override
  String get sellerStoreInfoTitle => 'Ваш магазин';

  @override
  String get sellerStoreInfoSubtitle =>
      'Укажите GPS-координаты вашего магазина или — если у вас нет физического магазина — ссылку на сайт, Instagram, Telegram или WhatsApp.';

  @override
  String get sellerUseMyLocation => 'Использовать текущее местоположение';

  @override
  String get sellerLocationCaptured => 'Местоположение сохранено';

  @override
  String get locationServiceDisabled =>
      'GPS выключен. Пожалуйста, включите геолокацию.';

  @override
  String get locationPermissionDenied => 'Доступ к геолокации не предоставлен.';

  @override
  String get locationPermissionDeniedForever =>
      'Доступ к геолокации заблокирован. Включите его в настройках.';

  @override
  String get locationLookupFailed =>
      'Не удалось определить местоположение. Попробуйте ещё раз.';

  @override
  String get sellerWebsiteLabel => 'Веб-сайт';

  @override
  String get sellerInstagramLabel => 'Instagram';

  @override
  String get sellerTelegramLabel => 'Telegram';

  @override
  String get sellerWhatsappLabel => 'WhatsApp';

  @override
  String get sellerStoreInfoRequiredError =>
      'Укажите местоположение магазина или хотя бы одну контактную ссылку';

  @override
  String get sellerDocumentsTitle => 'Документы';

  @override
  String get sellerBirthDateLabel => 'Дата рождения';

  @override
  String get sellerBirthDateNotSet => 'Не указана';

  @override
  String get sellerPassportFrontLabel => 'Паспорт — лицевая страница';

  @override
  String get sellerPassportBackLabel => 'Паспорт — обратная страница';

  @override
  String get sellerSelfieWithPassportLabel => 'Селфи с паспортом в руках';

  @override
  String get sellerCapturePhoto => 'Сделать фото';

  @override
  String get sellerRetakePhoto => 'Переснять';

  @override
  String get sellerDocumentsIncompleteError =>
      'Добавьте все три фото и дату рождения';

  @override
  String get sellerFaceTitle => 'Проверка лица';

  @override
  String get sellerFaceInstructionLookNormal =>
      'Смотрите в камеру спокойно, затем нажмите «Снять»';

  @override
  String get sellerFaceInstructionBlink =>
      'Теперь моргните и снова нажмите «Снять»';

  @override
  String get sellerFaceCapture => 'Снять';

  @override
  String get sellerFaceProcessing => 'Проверяем…';

  @override
  String get sellerFaceFailed =>
      'Не удалось подтвердить, что это вы. Убедитесь, что лицо хорошо освещено и полностью видно, и попробуйте снова.';

  @override
  String get sellerSubmitApplication => 'Отправить заявку';

  @override
  String get sellerUnderageError => 'Продавцу должно быть не менее 18 лет';

  @override
  String get sellerApplicationExistsError =>
      'Вы уже подали заявку на статус продавца';

  @override
  String get sellerStatusTitle => 'Заявка продавца';

  @override
  String get sellerStatusPending =>
      'Ваша заявка на рассмотрении. Мы сообщим вам, когда она будет одобрена.';

  @override
  String get sellerStatusApproved =>
      'Поздравляем! Теперь вы продавец на YouShop.';

  @override
  String get sellerStatusRejected => 'Ваша заявка не была одобрена.';

  @override
  String get cargoTitle => 'Карго из Китая';

  @override
  String get cargoHowItWorks => 'Как это работает';

  @override
  String get cargoStepOrder => 'Закажите товар на китайской площадке (Taobao, Pinduoduo и др.)';

  @override
  String get cargoStepShipToWarehouse => 'При заказе укажите адрес нашего склада в Китае';

  @override
  String get cargoStepRegister => 'Зарегистрируйте посылку здесь — трек-код можно добавить позже';

  @override
  String get cargoStepReceive => 'Мы взвесим посылку, назовём цену и доставим её в вашу страну';

  @override
  String get cargoMyParcels => 'Мои посылки';

  @override
  String get cargoRegisterParcel => 'Зарегистрировать посылку';

  @override
  String get cargoDestination => 'Страна доставки';

  @override
  String get cargoDescription => 'Что за товар';

  @override
  String get cargoDescriptionHint => 'Например: 2 пары кроссовок, размер 42';

  @override
  String get cargoTrackCode => 'Трек-код';

  @override
  String get cargoProductLink => 'Ссылка на товар';

  @override
  String get cargoWarehouseAddress => 'Адрес нашего склада в Китае';

  @override
  String get cargoCopyAddress => 'Скопировать адрес';

  @override
  String get cargoAddressCopied => 'Адрес скопирован';

  @override
  String get cargoAwaitingWeighing => 'Ожидает взвешивания';

  @override
  String get cargoCancelParcel => 'Отменить посылку';

  @override
  String get cargoCancelConfirm => 'Вы уверены, что хотите отменить эту заявку?';

  @override
  String get cargoEmptyTitle => 'Посылок пока нет';

  @override
  String get cargoEmptyMessage => 'Зарегистрируйте свою первую посылку из Китая';

  @override
  String get cargoUnavailableMessage => 'Услуга карго сейчас настраивается. Скоро будет доступна.';

  @override
  String get cargoStatusRegistered => 'Зарегистрирована';

  @override
  String get cargoStatusReceived => 'На складе в Китае';

  @override
  String get cargoStatusShipped => 'В пути';

  @override
  String get cargoStatusArrived => 'Прибыла в страну';

  @override
  String get cargoStatusDelivered => 'Выдана';

  @override
  String get cargoStatusCancelled => 'Отменена';

  @override
  String cargoRatePerKg(String price) {
    return '$price / кг';
  }

  @override
  String cargoTransitDays(int min, int max) {
    return '$min–$max дней в пути';
  }

  @override
  String cargoWeightKg(String weight) {
    return 'Вес: $weight кг';
  }

  @override
  String get legalTitle => 'Правовые документы';

  @override
  String get legalSubtitle => 'Политика конфиденциальности, условия, удаление аккаунта';

  @override
  String get legalPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String get legalTerms => 'Условия использования';

  @override
  String get legalDeleteAccountPage => 'Запрос на удаление аккаунта';

  @override
  String get legalOpenFailed => 'Не удалось открыть страницу';

  @override
  String get accountDeleteTitle => 'Удалить аккаунт';

  @override
  String get accountDeleteWarning => 'Ваш профиль, адреса, корзина и избранное будут удалены. Записи о заказах сохранятся для налоговой отчётности, но будут отвязаны от вашего аккаунта. Это действие необратимо.';

  @override
  String get accountDeleteConfirm => 'Да, удалить';
}
