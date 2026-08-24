// Package apperr defines the stable machine-readable error codes used
// across the API and the {"error":{"code","message","details"}} envelope
// described in docs/API_SPEC.md. Messages are localized server-side from
// Accept-Language (tj default, ru supported).
package apperr

import (
	"errors"
	"net/http"
)

// Code is a stable, machine-readable error identifier.
type Code string

const (
	CodeValidation              Code = "VALIDATION_ERROR"
	CodeUnauthorized            Code = "UNAUTHORIZED"
	CodeForbidden               Code = "FORBIDDEN"
	CodeNotFound                Code = "NOT_FOUND"
	CodeConflict                Code = "CONFLICT"
	CodeInternal                Code = "INTERNAL_ERROR"
	CodeRateLimited             Code = "RATE_LIMITED"
	CodePhoneInvalid            Code = "PHONE_INVALID"
	CodeOTPInvalid              Code = "OTP_INVALID"
	CodeOTPExpired              Code = "OTP_EXPIRED"
	CodeOTPMaxAttempts          Code = "OTP_MAX_ATTEMPTS"
	CodeOTPCooldown             Code = "OTP_COOLDOWN"
	CodeSessionExpired          Code = "SESSION_EXPIRED"
	CodeSessionRevoked          Code = "SESSION_REVOKED"
	CodeOutOfStock              Code = "OUT_OF_STOCK"
	CodeCartEmpty               Code = "CART_EMPTY"
	CodeCartStoreMismatch       Code = "CART_STORE_MISMATCH"
	CodeProductNotFound         Code = "PRODUCT_NOT_FOUND"
	CodePromoInvalid            Code = "PROMO_INVALID"
	CodePromoExpired            Code = "PROMO_EXPIRED"
	CodePromoMinOrder           Code = "PROMO_MIN_ORDER_NOT_MET"
	CodePromoLimitReached       Code = "PROMO_LIMIT_REACHED"
	CodeAddressOutOfZone        Code = "ADDRESS_OUT_OF_ZONE"
	CodeAddressRequired         Code = "ADDRESS_REQUIRED"
	CodeInsufficientBonus       Code = "INSUFFICIENT_BONUS_BALANCE"
	CodeMinOrderNotMet          Code = "MIN_ORDER_NOT_MET"
	CodeOrderNotCancelable      Code = "ORDER_NOT_CANCELABLE"
	CodeIdempotencyRequired     Code = "IDEMPOTENCY_KEY_REQUIRED"
	CodeIdempotencyConflict     Code = "IDEMPOTENCY_KEY_CONFLICT"
	CodeFirebaseNotConfigured   Code = "FIREBASE_NOT_CONFIGURED"
	CodeFirebaseTokenInvalid    Code = "FIREBASE_TOKEN_INVALID"
	CodeFirebasePhoneMissing    Code = "FIREBASE_PHONE_MISSING"
	CodeDuplicateReview         Code = "DUPLICATE_REVIEW"
	CodeReviewRequiresPurchase  Code = "REVIEW_REQUIRES_PURCHASE"
	CodeUploadsNotConfigured    Code = "UPLOADS_NOT_CONFIGURED"
	CodeUploadContentType       Code = "UPLOAD_CONTENT_TYPE_UNSUPPORTED"
	CodeTelegramNotLinked       Code = "TELEGRAM_NOT_LINKED"
	CodeEmailTaken              Code = "EMAIL_TAKEN"
	CodeSellerUnderage          Code = "SELLER_UNDERAGE"
	CodeSellerApplicationExists Code = "SELLER_APPLICATION_EXISTS"
	CodeSellerFaceMismatch      Code = "SELLER_FACE_MISMATCH"
)

// httpStatus maps each code to its HTTP status.
var httpStatus = map[Code]int{
	CodeValidation:              http.StatusBadRequest,
	CodeUnauthorized:            http.StatusUnauthorized,
	CodeForbidden:               http.StatusForbidden,
	CodeNotFound:                http.StatusNotFound,
	CodeConflict:                http.StatusConflict,
	CodeInternal:                http.StatusInternalServerError,
	CodeRateLimited:             http.StatusTooManyRequests,
	CodePhoneInvalid:            http.StatusBadRequest,
	CodeOTPInvalid:              http.StatusBadRequest,
	CodeOTPExpired:              http.StatusBadRequest,
	CodeOTPMaxAttempts:          http.StatusTooManyRequests,
	CodeOTPCooldown:             http.StatusTooManyRequests,
	CodeSessionExpired:          http.StatusUnauthorized,
	CodeSessionRevoked:          http.StatusUnauthorized,
	CodeOutOfStock:              http.StatusConflict,
	CodeCartEmpty:               http.StatusBadRequest,
	CodeCartStoreMismatch:       http.StatusConflict,
	CodeProductNotFound:         http.StatusNotFound,
	CodePromoInvalid:            http.StatusBadRequest,
	CodePromoExpired:            http.StatusBadRequest,
	CodePromoMinOrder:           http.StatusBadRequest,
	CodePromoLimitReached:       http.StatusBadRequest,
	CodeAddressOutOfZone:        http.StatusBadRequest,
	CodeAddressRequired:         http.StatusBadRequest,
	CodeInsufficientBonus:       http.StatusBadRequest,
	CodeMinOrderNotMet:          http.StatusBadRequest,
	CodeOrderNotCancelable:      http.StatusConflict,
	CodeIdempotencyRequired:     http.StatusBadRequest,
	CodeIdempotencyConflict:     http.StatusConflict,
	CodeFirebaseNotConfigured:   http.StatusServiceUnavailable,
	CodeFirebaseTokenInvalid:    http.StatusUnauthorized,
	CodeFirebasePhoneMissing:    http.StatusBadRequest,
	CodeDuplicateReview:         http.StatusConflict,
	CodeReviewRequiresPurchase:  http.StatusForbidden,
	CodeUploadsNotConfigured:    http.StatusServiceUnavailable,
	CodeUploadContentType:       http.StatusBadRequest,
	CodeTelegramNotLinked:       http.StatusPreconditionRequired,
	CodeEmailTaken:              http.StatusConflict,
	CodeSellerUnderage:          http.StatusForbidden,
	CodeSellerApplicationExists: http.StatusConflict,
	CodeSellerFaceMismatch:      http.StatusUnprocessableEntity,
}

// messagesTJ / messagesRU hold the localized default messages per code.
var messagesTJ = map[Code]string{
	CodeValidation:              "Маълумоти воридшуда нодуруст аст",
	CodeUnauthorized:            "Шумо бояд ворид шавед",
	CodeForbidden:               "Дастрасӣ манъ аст",
	CodeNotFound:                "Маълумот ёфт нашуд",
	CodeConflict:                "Ихтилофи маълумот рух дод",
	CodeInternal:                "Хатогии дохилии сервер",
	CodeRateLimited:             "Шумораи дархостҳо зиёд аст, лутфан баъдтар кӯшиш кунед",
	CodePhoneInvalid:            "Рақами телефон нодуруст аст",
	CodeOTPInvalid:              "Рамзи тасдиқ нодуруст аст",
	CodeOTPExpired:              "Мӯҳлати рамзи тасдиқ гузаштааст",
	CodeOTPMaxAttempts:          "Шумораи кӯшишҳо зиёд аст, рамзи нав дархост кунед",
	CodeOTPCooldown:             "Лутфан пеш аз дархости рамзи нав интизор шавед",
	CodeSessionExpired:          "Мӯҳлати воридшавӣ гузаштааст, лутфан аз нав ворид шавед",
	CodeSessionRevoked:          "Ин ҷаласа бекор карда шудааст",
	CodeOutOfStock:              "Маҳсулот дар анбор нест",
	CodeCartEmpty:               "Сабади харид холӣ аст",
	CodeCartStoreMismatch:       "Маҳсулот аз дӯкони дигар аст",
	CodeProductNotFound:         "Маҳсулот ёфт нашуд",
	CodePromoInvalid:            "Рамзи промо нодуруст аст",
	CodePromoExpired:            "Мӯҳлати рамзи промо гузаштааст",
	CodePromoMinOrder:           "Маблағи фармоиш барои ин рамзи промо кофӣ нест",
	CodePromoLimitReached:       "Лимити истифодаи рамзи промо тамом шуд",
	CodeAddressOutOfZone:        "Ин суроға берун аз минтақаи расонидан аст",
	CodeAddressRequired:         "Суроға барои расонидан лозим аст",
	CodeInsufficientBonus:       "Маблағи бонус кофӣ нест",
	CodeMinOrderNotMet:          "Маблағи фармоиш аз ҳадди ақал камтар аст",
	CodeOrderNotCancelable:      "Ин фармоишро бекор кардан имконнопазир аст",
	CodeIdempotencyRequired:     "Сарлавҳаи Idempotency-Key лозим аст",
	CodeIdempotencyConflict:     "Ин дархост бо маълумоти дигар аллакай коркард шудааст",
	CodeFirebaseNotConfigured:   "Воридшавӣ тавассути SMS ҳоло фаъол нест",
	CodeFirebaseTokenInvalid:    "Тасдиқи SMS нодуруст ё мӯҳлаташ гузаштааст",
	CodeFirebasePhoneMissing:    "Рақами телефон тасдиқшуда ёфт нашуд",
	CodeDuplicateReview:         "Шумо аллакай барои ин маҳсулот аз рӯи ин фармоиш шарҳ навиштаед",
	CodeReviewRequiresPurchase:  "Шарҳ танҳо пас аз харидани маҳсулот навишта мешавад",
	CodeUploadsNotConfigured:    "Боргузории акс ҳоло фаъол нест",
	CodeUploadContentType:       "Танҳо акси JPEG, PNG ё WebP қабул карда мешавад",
	CodeTelegramNotLinked:       "Барои гирифтани рамз, аввал бот-ро дар Telegram кушоед ва тугмаи Start-ро пахш кунед",
	CodeEmailTaken:              "Ин почтаи электронӣ аллакай истифода шудааст",
	CodeSellerUnderage:          "Синну соли фурушанда бояд на камтар аз 18 сол бошад",
	CodeSellerApplicationExists: "Шумо аллакай дархости фурушандашавӣ фиристодаед",
	CodeSellerFaceMismatch:      "Чеҳраи шумо бо акси шиноснома мувофиқат намекунад",
}

var messagesRU = map[Code]string{
	CodeValidation:              "Введённые данные некорректны",
	CodeUnauthorized:            "Необходимо войти в систему",
	CodeForbidden:               "Доступ запрещён",
	CodeNotFound:                "Данные не найдены",
	CodeConflict:                "Конфликт данных",
	CodeInternal:                "Внутренняя ошибка сервера",
	CodeRateLimited:             "Слишком много запросов, попробуйте позже",
	CodePhoneInvalid:            "Некорректный номер телефона",
	CodeOTPInvalid:              "Неверный код подтверждения",
	CodeOTPExpired:              "Срок действия кода истёк",
	CodeOTPMaxAttempts:          "Слишком много попыток, запросите новый код",
	CodeOTPCooldown:             "Подождите перед повторным запросом кода",
	CodeSessionExpired:          "Сессия истекла, войдите снова",
	CodeSessionRevoked:          "Эта сессия отозвана",
	CodeOutOfStock:              "Товара нет в наличии",
	CodeCartEmpty:               "Корзина пуста",
	CodeCartStoreMismatch:       "Товар из другого магазина",
	CodeProductNotFound:         "Товар не найден",
	CodePromoInvalid:            "Промокод недействителен",
	CodePromoExpired:            "Срок действия промокода истёк",
	CodePromoMinOrder:           "Сумма заказа недостаточна для этого промокода",
	CodePromoLimitReached:       "Лимит использования промокода исчерпан",
	CodeAddressOutOfZone:        "Этот адрес находится вне зоны доставки",
	CodeAddressRequired:         "Для доставки требуется адрес",
	CodeInsufficientBonus:       "Недостаточно бонусов",
	CodeMinOrderNotMet:          "Сумма заказа меньше минимальной",
	CodeOrderNotCancelable:      "Этот заказ нельзя отменить",
	CodeIdempotencyRequired:     "Требуется заголовок Idempotency-Key",
	CodeIdempotencyConflict:     "Этот запрос уже был обработан с другими данными",
	CodeFirebaseNotConfigured:   "Вход через SMS пока не подключён",
	CodeFirebaseTokenInvalid:    "Подтверждение SMS недействительно или истекло",
	CodeFirebasePhoneMissing:    "Подтверждённый номер телефона не найден",
	CodeDuplicateReview:         "Вы уже оставили отзыв на этот товар по этому заказу",
	CodeReviewRequiresPurchase:  "Отзыв можно оставить только после покупки товара",
	CodeUploadsNotConfigured:    "Загрузка изображений пока не подключена",
	CodeUploadContentType:       "Принимаются только изображения JPEG, PNG или WebP",
	CodeTelegramNotLinked:       "Чтобы получить код, сначала откройте бота в Telegram и нажмите Start",
	CodeEmailTaken:              "Этот email уже используется",
	CodeSellerUnderage:          "Продавцу должно быть не менее 18 лет",
	CodeSellerApplicationExists: "Вы уже подали заявку на статус продавца",
	CodeSellerFaceMismatch:      "Ваше лицо не совпадает с фото в паспорте",
}

// Error is the application error type carried through the service layer and
// rendered by httpapi into the standard envelope.
type Error struct {
	Code    Code
	Message string // overrides the default localized message when non-empty
	Details map[string]any
	cause   error
}

func (e *Error) Error() string {
	if e.Message != "" {
		return e.Message
	}
	return string(e.Code)
}

func (e *Error) Unwrap() error { return e.cause }

// New builds an Error with the default localized message resolved later at
// the HTTP boundary (based on request language).
func New(code Code, details map[string]any) *Error {
	return &Error{Code: code, Details: details}
}

// Wrap builds an Error that also carries an underlying cause for logging.
func Wrap(code Code, cause error, details map[string]any) *Error {
	return &Error{Code: code, Details: details, cause: cause}
}

// WithMessage overrides the localized default with an explicit message.
func (e *Error) WithMessage(msg string) *Error {
	e.Message = msg
	return e
}

// HTTPStatus returns the HTTP status code for e.Code, defaulting to 500.
func (e *Error) HTTPStatus() int {
	if s, ok := httpStatus[e.Code]; ok {
		return s
	}
	return http.StatusInternalServerError
}

// Localize resolves the display message for a code + language ("tj"/"ru").
// Unknown/empty languages fall back to Tajik, per docs/API_SPEC.md.
func Localize(code Code, lang string) string {
	if lang == "ru" {
		if m, ok := messagesRU[code]; ok {
			return m
		}
	}
	if m, ok := messagesTJ[code]; ok {
		return m
	}
	return string(code)
}

// As is a convenience wrapper around errors.As for *Error.
func As(err error) (*Error, bool) {
	var target *Error
	if errors.As(err, &target) {
		return target, true
	}
	return nil, false
}
