import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tg.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tg'),
    Locale('ru'),
    Locale('en'),
  ];

  /// The application name, shown on splash and in the OS task switcher.
  ///
  /// In tg, this message translates to:
  /// **'TajikShop'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In tg, this message translates to:
  /// **'Асосӣ'**
  String get navHome;

  /// No description provided for @navCatalog.
  ///
  /// In tg, this message translates to:
  /// **'Каталог'**
  String get navCatalog;

  /// No description provided for @navCart.
  ///
  /// In tg, this message translates to:
  /// **'Сабад'**
  String get navCart;

  /// No description provided for @navOrders.
  ///
  /// In tg, this message translates to:
  /// **'Фармоишҳо'**
  String get navOrders;

  /// No description provided for @navProfile.
  ///
  /// In tg, this message translates to:
  /// **'Профил'**
  String get navProfile;

  /// No description provided for @commonLoading.
  ///
  /// In tg, this message translates to:
  /// **'Бор карда истодааст…'**
  String get commonLoading;

  /// No description provided for @commonEmptyTitle.
  ///
  /// In tg, this message translates to:
  /// **'Ин ҷо ҳанӯз чизе нест'**
  String get commonEmptyTitle;

  /// No description provided for @commonEmptyMessage.
  ///
  /// In tg, this message translates to:
  /// **'Дар айни замон маълумот дастрас нест.'**
  String get commonEmptyMessage;

  /// No description provided for @commonErrorTitle.
  ///
  /// In tg, this message translates to:
  /// **'Хатогӣ рӯй дод'**
  String get commonErrorTitle;

  /// No description provided for @commonErrorGeneric.
  ///
  /// In tg, this message translates to:
  /// **'Чизе нодуруст шуд. Лутфан аз нав кӯшиш кунед.'**
  String get commonErrorGeneric;

  /// No description provided for @commonRetry.
  ///
  /// In tg, this message translates to:
  /// **'Аз нав кӯшиш кунед'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In tg, this message translates to:
  /// **'Бекор кардан'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In tg, this message translates to:
  /// **'Тасдиқ'**
  String get commonConfirm;

  /// No description provided for @commonSave.
  ///
  /// In tg, this message translates to:
  /// **'Нигоҳ доштан'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In tg, this message translates to:
  /// **'Таҳрир'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In tg, this message translates to:
  /// **'Нест кардан'**
  String get commonDelete;

  /// No description provided for @commonAdd.
  ///
  /// In tg, this message translates to:
  /// **'Илова кардан'**
  String get commonAdd;

  /// No description provided for @commonDone.
  ///
  /// In tg, this message translates to:
  /// **'Тайёр'**
  String get commonDone;

  /// No description provided for @commonBack.
  ///
  /// In tg, this message translates to:
  /// **'Бозгашт'**
  String get commonBack;

  /// No description provided for @commonSeeAll.
  ///
  /// In tg, this message translates to:
  /// **'Ҳамаашро дидан'**
  String get commonSeeAll;

  /// No description provided for @commonContinue.
  ///
  /// In tg, this message translates to:
  /// **'Идома'**
  String get commonContinue;

  /// No description provided for @commonClose.
  ///
  /// In tg, this message translates to:
  /// **'Пӯшидан'**
  String get commonClose;

  /// No description provided for @commonYes.
  ///
  /// In tg, this message translates to:
  /// **'Ҳа'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In tg, this message translates to:
  /// **'Не'**
  String get commonNo;

  /// No description provided for @commonSearch.
  ///
  /// In tg, this message translates to:
  /// **'Ҷустуҷӯ'**
  String get commonSearch;

  /// No description provided for @commonOptional.
  ///
  /// In tg, this message translates to:
  /// **'(ихтиёрӣ)'**
  String get commonOptional;

  /// No description provided for @offlineBannerMessage.
  ///
  /// In tg, this message translates to:
  /// **'Пайвасти интернет нест'**
  String get offlineBannerMessage;

  /// No description provided for @networkErrorTimeout.
  ///
  /// In tg, this message translates to:
  /// **'Пайваст ба сервер қатъ шуд. Лутфан пайвасти интернети худро санҷед.'**
  String get networkErrorTimeout;

  /// No description provided for @networkErrorNoConnection.
  ///
  /// In tg, this message translates to:
  /// **'Интернет дастрас нест. Лутфан пайвасти худро санҷед ва аз нав кӯшиш кунед.'**
  String get networkErrorNoConnection;

  /// No description provided for @networkErrorCancelled.
  ///
  /// In tg, this message translates to:
  /// **'Дархост бекор карда шуд.'**
  String get networkErrorCancelled;

  /// No description provided for @networkErrorUnknown.
  ///
  /// In tg, this message translates to:
  /// **'Хатогии номаълуми шабака рӯй дод. Лутфан аз нав кӯшиш кунед.'**
  String get networkErrorUnknown;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In tg, this message translates to:
  /// **'Хуш омадед ба TajikShop'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In tg, this message translates to:
  /// **'Барои идома додан рақами телефони худро ворид кунед'**
  String get authWelcomeSubtitle;

  /// No description provided for @authPhoneLabel.
  ///
  /// In tg, this message translates to:
  /// **'Рақами телефон'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In tg, this message translates to:
  /// **'90 123 45 67'**
  String get authPhoneHint;

  /// No description provided for @authPhoneInvalid.
  ///
  /// In tg, this message translates to:
  /// **'Рақами телефон нодуруст аст. Намуна: +992 90 123 45 67'**
  String get authPhoneInvalid;

  /// No description provided for @authSendCode.
  ///
  /// In tg, this message translates to:
  /// **'Гирифтани рамз'**
  String get authSendCode;

  /// No description provided for @authOtpTitle.
  ///
  /// In tg, this message translates to:
  /// **'Рамзи тасдиқро ворид кунед'**
  String get authOtpTitle;

  /// No description provided for @authOtpSubtitle.
  ///
  /// In tg, this message translates to:
  /// **'Мо рамзи 6-рақамаро ба рақами {phone} фиристодем'**
  String authOtpSubtitle(String phone);

  /// No description provided for @authOtpInvalid.
  ///
  /// In tg, this message translates to:
  /// **'Рамз нодуруст аст. Лутфан аз нав кӯшиш кунед.'**
  String get authOtpInvalid;

  /// No description provided for @authOtpExpired.
  ///
  /// In tg, this message translates to:
  /// **'Мӯҳлати рамз гузашт. Рамзи нав дархост кунед.'**
  String get authOtpExpired;

  /// No description provided for @authResendCode.
  ///
  /// In tg, this message translates to:
  /// **'Фиристодани рамз аз нав'**
  String get authResendCode;

  /// No description provided for @authResendCodeIn.
  ///
  /// In tg, this message translates to:
  /// **'Аз нав фиристодан пас аз {seconds} сония'**
  String authResendCodeIn(int seconds);

  /// No description provided for @authVerify.
  ///
  /// In tg, this message translates to:
  /// **'Тасдиқ кардан'**
  String get authVerify;

  /// No description provided for @authChangeNumber.
  ///
  /// In tg, this message translates to:
  /// **'Тағйир додани рақам'**
  String get authChangeNumber;

  /// No description provided for @authLogout.
  ///
  /// In tg, this message translates to:
  /// **'Баромадан'**
  String get authLogout;

  /// No description provided for @authLogoutConfirm.
  ///
  /// In tg, this message translates to:
  /// **'Шумо мутмаин ҳастед, ки мехоҳед бароед?'**
  String get authLogoutConfirm;

  /// No description provided for @authSignInRequiredTitle.
  ///
  /// In tg, this message translates to:
  /// **'Бояд ворид шавед'**
  String get authSignInRequiredTitle;

  /// No description provided for @authSignInRequiredMessage.
  ///
  /// In tg, this message translates to:
  /// **'Барои идома додан лутфан ворид шавед'**
  String get authSignInRequiredMessage;

  /// No description provided for @authSignIn.
  ///
  /// In tg, this message translates to:
  /// **'Ворид шудан'**
  String get authSignIn;

  /// No description provided for @onboardingTitle1.
  ///
  /// In tg, this message translates to:
  /// **'Хариди маҳсулот аз хона'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In tg, this message translates to:
  /// **'Ҳазорон маҳсулоти тару тоза ва рӯзмарраро аз мағозаҳои наздики худ фармоиш диҳед'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In tg, this message translates to:
  /// **'Расонидани тез'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши шумо дар муддати кӯтоҳтарин ба назди шумо расонида мешавад'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In tg, this message translates to:
  /// **'TajBonus-ро ҷамъ кунед'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In tg, this message translates to:
  /// **'Бо ҳар харид бонус ҷамъ кунед ва дар фармоишҳои оянда истифода баред'**
  String get onboardingBody3;

  /// No description provided for @onboardingSkip.
  ///
  /// In tg, this message translates to:
  /// **'Гузаштан'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In tg, this message translates to:
  /// **'Баъдӣ'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In tg, this message translates to:
  /// **'Оғоз кардан'**
  String get onboardingStart;

  /// No description provided for @homeGreeting.
  ///
  /// In tg, this message translates to:
  /// **'Салом!'**
  String get homeGreeting;

  /// No description provided for @homeSectionCategories.
  ///
  /// In tg, this message translates to:
  /// **'Категорияҳо'**
  String get homeSectionCategories;

  /// No description provided for @homeSectionPopular.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулоти маъмул'**
  String get homeSectionPopular;

  /// No description provided for @homeSectionDiscounted.
  ///
  /// In tg, this message translates to:
  /// **'Бо тахфиф'**
  String get homeSectionDiscounted;

  /// No description provided for @homeSectionRecommended.
  ///
  /// In tg, this message translates to:
  /// **'Тавсияи мо'**
  String get homeSectionRecommended;

  /// No description provided for @homeSectionRecentlyViewed.
  ///
  /// In tg, this message translates to:
  /// **'Ба наздикӣ дидаед'**
  String get homeSectionRecentlyViewed;

  /// No description provided for @homeSectionPersonalOffers.
  ///
  /// In tg, this message translates to:
  /// **'Пешниҳодҳои шахсии шумо'**
  String get homeSectionPersonalOffers;

  /// No description provided for @homeSectionNearbyStores.
  ///
  /// In tg, this message translates to:
  /// **'Мағозаҳои наздик'**
  String get homeSectionNearbyStores;

  /// No description provided for @homeSectionFeaturedBrands.
  ///
  /// In tg, this message translates to:
  /// **'Брендҳои маъруф'**
  String get homeSectionFeaturedBrands;

  /// No description provided for @homeSectionBuyAgain.
  ///
  /// In tg, this message translates to:
  /// **'Боз харидорӣ кунед'**
  String get homeSectionBuyAgain;

  /// No description provided for @homeEmptyFeed.
  ///
  /// In tg, this message translates to:
  /// **'Хуруҷи асосӣ дар айни замон холӣ аст. Лутфан баъдтар аз нав ворид шавед.'**
  String get homeEmptyFeed;

  /// No description provided for @catalogTitle.
  ///
  /// In tg, this message translates to:
  /// **'Каталог'**
  String get catalogTitle;

  /// No description provided for @catalogEmptyCategories.
  ///
  /// In tg, this message translates to:
  /// **'Категорияҳо ёфт нашуданд'**
  String get catalogEmptyCategories;

  /// No description provided for @categoryProductsEmpty.
  ///
  /// In tg, this message translates to:
  /// **'Дар ин категория маҳсулот нест'**
  String get categoryProductsEmpty;

  /// No description provided for @searchHint.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулотро ҷустуҷӯ кунед'**
  String get searchHint;

  /// No description provided for @searchRecent.
  ///
  /// In tg, this message translates to:
  /// **'Ҷустуҷӯҳои охирин'**
  String get searchRecent;

  /// No description provided for @searchClearRecent.
  ///
  /// In tg, this message translates to:
  /// **'Пок кардан'**
  String get searchClearRecent;

  /// No description provided for @searchSuggestions.
  ///
  /// In tg, this message translates to:
  /// **'Пешниҳодҳо'**
  String get searchSuggestions;

  /// No description provided for @searchNoResults.
  ///
  /// In tg, this message translates to:
  /// **'Аз рӯи дархости шумо чизе ёфт нашуд'**
  String get searchNoResults;

  /// No description provided for @searchResultsCount.
  ///
  /// In tg, this message translates to:
  /// **'{count} натиҷа ёфт шуд'**
  String searchResultsCount(int count);

  /// No description provided for @productAddToCart.
  ///
  /// In tg, this message translates to:
  /// **'Илова ба сабад'**
  String get productAddToCart;

  /// No description provided for @productOutOfStock.
  ///
  /// In tg, this message translates to:
  /// **'Дар анбор нест'**
  String get productOutOfStock;

  /// No description provided for @productInStock.
  ///
  /// In tg, this message translates to:
  /// **'Дар анбор ҳаст'**
  String get productInStock;

  /// No description provided for @productQuantity.
  ///
  /// In tg, this message translates to:
  /// **'Миқдор'**
  String get productQuantity;

  /// No description provided for @productDescription.
  ///
  /// In tg, this message translates to:
  /// **'Тавсиф'**
  String get productDescription;

  /// No description provided for @productRelated.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулоти монанд'**
  String get productRelated;

  /// No description provided for @productAddedToCart.
  ///
  /// In tg, this message translates to:
  /// **'Ба сабад илова карда шуд'**
  String get productAddedToCart;

  /// No description provided for @productFavoriteAdded.
  ///
  /// In tg, this message translates to:
  /// **'Ба дӯстдоштаҳо илова карда шуд'**
  String get productFavoriteAdded;

  /// No description provided for @productFavoriteRemoved.
  ///
  /// In tg, this message translates to:
  /// **'Аз дӯстдоштаҳо нест карда шуд'**
  String get productFavoriteRemoved;

  /// No description provided for @productDiscountBadge.
  ///
  /// In tg, this message translates to:
  /// **'-{percent}%'**
  String productDiscountBadge(int percent);

  /// No description provided for @productUnavailableTitle.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулот дастрас нест'**
  String get productUnavailableTitle;

  /// No description provided for @productUnavailableMessage.
  ///
  /// In tg, this message translates to:
  /// **'Мутаассифона, ин маҳсулот дар айни замон дастрас нест.'**
  String get productUnavailableMessage;

  /// No description provided for @favoritesTitle.
  ///
  /// In tg, this message translates to:
  /// **'Дӯстдоштаҳо'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In tg, this message translates to:
  /// **'Дӯстдоштаҳо холӣ аст'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyMessage.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулотеро, ки маъқул мешаванд, бо аломати дил нигоҳ доред'**
  String get favoritesEmptyMessage;

  /// No description provided for @cartTitle.
  ///
  /// In tg, this message translates to:
  /// **'Сабад'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In tg, this message translates to:
  /// **'Сабади шумо холӣ аст'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In tg, this message translates to:
  /// **'Барои оғоз маҳсулот илова кунед'**
  String get cartEmptyMessage;

  /// No description provided for @cartRemoveItem.
  ///
  /// In tg, this message translates to:
  /// **'Нест кардан'**
  String get cartRemoveItem;

  /// No description provided for @cartSaveForLater.
  ///
  /// In tg, this message translates to:
  /// **'Барои баъд нигоҳ доштан'**
  String get cartSaveForLater;

  /// No description provided for @cartMoveToCart.
  ///
  /// In tg, this message translates to:
  /// **'Ба сабад гузарондан'**
  String get cartMoveToCart;

  /// No description provided for @cartSavedForLaterTitle.
  ///
  /// In tg, this message translates to:
  /// **'Барои баъд нигоҳ дошташуда'**
  String get cartSavedForLaterTitle;

  /// No description provided for @cartPromoCodeLabel.
  ///
  /// In tg, this message translates to:
  /// **'Рамзи промо'**
  String get cartPromoCodeLabel;

  /// No description provided for @cartPromoCodeHint.
  ///
  /// In tg, this message translates to:
  /// **'Рамзро ворид кунед'**
  String get cartPromoCodeHint;

  /// No description provided for @cartPromoCodeApply.
  ///
  /// In tg, this message translates to:
  /// **'Татбиқ кардан'**
  String get cartPromoCodeApply;

  /// No description provided for @cartPromoCodeApplied.
  ///
  /// In tg, this message translates to:
  /// **'Рамзи промо татбиқ карда шуд'**
  String get cartPromoCodeApplied;

  /// No description provided for @cartPromoCodeRemove.
  ///
  /// In tg, this message translates to:
  /// **'Нест кардан'**
  String get cartPromoCodeRemove;

  /// No description provided for @cartPromoCodeInvalid.
  ///
  /// In tg, this message translates to:
  /// **'Рамзи промо нодуруст ё мӯҳлаташ гузаштааст'**
  String get cartPromoCodeInvalid;

  /// No description provided for @cartSubtotal.
  ///
  /// In tg, this message translates to:
  /// **'Ҷамъи маҳсулот'**
  String get cartSubtotal;

  /// No description provided for @cartDiscount.
  ///
  /// In tg, this message translates to:
  /// **'Тахфиф'**
  String get cartDiscount;

  /// No description provided for @cartDeliveryFee.
  ///
  /// In tg, this message translates to:
  /// **'Ҳаққи расонидан'**
  String get cartDeliveryFee;

  /// No description provided for @cartTotal.
  ///
  /// In tg, this message translates to:
  /// **'Ҳамагӣ'**
  String get cartTotal;

  /// No description provided for @cartServerCalculatedNote.
  ///
  /// In tg, this message translates to:
  /// **'Нархҳо аз ҷониби сервер ҳисоб карда мешаванд'**
  String get cartServerCalculatedNote;

  /// No description provided for @cartCheckoutButton.
  ///
  /// In tg, this message translates to:
  /// **'Ба гузаронидан'**
  String get cartCheckoutButton;

  /// No description provided for @cartClearConfirm.
  ///
  /// In tg, this message translates to:
  /// **'Сабадро тоза кардан?'**
  String get cartClearConfirm;

  /// No description provided for @checkoutTitle.
  ///
  /// In tg, this message translates to:
  /// **'Гузаронидан'**
  String get checkoutTitle;

  /// No description provided for @checkoutDeliveryMethod.
  ///
  /// In tg, this message translates to:
  /// **'Тарзи расонидан'**
  String get checkoutDeliveryMethod;

  /// No description provided for @checkoutDeliveryMethodDelivery.
  ///
  /// In tg, this message translates to:
  /// **'Расонидан'**
  String get checkoutDeliveryMethodDelivery;

  /// No description provided for @checkoutDeliveryMethodPickup.
  ///
  /// In tg, this message translates to:
  /// **'Аз мағоза гирифтан'**
  String get checkoutDeliveryMethodPickup;

  /// No description provided for @checkoutAddressTitle.
  ///
  /// In tg, this message translates to:
  /// **'Суроға'**
  String get checkoutAddressTitle;

  /// No description provided for @checkoutAddressSelect.
  ///
  /// In tg, this message translates to:
  /// **'Суроғаро интихоб кунед'**
  String get checkoutAddressSelect;

  /// No description provided for @checkoutAddressAdd.
  ///
  /// In tg, this message translates to:
  /// **'Суроғаи нав илова кунед'**
  String get checkoutAddressAdd;

  /// No description provided for @checkoutAddressEmpty.
  ///
  /// In tg, this message translates to:
  /// **'Шумо ҳанӯз суроға илова накардаед'**
  String get checkoutAddressEmpty;

  /// No description provided for @checkoutTimeTitle.
  ///
  /// In tg, this message translates to:
  /// **'Вақти расонидан'**
  String get checkoutTimeTitle;

  /// No description provided for @checkoutTimeAsap.
  ///
  /// In tg, this message translates to:
  /// **'Ҳарчи зудтар'**
  String get checkoutTimeAsap;

  /// No description provided for @checkoutTimeScheduled.
  ///
  /// In tg, this message translates to:
  /// **'Вақти муайян'**
  String get checkoutTimeScheduled;

  /// No description provided for @checkoutPaymentTitle.
  ///
  /// In tg, this message translates to:
  /// **'Тарзи пардохт'**
  String get checkoutPaymentTitle;

  /// No description provided for @checkoutPaymentCashOnDelivery.
  ///
  /// In tg, this message translates to:
  /// **'Пардохт ҳангоми расонидан (нақд)'**
  String get checkoutPaymentCashOnDelivery;

  /// No description provided for @checkoutQuoteTitle.
  ///
  /// In tg, this message translates to:
  /// **'Пешнамоиши фармоиш'**
  String get checkoutQuoteTitle;

  /// No description provided for @checkoutPlaceOrder.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиш додан'**
  String get checkoutPlaceOrder;

  /// No description provided for @checkoutOrderSuccessTitle.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиш қабул карда шуд!'**
  String get checkoutOrderSuccessTitle;

  /// No description provided for @checkoutOrderSuccessMessage.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши шумо №{orderNumber} қабул карда шуд ва дар ҳоли коркард аст'**
  String checkoutOrderSuccessMessage(String orderNumber);

  /// No description provided for @checkoutViewOrder.
  ///
  /// In tg, this message translates to:
  /// **'Дидани фармоиш'**
  String get checkoutViewOrder;

  /// No description provided for @checkoutBackToHome.
  ///
  /// In tg, this message translates to:
  /// **'Бозгашт ба саҳифаи асосӣ'**
  String get checkoutBackToHome;

  /// No description provided for @addressLabelHome.
  ///
  /// In tg, this message translates to:
  /// **'Хона'**
  String get addressLabelHome;

  /// No description provided for @addressLabelWork.
  ///
  /// In tg, this message translates to:
  /// **'Кор'**
  String get addressLabelWork;

  /// No description provided for @addressLabelOther.
  ///
  /// In tg, this message translates to:
  /// **'Дигар'**
  String get addressLabelOther;

  /// No description provided for @addressCity.
  ///
  /// In tg, this message translates to:
  /// **'Шаҳр'**
  String get addressCity;

  /// No description provided for @addressStreet.
  ///
  /// In tg, this message translates to:
  /// **'Кӯча'**
  String get addressStreet;

  /// No description provided for @addressHouse.
  ///
  /// In tg, this message translates to:
  /// **'Хонаи'**
  String get addressHouse;

  /// No description provided for @addressApartment.
  ///
  /// In tg, this message translates to:
  /// **'Утоқи'**
  String get addressApartment;

  /// No description provided for @addressEntrance.
  ///
  /// In tg, this message translates to:
  /// **'Даромадгоҳ'**
  String get addressEntrance;

  /// No description provided for @addressFloor.
  ///
  /// In tg, this message translates to:
  /// **'Ошёна'**
  String get addressFloor;

  /// No description provided for @addressComment.
  ///
  /// In tg, this message translates to:
  /// **'Шарҳ'**
  String get addressComment;

  /// No description provided for @addressSetDefault.
  ///
  /// In tg, this message translates to:
  /// **'Ҳамчун асосӣ таъин кардан'**
  String get addressSetDefault;

  /// No description provided for @addressDefault.
  ///
  /// In tg, this message translates to:
  /// **'Асосӣ'**
  String get addressDefault;

  /// No description provided for @addressDelete.
  ///
  /// In tg, this message translates to:
  /// **'Суроғаро нест кардан'**
  String get addressDelete;

  /// No description provided for @ordersTitle.
  ///
  /// In tg, this message translates to:
  /// **'Фармоишҳо'**
  String get ordersTitle;

  /// No description provided for @ordersTabActive.
  ///
  /// In tg, this message translates to:
  /// **'Фаъол'**
  String get ordersTabActive;

  /// No description provided for @ordersTabCompleted.
  ///
  /// In tg, this message translates to:
  /// **'Иҷрошуда'**
  String get ordersTabCompleted;

  /// No description provided for @ordersTabCancelled.
  ///
  /// In tg, this message translates to:
  /// **'Бекоршуда'**
  String get ordersTabCancelled;

  /// No description provided for @ordersEmptyActive.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши фаъол надоред'**
  String get ordersEmptyActive;

  /// No description provided for @ordersEmptyCompleted.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши иҷрошуда надоред'**
  String get ordersEmptyCompleted;

  /// No description provided for @ordersEmptyCancelled.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши бекоршуда надоред'**
  String get ordersEmptyCancelled;

  /// No description provided for @orderNumber.
  ///
  /// In tg, this message translates to:
  /// **'Фармоиши №{number}'**
  String orderNumber(String number);

  /// No description provided for @orderDetailTitle.
  ///
  /// In tg, this message translates to:
  /// **'Тафсилоти фармоиш'**
  String get orderDetailTitle;

  /// No description provided for @orderItemsTitle.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулот'**
  String get orderItemsTitle;

  /// No description provided for @orderStatusHistory.
  ///
  /// In tg, this message translates to:
  /// **'Таърихи ҳолат'**
  String get orderStatusHistory;

  /// No description provided for @orderCancel.
  ///
  /// In tg, this message translates to:
  /// **'Бекор кардани фармоиш'**
  String get orderCancel;

  /// No description provided for @orderCancelReasonHint.
  ///
  /// In tg, this message translates to:
  /// **'Сабаби бекоркуниро нависед'**
  String get orderCancelReasonHint;

  /// No description provided for @orderReorder.
  ///
  /// In tg, this message translates to:
  /// **'Такрори фармоиш'**
  String get orderReorder;

  /// No description provided for @orderReceipt.
  ///
  /// In tg, this message translates to:
  /// **'Чек'**
  String get orderReceipt;

  /// No description provided for @orderStatusPending.
  ///
  /// In tg, this message translates to:
  /// **'Дар интизорӣ'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In tg, this message translates to:
  /// **'Тасдиқшуда'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusPreparing.
  ///
  /// In tg, this message translates to:
  /// **'Дар ҳоли омодасозӣ'**
  String get orderStatusPreparing;

  /// No description provided for @orderStatusReady.
  ///
  /// In tg, this message translates to:
  /// **'Тайёр'**
  String get orderStatusReady;

  /// No description provided for @orderStatusCourierAssigned.
  ///
  /// In tg, this message translates to:
  /// **'Курйер таъин шуд'**
  String get orderStatusCourierAssigned;

  /// No description provided for @orderStatusPickedUp.
  ///
  /// In tg, this message translates to:
  /// **'Курйер гирифт'**
  String get orderStatusPickedUp;

  /// No description provided for @orderStatusDelivering.
  ///
  /// In tg, this message translates to:
  /// **'Дар роҳи расонидан'**
  String get orderStatusDelivering;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In tg, this message translates to:
  /// **'Расонида шуд'**
  String get orderStatusDelivered;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In tg, this message translates to:
  /// **'Бекоршуда'**
  String get orderStatusCancelled;

  /// No description provided for @profileTitle.
  ///
  /// In tg, this message translates to:
  /// **'Профил'**
  String get profileTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In tg, this message translates to:
  /// **'Таҳрири профил'**
  String get profileEditTitle;

  /// No description provided for @profileFullName.
  ///
  /// In tg, this message translates to:
  /// **'Ному насаб'**
  String get profileFullName;

  /// No description provided for @profileEmail.
  ///
  /// In tg, this message translates to:
  /// **'Почтаи электронӣ'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In tg, this message translates to:
  /// **'Рақами телефон'**
  String get profilePhone;

  /// No description provided for @profileLanguage.
  ///
  /// In tg, this message translates to:
  /// **'Забон'**
  String get profileLanguage;

  /// No description provided for @profileAddresses.
  ///
  /// In tg, this message translates to:
  /// **'Суроғаҳои ман'**
  String get profileAddresses;

  /// No description provided for @profileMyOrders.
  ///
  /// In tg, this message translates to:
  /// **'Фармоишҳои ман'**
  String get profileMyOrders;

  /// No description provided for @profileFavorites.
  ///
  /// In tg, this message translates to:
  /// **'Дӯстдоштаҳо'**
  String get profileFavorites;

  /// No description provided for @profileSettings.
  ///
  /// In tg, this message translates to:
  /// **'Танзимот'**
  String get profileSettings;

  /// No description provided for @profileSaved.
  ///
  /// In tg, this message translates to:
  /// **'Профил нигоҳ дошта шуд'**
  String get profileSaved;

  /// No description provided for @profileGuestTitle.
  ///
  /// In tg, this message translates to:
  /// **'Меҳмон'**
  String get profileGuestTitle;

  /// No description provided for @profileGuestMessage.
  ///
  /// In tg, this message translates to:
  /// **'Барои дидани профили худ ворид шавед'**
  String get profileGuestMessage;

  /// No description provided for @languageSelectTitle.
  ///
  /// In tg, this message translates to:
  /// **'Забонро интихоб кунед'**
  String get languageSelectTitle;

  /// No description provided for @languageTajik.
  ///
  /// In tg, this message translates to:
  /// **'Тоҷикӣ'**
  String get languageTajik;

  /// No description provided for @languageRussian.
  ///
  /// In tg, this message translates to:
  /// **'Русӣ'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In tg, this message translates to:
  /// **'Англисӣ'**
  String get languageEnglish;

  /// No description provided for @splashTagline.
  ///
  /// In tg, this message translates to:
  /// **'Хариди осон, расонидани тез'**
  String get splashTagline;

  /// No description provided for @barcodeScanTitle.
  ///
  /// In tg, this message translates to:
  /// **'Сканери рамз'**
  String get barcodeScanTitle;

  /// No description provided for @barcodeScanInstructions.
  ///
  /// In tg, this message translates to:
  /// **'Рамзи маҳсулотро дар чорчӯба ҷойгир кунед'**
  String get barcodeScanInstructions;

  /// No description provided for @barcodeCameraPermissionTitle.
  ///
  /// In tg, this message translates to:
  /// **'Дастрасӣ ба камера лозим аст'**
  String get barcodeCameraPermissionTitle;

  /// No description provided for @barcodeCameraPermissionMessage.
  ///
  /// In tg, this message translates to:
  /// **'Барои сканеркунии рамзи маҳсулот лутфан ба камера дастрасӣ диҳед'**
  String get barcodeCameraPermissionMessage;

  /// No description provided for @barcodeCameraPermissionGrant.
  ///
  /// In tg, this message translates to:
  /// **'Додани дастрасӣ'**
  String get barcodeCameraPermissionGrant;

  /// No description provided for @barcodeCameraPermissionOpenSettings.
  ///
  /// In tg, this message translates to:
  /// **'Кушодани танзимот'**
  String get barcodeCameraPermissionOpenSettings;

  /// No description provided for @barcodeNotFoundTitle.
  ///
  /// In tg, this message translates to:
  /// **'Маҳсулот ёфт нашуд'**
  String get barcodeNotFoundTitle;

  /// No description provided for @barcodeNotFoundMessage.
  ///
  /// In tg, this message translates to:
  /// **'Мутаассифона, ягон маҳсулот бо рамзи {code} ёфт нашуд'**
  String barcodeNotFoundMessage(String code);

  /// No description provided for @barcodeScanAgain.
  ///
  /// In tg, this message translates to:
  /// **'Аз нав сканер кардан'**
  String get barcodeScanAgain;

  /// No description provided for @barcodeResultTitle.
  ///
  /// In tg, this message translates to:
  /// **'Натиҷаи сканер'**
  String get barcodeResultTitle;

  /// No description provided for @barcodeToggleFlash.
  ///
  /// In tg, this message translates to:
  /// **'Чарроғак'**
  String get barcodeToggleFlash;

  /// No description provided for @barcodeSwitchCamera.
  ///
  /// In tg, this message translates to:
  /// **'Иваз кардани камера'**
  String get barcodeSwitchCamera;

  /// No description provided for @orderTrackingTitle.
  ///
  /// In tg, this message translates to:
  /// **'Пайгирии фармоиш'**
  String get orderTrackingTitle;

  /// No description provided for @orderTrackingLive.
  ///
  /// In tg, this message translates to:
  /// **'Зинда'**
  String get orderTrackingLive;

  /// No description provided for @storesMapTitle.
  ///
  /// In tg, this message translates to:
  /// **'Мағозаҳои наздик'**
  String get storesMapTitle;

  /// No description provided for @storesMapPermissionTitle.
  ///
  /// In tg, this message translates to:
  /// **'Дастрасӣ ба ҷойгиршавӣ лозим аст'**
  String get storesMapPermissionTitle;

  /// No description provided for @storesMapPermissionMessage.
  ///
  /// In tg, this message translates to:
  /// **'Барои нишон додани мағозаҳои наздик дар харита лутфан ба ҷойгиршавии худ дастрасӣ диҳед'**
  String get storesMapPermissionMessage;

  /// No description provided for @storesMapPermissionGrant.
  ///
  /// In tg, this message translates to:
  /// **'Додани дастрасӣ'**
  String get storesMapPermissionGrant;

  /// No description provided for @storesMapPermissionOpenSettings.
  ///
  /// In tg, this message translates to:
  /// **'Кушодани танзимот'**
  String get storesMapPermissionOpenSettings;

  /// No description provided for @storesMapChooseManually.
  ///
  /// In tg, this message translates to:
  /// **'Ба ҷои он суроға интихоб кунед'**
  String get storesMapChooseManually;

  /// No description provided for @storesMapEmptyTitle.
  ///
  /// In tg, this message translates to:
  /// **'Дар наздикӣ мағоза ёфт нашуд'**
  String get storesMapEmptyTitle;

  /// No description provided for @storeDistanceAway.
  ///
  /// In tg, this message translates to:
  /// **'{km} км дуртар'**
  String storeDistanceAway(String km);

  /// No description provided for @storeDeliveryAvailable.
  ///
  /// In tg, this message translates to:
  /// **'Расонидан дастрас аст'**
  String get storeDeliveryAvailable;

  /// No description provided for @storePickupAvailable.
  ///
  /// In tg, this message translates to:
  /// **'Гирифтан аз мағоза дастрас аст'**
  String get storePickupAvailable;

  /// No description provided for @storeSells.
  ///
  /// In tg, this message translates to:
  /// **'Ин мағоза чӣ мефурӯшад'**
  String get storeSells;

  /// No description provided for @storeBrowseCatalog.
  ///
  /// In tg, this message translates to:
  /// **'Дидани каталог'**
  String get storeBrowseCatalog;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'tg'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tg':
      return AppLocalizationsTg();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
