import 'package:flutter/material.dart';

abstract final class AppColors {
  // ── Background & Scaffold ──
  static const Color scaffold = Color(0xFF052F36);

  // ── Gradient ──
  static const Color gradientStart = Color(0xFF032E36);
  static const Color gradientMid = Color(0xFF07545A);
  static const Color gradientEnd = Color(0xFF043239);

  // ── Glow circles ──
  static const Color glow = Color(0xFF55DDB5);

  // ── Cards ──
  static const Color cardBackground = Color(0xFF0A4148);
  static const Color cardBorder = Color(0xFF9AF3D7);

  // ── Primary / Accent ──
  static const Color primary = Color(0xFF58E2B8);
  static const Color accentGreen = Color(0xFF59E4B8);
  static const Color accentLight = Color(0xFF65E8C0);
  static const Color accentMint = Color(0xFF76ECC8);
  static const Color accentTeal = Color(0xFF8AF0D1);
  static const Color accentSoft = Color(0xFF83E4C7);

  // ── Text ──
  static const Color textWhite = Colors.white;
  static const Color textSubtitle = Color(0xFFC5DCDD);
  static const Color textBody = Color(0xFFB7D1D3);
  static const Color textMuted = Color(0xFFADC9CB);
  static const Color textLabel = Color(0xFFBFD4D5);
  static const Color textTertiary = Color(0xFF9BBBBC);

  // ── Buttons ──
  static const Color buttonFilledFg = Color(0xFF07383E);
  static const Color buttonDisabledBg = Color(0xFF315A5D);
  static const Color buttonDisabledFg = Color(0xFF83A1A3);
  static const Color buttonSecondaryFg = Color(0xFFDCF5F0);
  static const Color buttonSecondaryBorder = Color(0xFF93D9CC);
  static const Color textButtonFg = Color(0xFFC9E8E5);

  // ── Preview ──
  static const Color previewBorderIdle = Color(0xFF6BA7A9);
  static const Color previewBorderActive = Color(0xFF61E5BC);
  static const Color analyzingOverlay = Color(0xFF042D33);

  // ── Result Card ──
  static const Color resultPositive = Color(0xFFFFC75F);
  static const Color resultNegative = Color(0xFF65E8C0);
  static const Color resultUnknown = Color(0xFFFFB74D);

  // ── Settings ──
  static const Color settingsCard = Color(0xFF0A4148);
  static const Color settingsDivider = Color(0xFF1A5A62);
  static const Color settingsTile = Color(0xFF07353B);
  static const Color settingsTrailing = Color(0xFF83E4C7);

  // ── Splash ──
  static const Color splashText = Colors.white;
  static const Color splashTagline = Color(0xFF83E4C7);
  static const Color splashLoader = Color(0xFF59E4B8);

  // ── Seed ──
  static const Color seed = Color(0xFF58E2B8);
}
