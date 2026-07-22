import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/analysis_result.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: const Color(0xFF8AF0D1).withOpacity(0.35),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/helidx_logo.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HeliDx',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Detect. Understand. Take Action.',
                style: TextStyle(
                  color: Color(0xFF83E4C7),
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
    super.key,
  });

  final XFile? selectedImage;
  final bool isAnalyzing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      decoration: BoxDecoration(
        color: const Color(0xFF052F36),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selectedImage == null
              ? const Color(0xFF6BA7A9)
              : const Color(0xFF61E5BC),
          width: 1.3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (selectedImage != null)
            Image.file(
              File(selectedImage!.path),
              fit: BoxFit.cover,
            )
          else
            const _EmptyPreview(),

          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: CustomPaint(
                painter: _CornerFramePainter(),
              ),
            ),
          ),

          if (isAnalyzing)
            Container(
              color: const Color(0xFF042D33).withOpacity(0.78),
              alignment: Alignment.center,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF65E8C0),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Comparing with reference samples',
                    style: TextStyle(
                      color: Colors.white,
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

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.center_focus_strong_rounded,
              color: Color(0xFF68E8C0),
              size: 52,
            ),
            SizedBox(height: 14),
            Text(
              'Place the sample inside the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Use a clear background and steady lighting for the best match.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFADC9CB),
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
        icon: Icon(
          icon,
          size: 20,
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFDCF5F0),
          side: BorderSide(
            color: const Color(0xFF93D9CC).withOpacity(0.45),
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
  const ResultCard({
    required this.result,
    super.key,
  });

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    final bool isPositive = result == AnalysisResult.positive;

    final Color accent = isPositive
        ? const Color(0xFFFFC75F)
        : const Color(0xFF65E8C0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.11),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withOpacity(0.55),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPositive
                  ? Icons.warning_amber_rounded
                  : Icons.check_circle_outline_rounded,
              color: accent,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comparison result',
                  style: TextStyle(
                    color: Color(0xFFBFD4D5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isPositive ? 'POSITIVE' : 'NEGATIVE',
                  style: TextStyle(
                    color: accent,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFF9BBBBC),
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
              Color(0xFF032E36),
              Color(0xFF07545A),
              Color(0xFF043239),
            ],
          ),
        ),
        child: const Stack(
          children: [
            Positioned(
              top: -90,
              right: -60,
              child: _GlowCircle(size: 240),
            ),
            Positioned(
              bottom: -120,
              left: -80,
              child: _GlowCircle(size: 270),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF55DDB5).withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF55DDB5).withOpacity(0.10),
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
      ..color = const Color(0xFF76ECC8)
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
    path.quadraticBezierTo(
      size.width,
      0,
      size.width,
      radius,
    );
    path.lineTo(size.width, cornerLength);

    // Bottom-right corner
    path.moveTo(
      size.width,
      size.height - cornerLength,
    );
    path.lineTo(
      size.width,
      size.height - radius,
    );
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - radius,
      size.height,
    );
    path.lineTo(
      size.width - cornerLength,
      size.height,
    );

    // Bottom-left corner
    path.moveTo(
      cornerLength,
      size.height,
    );
    path.lineTo(
      radius,
      size.height,
    );
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - radius,
    );
    path.lineTo(
      0,
      size.height - cornerLength,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}