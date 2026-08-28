// Package legal embeds the public legal documents so the compiled binary
// serves them with no filesystem or static-host dependency. Google Play
// requires a reachable privacy-policy URL and, for any app with accounts, a
// web page where deletion can be requested without signing in.
package legal

import _ "embed"

// PrivacyPolicyMarkdown is docs/PRIVACY_POLICY.md, the single source of
// truth for the policy text.
//
//go:embed privacy_policy.md
var PrivacyPolicyMarkdown string

// TermsMarkdown is docs/TERMS_OF_SERVICE.md.
//
//go:embed terms_of_service.md
var TermsMarkdown string
