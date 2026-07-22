import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_result.dart';
import '../widgets/helidx_widgets.dart';
import 'settings_page.dart';

class HeliDxPage extends StatefulWidget {
  const HeliDxPage({super.key});

  @override
  State<HeliDxPage> createState() => _HeliDxPageState();
}

class _HeliDxPageState extends State<HeliDxPage> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  AnalysisResult? _result;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 1600,
      );

      if (image == null || !mounted) {
        return;
      }

      setState(() {
        _selectedImage = image;
        _result = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraGalleryError),
        ),
      );
    }
  }

  Future<void> _analyzeSample() async {
    if (_selectedImage == null || _isAnalyzing) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    // TODO:
    // Replace this temporary code with the real image comparison.
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }

    setState(() {
      _isAnalyzing = false;

      // Temporary result for testing the UI.
      _result = AnalysisResult.positive;
    });
  }

  void _reset() {
    setState(() {
      _selectedImage = null;
      _result = null;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundDecoration(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 12),
                  _buildMainCard(l10n),
                  const SizedBox(height: 16),
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

  Widget _buildTopBar() {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.accentGreen.withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: AppColors.accentGreen,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.checkSample,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.capturePhotoHint,
            style: const TextStyle(
              color: AppColors.textSubtitle,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          SamplePreview(
            selectedImage: _selectedImage,
            isAnalyzing: _isAnalyzing,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  icon: Icons.photo_camera_rounded,
                  label: l10n.camera,
                  onPressed: _isAnalyzing
                      ? null
                      : () => _pickImage(ImageSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  icon: Icons.photo_library_rounded,
                  label: l10n.gallery,
                  onPressed: _isAnalyzing
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: _selectedImage == null || _isAnalyzing
                  ? null
                  : _analyzeSample,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: AppColors.buttonFilledFg,
                disabledBackgroundColor: AppColors.buttonDisabledBg,
                disabledForegroundColor: AppColors.buttonDisabledFg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 21,
                      height: 21,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.buttonFilledFg,
                      ),
                    )
                  : const Icon(Icons.biotech_rounded),
              label: Text(
                _isAnalyzing
                    ? l10n.analyzingSample
                    : l10n.analyzeSample,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          if (_result != null) ...[
            const SizedBox(height: 18),
            ResultCard(result: _result!),
          ],

          if (_selectedImage != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _isAnalyzing ? null : _reset,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.scanAnotherSample),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textButtonFg,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
