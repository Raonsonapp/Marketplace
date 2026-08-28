package mdhtml

import (
	"strings"
	"testing"
)

func TestRender(t *testing.T) {
	cases := []struct {
		name     string
		markdown string
		want     string
	}{
		{"heading", "# Title", "<h1>Title</h1>\n"},
		{"deeper heading", "### Third", "<h3>Third</h3>\n"},
		{"paragraph", "Hello there.", "<p>Hello there.</p>\n"},
		{"paragraph joins wrapped lines", "Hello\nthere.", "<p>Hello there.</p>\n"},
		{"rule", "---", "<hr>\n"},
		{"list", "- one\n- two", "<ul>\n<li>one</li>\n<li>two</li>\n</ul>\n"},
		{"bold", "a **b** c", "<p>a <strong>b</strong> c</p>\n"},
		{"italic", "_soon_", "<p><em>soon</em></p>\n"},
		{"mailto link", "[write](mailto:a@b.co)", `<p><a href="mailto:a@b.co">write</a></p>` + "\n"},
		{"https link", "[site](https://example.com)", `<p><a href="https://example.com">site</a></p>` + "\n"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			if got := Render(tc.markdown); got != tc.want {
				t.Fatalf("Render(%q) =\n%q\nwant\n%q", tc.markdown, got, tc.want)
			}
		})
	}
}

// The legal pages render text nobody reviews line by line, so markup must
// never survive from the document into the page.
func TestRenderEscapesContent(t *testing.T) {
	got := Render("<script>alert(1)</script>")
	want := "<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>\n"
	if got != want {
		t.Fatalf("Render() = %q, want %q", got, want)
	}
}

func TestRenderRejectsDangerousLinkSchemes(t *testing.T) {
	for _, markdown := range []string{
		"[click](javascript:alert)",
		"[click](data:text/html;base64,PHNjcmlwdD4=)",
		"[click](http://insecure.example)",
	} {
		got := Render(markdown)
		if strings.Contains(got, "<a ") {
			t.Fatalf("Render(%q) = %q, want no link", markdown, got)
		}
		if strings.Contains(got, "javascript:") || strings.Contains(got, "data:") {
			t.Fatalf("Render(%q) = %q, want the scheme dropped", markdown, got)
		}
	}
}

func TestPageIsSelfContained(t *testing.T) {
	page := Page("Privacy", "<h1>Privacy</h1>\n")
	for _, must := range []string{"<!DOCTYPE html>", "<title>Privacy</title>", "<h1>Privacy</h1>"} {
		if !strings.Contains(page, must) {
			t.Fatalf("Page() is missing %q", must)
		}
	}
	if strings.Contains(page, "http://") || strings.Contains(page, "src=") {
		t.Fatal("Page() must not reference external resources")
	}
}
