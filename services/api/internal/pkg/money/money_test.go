package money

import "testing"

func TestFromString(t *testing.T) {
	cases := []struct {
		in      string
		want    Money
		wantErr bool
	}{
		{"125.50", 12550, false},
		{"125.5", 12550, false},
		{"125", 12500, false},
		{"0", 0, false},
		{"", 0, false},
		{"-4.20", -420, false},
		{"0.01", 1, false},
		{"12.345", 0, true},
		{"abc", 0, true},
		{"1.2.3", 0, true},
	}
	for _, c := range cases {
		got, err := FromString(c.in)
		if c.wantErr {
			if err == nil {
				t.Errorf("FromString(%q): expected error, got %v", c.in, got)
			}
			continue
		}
		if err != nil {
			t.Errorf("FromString(%q): unexpected error %v", c.in, err)
			continue
		}
		if got != c.want {
			t.Errorf("FromString(%q) = %v, want %v", c.in, got, c.want)
		}
	}
}

func TestString(t *testing.T) {
	cases := []struct {
		in   Money
		want string
	}{
		{12550, "125.50"},
		{0, "0.00"},
		{-420, "-4.20"},
		{1, "0.01"},
		{100, "1.00"},
	}
	for _, c := range cases {
		if got := c.in.String(); got != c.want {
			t.Errorf("Money(%d).String() = %q, want %q", c.in, got, c.want)
		}
	}
}

func TestRoundTrip(t *testing.T) {
	inputs := []string{"0.00", "125.50", "9999999.99", "0.05"}
	for _, in := range inputs {
		m, err := FromString(in)
		if err != nil {
			t.Fatalf("FromString(%q): %v", in, err)
		}
		if got := m.String(); got != in {
			t.Errorf("round trip %q -> %q", in, got)
		}
	}
}

func TestArithmetic(t *testing.T) {
	a := MustFromString("100.00")
	b := MustFromString("30.00")
	if got := a.Sub(b); got.String() != "70.00" {
		t.Errorf("Sub: got %s want 70.00", got)
	}
	if got := a.MulInt(3); got.String() != "300.00" {
		t.Errorf("MulInt: got %s want 300.00", got)
	}
	if got := a.PercentOf(10); got.String() != "10.00" {
		t.Errorf("PercentOf: got %s want 10.00", got)
	}
	if got := MustFromString("-5.00").ClampNonNegative(); got != 0 {
		t.Errorf("ClampNonNegative: got %s want 0.00", got)
	}
}

func TestJSON(t *testing.T) {
	m := MustFromString("125.50")
	b, err := m.MarshalJSON()
	if err != nil {
		t.Fatal(err)
	}
	if string(b) != `"125.50"` {
		t.Errorf("MarshalJSON = %s, want \"125.50\"", b)
	}
	var m2 Money
	if err := m2.UnmarshalJSON(b); err != nil {
		t.Fatal(err)
	}
	if m2 != m {
		t.Errorf("UnmarshalJSON round trip: got %v want %v", m2, m)
	}
}
