import 'package:flutter/material.dart';

/// Brand color palette for YouShop.
///
/// Deep Forest Green is the primary dark-theme background, Emerald Green is
/// the primary accent, and a Neon Green tone is reserved for special
/// highlights (badges, promo ribbons). No orange is used anywhere in the
/// palette per the brand guidelines.
class AppColors {
  AppColors._();

  // Brand core
  static const Color deepForestGreen = Color(0xFF010B06);
  static const Color emeraldGreen = Color(0xFF2ECC71);
  static const Color neonGreenHighlight = Color(0xFF39FF88);

  // Dark theme surfaces (derived from the deep forest green base)
  static const Color darkBackground = deepForestGreen;
  static const Color darkSurface = Color(0xFF0B1D14);
  static const Color darkSurfaceElevated = Color(0xFF122A1E);
  static const Color darkSurfaceHigh = Color(0xFF173625);
  static const Color darkCard = Color(0xFF102019);
  static const Color darkBorder = Color(0xFF1E3A2B);

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF5FAF6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFDCEAE0);

  // Typography
  static const Color textOnDarkPrimary = Color(0xFFF4FBF6);
  static const Color textOnDarkSecondary = Color(0xFFAFC8BA);
  static const Color textOnDarkMuted = Color(0xFF7C9686);

  static const Color textOnLightPrimary = Color(0xFF0B1D14);
  static const Color textOnLightSecondary = Color(0xFF4A5F52);
  static const Color textOnLightMuted = Color(0xFF7C9686);

  // Semantic
  static const Color success = emeraldGreen;
  static const Color error = Color(0xFFE5484D);
  static const Color warning = Color(0xFFE5C94D);
  static const Color info = Color(0xFF4DA6E5);

  // Discount / price
  static const Color priceOld = Color(0xFF8A9C92);
  static const Color discountBadgeBackground = Color(0xFF163B27);
  static const Color discountBadgeText = neonGreenHighlight;

  /// Gradient used for hero banners / primary CTA surfaces.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06170F), emeraldGreen],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF010B06), Color(0xFF0A1B12)],
  );
}
