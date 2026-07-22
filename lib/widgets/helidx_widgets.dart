import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_result.dart';

enum CameraViewMode {
  empty,
  livePreview,
  captured,
  analyzing,
  initializing,
  error,
}

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(
              color: AppColors.accentTeal.withValues(alpha: 0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/helidx_logo.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.tagline,
                style: const TextStyle(
                  color: AppColors.accentSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SamplePreview extends StatelessWidget {
  const SamplePreview({
    required this.selectedImage,
    required this.isAnalyzing,
    required this.viewMode,
    required this.cameraController,
    required this.errorMessage,
    super.key,
  });

  final XFile? selectedImage;
  final bool isAnalyzing;
  final CameraViewMode viewMode;
  final CameraController? cameraController;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 275,
      decoration: BoxDecoration(
        color: AppColors.scaffold,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: viewMode == CameraViewMode.livePreview
              ? AppColors.accentTeal
              : selectedImage == null
              ? AppColors.previewBorderIdle
              : AppColors.previewBorderActive,
          width: 1.3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (viewMode == CameraViewMode.livePreview &&
              cameraController != null &&
              cameraController!.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: cameraController!.value.previewSize!.height,
                height: cameraController!.value.previewSize!.width,
                child: CameraPreview(cameraController!),
              ),
            )
          else if (viewMode == CameraViewMode.captured && selectedImage != null)
            Image.file(File(selectedImage!.path), fit: BoxFit.cover)
          else if (viewMode == CameraViewMode.error)
            _CameraError(message: errorMessage ?? l10n.cameraUnavailable)
          else if (viewMode == CameraViewMode.initializing)
            const _CameraLoading()
          else
            const _EmptyPreview(),

          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: CustomPaint(painter: _CornerFramePainter()),
            ),
          ),

          if (viewMode == CameraViewMode.livePreview &&
              cameraController != null &&
              cameraController!.value.isInitialized)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.holdSteady,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

          if (isAnalyzing)
            Container(
              color: AppColors.analyzingOverlay.withValues(alpha: 0.78),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppColors.accentLight),
                  const SizedBox(height: 14),
                  Text(
                    l10n.comparingSamples,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.videocam_off_rounded,
              color: AppColors.resultPositive,
              size: 48,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CameraLoading extends StatelessWidget {
  const _CameraLoading();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.accentLight),
          const SizedBox(height: 14),
          Text(
            l10n.initializingCamera,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.center_focus_strong_rounded,
              color: AppColors.accentLight,
              size: 52,
            ),
            const SizedBox(height: 14),
            Text(
              l10n.placeSampleInFrame,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              l10n.clearBackgroundHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.buttonSecondaryFg,
          side: BorderSide(
            color: AppColors.buttonSecondaryBorder.withValues(alpha: 0.45),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({required this.result, super.key});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final Color accent;
    final IconData icon;

    switch (result) {
      case AnalysisResult.positive:
        accent = AppColors.resultPositive;
        icon = Icons.warning_amber_rounded;
        break;
      case AnalysisResult.negative:
        accent = AppColors.resultNegative;
        icon = Icons.check_circle_outline_rounded;
        break;
      case AnalysisResult.unknown:
        accent = AppColors.resultUnknown;
        icon = Icons.help_outline_rounded;
        break;
    }

    final String resultLabel;
    switch (result) {
      case AnalysisResult.positive:
        resultLabel = l10n.positive;
        break;
      case AnalysisResult.negative:
        resultLabel = l10n.negative;
        break;
      case AnalysisResult.unknown:
        resultLabel = l10n.inconclusiveResult;
        break;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accent, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.comparisonResult,
                  style: const TextStyle(
                    color: AppColors.textLabel,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  resultLabel,
                  style: TextStyle(
                    color: accent,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
                if (result == AnalysisResult.unknown) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.resultCouldNotBeDetermined,
                    style: const TextStyle(
                      color: AppColors.textBody,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textTertiary,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class BackgroundDecoration extends StatelessWidget {
  const BackgroundDecoration({super.key});

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
            Positioned(top: -90, right: -60, child: _GlowCircle(size: 240)),
            Positioned(bottom: -120, left: -80, child: _GlowCircle(size: 270)),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size});

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

class _CornerFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerLength = 32;
    const double radius = 10;

    final paint = Paint()
      ..color = AppColors.accentMint
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Top-left corner
    path.moveTo(0, cornerLength);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(cornerLength, 0);

    // Top-right corner
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, cornerLength);

    // Bottom-right corner
    path.moveTo(size.width, size.height - cornerLength);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(size.width - cornerLength, size.height);

    // Bottom-left corner
    path.moveTo(cornerLength, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, size.height - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
