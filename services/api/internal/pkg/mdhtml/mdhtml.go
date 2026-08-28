// Package mdhtml renders the small Markdown subset the legal documents in
// docs/ actually use into HTML, so those files stay the single source of
// truth for the public /privacy and /terms pages instead of being
// duplicated into Go templates that then drift out of sync.
//
// This is deliberately not a general Markdown implementation: it handles
// ATX headings, paragraphs, unordered lists, horizontal rules, and the
// inline bold/italic/link forms, and nothing else. Anything it does not
// recognize is emitted as escaped text rather than guessed at, so an
// unsupported construct shows up as visibly literal in review instead of
// silently producing broken markup.
package mdhtml

import (
	"fmt"
	"html"
	"regexp"
	"strings"
)

var (
	boldRe   = regexp.MustCompile(`\*\*([^*]+)\*\*`)
	italicRe = regexp.MustCompile(`_([^_]+)_`)
	linkRe   = regexp.MustCompile(`\[([^\]]+)\]\(([^)\s]+)\)`)
)

// Render converts a Markdown document into an HTML fragment (no <html> or
// <body> wrapper — see Page for that).
func Render(markdown string) string {
	var b strings.Builder
	var paragraph []string
	inList := false

	flushParagraph := func() {
		if len(paragraph) == 0 {
			return
		}
		fmt.Fprintf(&b, "<p>%s</p>\n", renderInline(strings.Join(paragraph, " ")))
		paragraph = paragraph[:0]
	}
	closeList := func() {
		if inList {
			b.WriteString("</ul>\n")
			inList = false
		}
	}

	for _, rawLine := range strings.Split(markdown, "\n") {
		line := strings.TrimRight(rawLine, " \t")
		trimmed := strings.TrimSpace(line)

		switch {
		case trimmed == "":
			flushParagraph()
			closeList()

		case strings.HasPrefix(trimmed, "---") && strings.Trim(trimmed, "-") == "":
			flushParagraph()
			closeList()
			b.WriteString("<hr>\n")

		case strings.HasPrefix(trimmed, "#"):
			flushParagraph()
			closeList()
			level := len(trimmed) - len(strings.TrimLeft(trimmed, "#"))
			if level > 6 {
				level = 6
			}
			text := strings.TrimSpace(strings.TrimLeft(trimmed, "#"))
			fmt.Fprintf(&b, "<h%d>%s</h%d>\n", level, renderInline(text), level)

		case strings.HasPrefix(trimmed, "- "):
			flushParagraph()
			if !inList {
				b.WriteString("<ul>\n")
				inList = true
			}
			fmt.Fprintf(&b, "<li>%s</li>\n", renderInline(strings.TrimSpace(trimmed[2:])))

		default:
			// A continuation line indented under a list item belongs to that
			// item's text, which the docs rely on for wrapped bullets.
			if inList && strings.HasPrefix(line, "  ") {
				continue
			}
			closeList()
			paragraph = append(paragraph, trimmed)
		}
	}
	flushParagraph()
	closeList()
	return b.String()
}

// renderInline escapes the text first and only then re-introduces the
// handful of tags the inline syntax produces, so no markup can arrive from
// the document content itself.
func renderInline(text string) string {
	escaped := html.EscapeString(text)
	escaped = linkRe.ReplaceAllStringFunc(escaped, func(match string) string {
		parts := linkRe.FindStringSubmatch(match)
		href := parts[2]
		// Only the schemes a legal page legitimately needs; anything else
		// (javascript:, data:) is left as plain text.
		if !strings.HasPrefix(href, "https://") && !strings.HasPrefix(href, "mailto:") {
			return parts[1]
		}
		return fmt.Sprintf(`<a href="%s">%s</a>`, href, parts[1])
	})
	escaped = boldRe.ReplaceAllString(escaped, "<strong>$1</strong>")
	escaped = italicRe.ReplaceAllString(escaped, "<em>$1</em>")
	return escaped
}

// Page wraps an HTML fragment in a complete, self-contained document. The
// CSS is inlined because these pages are served straight from the API with
// no static-asset host, and they have to render for a Play reviewer with no
// network access beyond this one request.
func Page(title, body string) string {
	return `<!DOCTYPE html>
<html lang="tg">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>` + html.EscapeString(title) + `</title>
<style>
:root { color-scheme: light dark; }
body {
  margin: 0 auto; padding: 24px 20px 64px; max-width: 46rem;
  font: 16px/1.65 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  color: #14281d; background: #ffffff;
}
@media (prefers-color-scheme: dark) {
  body { color: #e7f0ea; background: #0d1b12; }
  a { color: #6ee7a8; }
  hr { border-color: #24402f; }
}
h1 { font-size: 1.6rem; margin: 0 0 .4em; }
h2 { font-size: 1.25rem; margin: 1.8em 0 .4em; }
h3 { font-size: 1.05rem; margin: 1.4em 0 .3em; }
ul { padding-left: 1.2em; }
li { margin: .3em 0; }
a { color: #0f7a49; }
hr { border: 0; border-top: 1px solid #d8e5dd; margin: 2em 0; }
</style>
</head>
<body>
` + body + `</body>
</html>
`
}
