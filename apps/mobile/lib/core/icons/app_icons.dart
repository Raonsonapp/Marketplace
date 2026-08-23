import 'package:flutter/widgets.dart';

/// Outline-style icon set for TajikShop, matching the brand's "modern,
/// premium" look against the Deep Forest Green dark background — the same
/// visual family as the Lucide/Feather icon sets popular in the React
/// ecosystem, rather than filled Material icons.
///
/// The Lucide glyphs + font (ISC license, see
/// `assets/fonts/LUCIDE_LICENSE.txt`) are bundled directly as a local font
/// asset instead of depending on the `lucide_icons`/`flutter_feather_icons`
/// pub packages: both ship an `IconData` subclass, and current Flutter
/// marks [IconData] as a `final` class, so any such subclass fails to
/// compile on this SDK. Constructing [IconData] directly (never
/// subclassing it) sidesteps that while keeping the exact same glyphs,
/// fully offline (no CDN/network font fetch).
///
/// Named `LucideIcons` (matching the upstream package's API) so call sites
/// read `LucideIcons.home` etc. regardless of where the glyphs come from.
class LucideIcons {
  LucideIcons._();

  static const String _family = 'Lucide';

  static const IconData plus = IconData(0xf45e, fontFamily: _family);
  static const IconData minus = IconData(0xf3dc, fontFamily: _family);
  static const IconData mapPin = IconData(0xf3c0, fontFamily: _family);
  static const IconData imageOff = IconData(0xf367, fontFamily: _family);
  static const IconData image = IconData(0xf365, fontFamily: _family);
  static const IconData xCircle = IconData(0xf59f, fontFamily: _family);
  static const IconData gift = IconData(0xf32c, fontFamily: _family);
  static const IconData layoutGrid = IconData(0xf38a, fontFamily: _family);
  static const IconData checkCircle2 = IconData(0xf1f1, fontFamily: _family);
  static const IconData checkCircle = IconData(0xf1f0, fontFamily: _family);
  static const IconData chevronRight = IconData(0xf1fb, fontFamily: _family);
  static const IconData chevronLeft = IconData(0xf1f9, fontFamily: _family);
  static const IconData circle = IconData(0xf20b, fontFamily: _family);
  static const IconData trash2 = IconData(0xf546, fontFamily: _family);
  static const IconData bike = IconData(0xf1a2, fontFamily: _family);
  static const IconData edit3 = IconData(0xf292, fontFamily: _family);
  static const IconData zap = IconData(0xf5a3, fontFamily: _family);
  static const IconData alertCircle = IconData(0xf10b, fontFamily: _family);
  static const IconData heart = IconData(0xf354, fontFamily: _family);
  static const IconData history = IconData(0xf35d, fontFamily: _family);
  static const IconData inbox = IconData(0xf36a, fontFamily: _family);
  static const IconData globe = IconData(0xf33a, fontFamily: _family);
  static const IconData tag = IconData(0xf521, fontFamily: _family);
  static const IconData logOut = IconData(0xf3b0, fontFamily: _family);
  static const IconData creditCard = IconData(0xf264, fontFamily: _family);
  static const IconData user = IconData(0xf564, fontFamily: _family);
  static const IconData packageX = IconData(0xf41b, fontFamily: _family);
  static const IconData receipt = IconData(0xf477, fontFamily: _family);
  static const IconData refreshCw = IconData(0xf480, fontFamily: _family);
  static const IconData search = IconData(0xf4ad, fontFamily: _family);
  static const IconData searchX = IconData(0xf4b1, fontFamily: _family);
  static const IconData settings = IconData(0xf4b9, fontFamily: _family);
  static const IconData shoppingBag = IconData(0xf4c7, fontFamily: _family);
  static const IconData shoppingCart = IconData(0xf4c8, fontFamily: _family);
  static const IconData store = IconData(0xf509, fontFamily: _family);
  static const IconData shieldCheck = IconData(0xf4c1, fontFamily: _family);
  static const IconData wifiOff = IconData(0xf597, fontFamily: _family);

  // Added for the barcode scanner + delivery-tracking features.
  static const IconData scanLine = IconData(0xf4a4, fontFamily: _family);
  static const IconData camera = IconData(0xf1df, fontFamily: _family);
  static const IconData cameraOff = IconData(0xf1e0, fontFamily: _family);
  static const IconData truck = IconData(0xf54f, fontFamily: _family);
  static const IconData packageCheck = IconData(0xf416, fontFamily: _family);
  static const IconData package = IconData(0xf414, fontFamily: _family);
  static const IconData clock = IconData(0xf221, fontFamily: _family);
  static const IconData circleDot = IconData(0xf20e, fontFamily: _family);
  static const IconData banknote = IconData(0xf184, fontFamily: _family);
  static const IconData flashlight = IconData(0xf2ea, fontFamily: _family);
  static const IconData flashlightOff = IconData(0xf2eb, fontFamily: _family);
  static const IconData switchCamera = IconData(0xf518, fontFamily: _family);

  // Added for TajBonus/promotions/reviews/notifications/support.
  static const IconData star = IconData(0xf500, fontFamily: _family);
  static const IconData coins = IconData(0xf245, fontFamily: _family);
  static const IconData award = IconData(0xf172, fontFamily: _family);
  static const IconData badgePercent = IconData(0xf17e, fontFamily: _family);
  static const IconData bell = IconData(0xf19c, fontFamily: _family);
  static const IconData messageCircle = IconData(0xf3cd, fontFamily: _family);
  static const IconData send = IconData(0xf4b2, fontFamily: _family);
  static const IconData headphones = IconData(0xf353, fontFamily: _family);
}
