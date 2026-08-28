package httpapi

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"tajikshop/api/internal/legal"
	"tajikshop/api/internal/pkg/mdhtml"
)

// LegalHandler serves the public legal pages. They live at the server root
// rather than under /api/v1 because they are URLs a person opens in a
// browser — the Play Console listing links to them directly — not API
// endpoints an app calls.
type LegalHandler struct{}

// NewLegalHandler builds a LegalHandler.
func NewLegalHandler() *LegalHandler { return &LegalHandler{} }

// Privacy handles GET /privacy — the policy URL required by Google Play.
func (h *LegalHandler) Privacy(c *gin.Context) {
	html(c, "YouShop — Privacy Policy", legal.PrivacyPolicyMarkdown)
}

// Terms handles GET /terms.
func (h *LegalHandler) Terms(c *gin.Context) {
	html(c, "YouShop — Terms of Service", legal.TermsMarkdown)
}

// DeleteAccount handles GET /delete-account.
//
// Google Play requires a web page where account deletion can be requested
// without signing in — someone who has lost access to their email cannot
// use the in-app path. The page explains both routes and gives the address
// to write to; it deliberately has no form, because a form that anyone can
// submit against any address is an account-deletion vector, and a request
// arriving from the account's own mailbox is the check that matters.
func (h *LegalHandler) DeleteAccount(c *gin.Context) {
	html(c, "YouShop — Delete account", deleteAccountMarkdown)
}

func html(c *gin.Context, title, markdown string) {
	c.Data(http.StatusOK, "text/html; charset=utf-8",
		[]byte(mdhtml.Page(title, mdhtml.Render(markdown))))
}

const deleteAccountMarkdown = `# Нест кардани ҳисоб · Удаление аккаунта · Delete account

## Tajik

Дар барномаи YouShop: **Профил → Танзимот → Нест кардани ҳисоб**. Ҳисоб
дарҳол нест мешавад ва аз ҳамаи дастгоҳҳо баромад анҷом дода мешавад.

Агар ба ҳисоби худ дохил шуда натавонед, аз ҳамон почтае, ки бо он сабти ном
шудаед, ба [support@youshop.tj](mailto:support@youshop.tj) нависед ва дар
мавзӯъ «Нест кардани ҳисоб» гузоред. Мо дар давоми 30 рӯз иҷро мекунем.

**Чӣ нест мешавад:** профил (почта, ном, рақами телефон, акс), суроғаҳо,
сабад, интихобҳо ва баррасиҳо.

**Чӣ нигоҳ дошта мешавад:** сабтҳои фармоишу пардохт, ки қонунгузории
андоз талаб мекунад — вале онҳо аз ҳисоби шумо ҷудо карда мешаванд.

---

## Russian

В приложении YouShop: **Профиль → Настройки → Удалить аккаунт**. Аккаунт
удаляется сразу, и выполняется выход на всех устройствах.

Если вы не можете войти, напишите с того же адреса, на который
зарегистрирован аккаунт, на [support@youshop.tj](mailto:support@youshop.tj)
с темой «Удаление аккаунта». Мы выполним запрос в течение 30 дней.

**Что удаляется:** профиль (email, имя, телефон, фото), адреса, корзина,
избранное и отзывы.

**Что сохраняется:** записи о заказах и платежах, которые требует налоговое
законодательство — но они отвязываются от вашего аккаунта.

---

## English

In the YouShop app: **Profile → Settings → Delete account**. The account is
deleted immediately and every device is signed out.

If you cannot sign in, write from the address the account is registered to,
to [support@youshop.tj](mailto:support@youshop.tj) with the subject "Delete
account". We complete requests within 30 days.

**Deleted:** profile (email, name, phone, photo), addresses, cart,
favourites and reviews.

**Retained:** order and payment records that tax law requires us to keep —
detached from your account.
`
