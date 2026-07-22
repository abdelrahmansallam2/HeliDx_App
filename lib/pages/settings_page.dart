import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  String get _currentLanguageCode =>
      appLocale.value?.languageCode ??
      Localizations.localeOf(context).languageCode;

  String _languageDisplayName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  Future<void> _setLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    appLocale.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(l10n),
                  const SizedBox(height: 28),
                  _buildSectionTitle(l10n.general),
                  const SizedBox(height: 12),
                  _buildLanguageTile(l10n),
                  const SizedBox(height: 8),
                  _buildToggleTile(
                    icon: Icons.volume_up_rounded,
                    title: l10n.sound,
                    subtitle: l10n.playSounds,
                    value: _soundEnabled,
                    onChanged: (v) => setState(() => _soundEnabled = v),
                  ),
                  const SizedBox(height: 8),
                  _buildToggleTile(
                    icon: Icons.vibration_rounded,
                    title: l10n.vibration,
                    subtitle: l10n.vibrateOnAlerts,
                    value: _vibrationEnabled,
                    onChanged: (v) => setState(() => _vibrationEnabled = v),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l10n.usage),
                  const SizedBox(height: 12),
                  _buildNavigationTile(
                    icon: Icons.photo_camera_rounded,
                    title: l10n.cameraInstructions,
                    subtitle: l10n.tipsForCapturing,
                    onTap: () => _showCameraInstructions(context, l10n),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l10n.about),
                  const SizedBox(height: 12),
                  _buildNavigationTile(
                    icon: Icons.info_outline_rounded,
                    title: l10n.aboutHeliDx,
                    subtitle: l10n.learnMore,
                    onTap: () => _showAboutDialog(context, l10n),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoTile(
                    icon: Icons.tag_rounded,
                    title: l10n.appVersion,
                    trailing: '1.0.0',
                  ),
                  const SizedBox(height: 8),
                  _buildNavigationTile(
                    icon: Icons.medical_services_outlined,
                    title: l10n.medicalDisclaimer,
                    subtitle: l10n.importantInfo,
                    onTap: () => _showMedicalDisclaimer(context, l10n),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    l10n.disclaimer,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textBody,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textWhite,
            size: 26,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            l10n.settings,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppColors.accentSoft,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLanguageTile(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.language_rounded,
              color: AppColors.accentGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.language,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.chooseLanguage,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          DropdownButton<String>(
            value: _currentLanguageCode,
            dropdownColor: AppColors.settingsTile,
            underline: const SizedBox.shrink(),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.settingsTrailing,
            ),
            style: const TextStyle(
              color: AppColors.accentGreen,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(_languageDisplayName('en')),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text(_languageDisplayName('ar')),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                _setLanguage(value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.accentGreen,
            activeTrackColor: AppColors.accentGreen.withValues(alpha: 0.25),
            inactiveTrackColor: AppColors.buttonDisabledBg,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.accentGreen, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentGreen, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.settingsCard.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppColors.accentGreen.withValues(alpha: 0.18),
      ),
    );
  }

  void _showCameraInstructions(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => _styledDialog(
        context: context,
        title: l10n.cameraInstructionsTitle,
        body: l10n.cameraInstructionsBody,
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => _styledDialog(
        context: context,
        title: l10n.aboutHeliDxTitle,
        body: l10n.aboutHeliDxBody,
      ),
    );
  }

  void _showMedicalDisclaimer(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => _styledDialog(
        context: context,
        title: l10n.medicalDisclaimerTitle,
        body: l10n.medicalDisclaimerBody,
      ),
    );
  }

  Widget _styledDialog({
    required BuildContext context,
    required String title,
    required String body,
  }) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.settingsCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: AppColors.accentGreen.withValues(alpha: 0.25)),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        body,
        style: const TextStyle(
          color: AppColors.textBody,
          fontSize: 14,
          height: 1.55,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.gotIt,
            style: const TextStyle(
              color: AppColors.accentGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientMid,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: const Stack(
          children: [
            Positioned(
              top: -90,
              right: -60,
              child: _Glow(size: 240),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: _Glow(size: 270),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.glow.withValues(alpha: 0.08),
        boxShadow: [
          BoxShadow(
            color: AppColors.glow.withValues(alpha: 0.10),
            blurRadius: 70,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
