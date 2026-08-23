# TajikShop Branding Assets

## App icon

Source artwork (a green shopping basket with leaves, matching the brand's
Deep Forest Green / Emerald Green palette from `docs/ARCHITECTURE.md`) was
supplied by the user, then background-removed and tightly cropped:

- `apps/mobile/assets/branding/app_icon.png` — transparent background,
  square, tightly cropped to the artwork. Use this as the source for
  Android adaptive-icon foregrounds and any place a transparent mark is
  needed.
- `apps/mobile/assets/branding/app_icon_foreground.png` — the same artwork
  padded to the standard Android adaptive-icon safe-zone ratio (content
  within the inner ~72% of the canvas), for `flutter_launcher_icons`'
  `adaptive_icon_foreground`.
- `apps/mobile/assets/branding/app_icon_flattened.png` — the artwork
  composited onto the brand's Deep Forest Green (`#010B06`) background,
  opaque. Use this as the plain (non-adaptive) app icon and as the
  adaptive-icon background pairing (`adaptive_icon_background: "#010B06"`).

## Wiring it up

Add `flutter_launcher_icons` as a dev dependency and configure it against
these files, e.g.:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/branding/app_icon_flattened.png"
  adaptive_icon_background: "#010B06"
  adaptive_icon_foreground: "assets/branding/app_icon_foreground.png"
  remove_alpha_ios: true
```

Then run `dart run flutter_launcher_icons` to regenerate every
`mipmap-*`/`AppIcon.appiconset` resolution. Re-run it any time the source
artwork changes; never hand-edit the generated resolutions.

## Splash screen

Reuse `app_icon.png` (transparent) centered on the Deep Forest Green
background for the native splash screen (`flutter_native_splash` or the
existing custom splash screen widget) so the launch icon and the first
frame the user sees match exactly.
