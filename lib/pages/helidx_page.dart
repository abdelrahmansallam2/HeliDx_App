import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/analysis_result.dart';
import '../services/camera_service.dart';
import '../widgets/helidx_widgets.dart';
import 'settings_page.dart';

class HeliDxPage extends StatefulWidget {
  const HeliDxPage({super.key});

  @override
  State<HeliDxPage> createState() => _HeliDxPageState();
}

class _HeliDxPageState extends State<HeliDxPage> with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();
  final CameraService _cameraService = CameraService();

  XFile? _selectedImage;
  bool _isAnalyzing = false;
  AnalysisResult? _result;
  CameraViewMode _viewMode = CameraViewMode.empty;
  String? _cameraError;

  double? _frameWidth;
  double? _frameHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_viewMode == CameraViewMode.livePreview) {
        _initializeCamera();
      }
    }
  }

  Future<void> _initializeCamera() async {
    if (!mounted) return;

    setState(() {
      _viewMode = CameraViewMode.initializing;
      _cameraError = null;
    });

    try {
      await _cameraService.initialize();
      if (!mounted) return;
      setState(() {
        _viewMode = CameraViewMode.livePreview;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final String message;
      switch (e.description) {
        case 'CameraAccessDenied':
        case 'CameraAccessDeniedWithoutPrompt':
        case 'CameraAccessRestricted':
          message = l10n.cameraPermissionDenied;
          break;
        default:
          message = l10n.cameraUnavailable;
      }
      setState(() {
        _cameraError = message;
        _viewMode = CameraViewMode.error;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cameraError = AppLocalizations.of(context)!.cameraUnavailable;
        _viewMode = CameraViewMode.error;
      });
    }
  }

  Future<void> _capturePicture() async {
    if (_cameraService.isCapturing) return;

    final w = _frameWidth;
    final h = _frameHeight;
    if (w == null || h == null) return;

    try {
      final file = await _cameraService.takePicture(
        frameWidth: w,
        frameHeight: h,
      );

      await _cameraService.dispose();

      if (!mounted) return;
      setState(() {
        _selectedImage = XFile(file.path);
        _viewMode = CameraViewMode.captured;
        _result = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.description ?? '')));
    }
  }

  Future<void> _retakePicture() async {
    setState(() {
      _selectedImage = null;
      _result = null;
      _viewMode = CameraViewMode.empty;
    });
    await _initializeCamera();
  }

  Future<void> _onCameraButtonPressed() async {
    if (_viewMode == CameraViewMode.livePreview) {
      await _capturePicture();
    } else {
      await _initializeCamera();
    }
  }

  Future<void> _onGalleryPressed() async {
    if (_viewMode == CameraViewMode.livePreview) {
      await _cameraService.dispose();
      setState(() {
        _viewMode = CameraViewMode.empty;
      });
    }

    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
        maxWidth: 1600,
      );

      if (image == null || !mounted) return;

      final w = _frameWidth;
      final h = _frameHeight;

      if (w != null && h != null) {
        final processed = await CameraService.processGalleryImage(
          image.path,
          frameWidth: w,
          frameHeight: h,
        );
        setState(() {
          _selectedImage = XFile(processed.path);
          _viewMode = CameraViewMode.captured;
          _result = null;
        });
      } else {
        setState(() {
          _selectedImage = image;
          _viewMode = CameraViewMode.captured;
          _result = null;
        });
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraGalleryError),
        ),
      );
    }
  }

  Future<void> _analyzeSample() async {
    if (_selectedImage == null || _isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isAnalyzing = false;
      _result = AnalysisResult.positive;
    });
  }

  void _reset() {
    _cameraService.dispose();
    setState(() {
      _selectedImage = null;
      _result = null;
      _isAnalyzing = false;
      _viewMode = CameraViewMode.empty;
      _cameraError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final bool isLiveCamera = _viewMode == CameraViewMode.livePreview;
    final bool canInteract = !_isAnalyzing;

    final String cameraLabel;
    final VoidCallback? cameraCallback;
    if (isLiveCamera) {
      cameraLabel = l10n.capture;
      cameraCallback = canInteract ? _onCameraButtonPressed : null;
    } else if (_viewMode == CameraViewMode.initializing) {
      cameraLabel = l10n.initializingCamera;
      cameraCallback = null;
    } else {
      cameraLabel = l10n.camera;
      cameraCallback = canInteract ? _onCameraButtonPressed : null;
    }

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
                  _buildMainCard(l10n, cameraLabel, cameraCallback),
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
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

  Widget _buildMainCard(
    AppLocalizations l10n,
    String cameraLabel,
    VoidCallback? cameraCallback,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.22)),
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

          LayoutBuilder(
            builder: (context, constraints) {
              _frameWidth = constraints.maxWidth;
              _frameHeight = 275;
              return SamplePreview(
                selectedImage: _selectedImage,
                isAnalyzing: _isAnalyzing,
                viewMode: _viewMode,
                cameraController: _cameraService.controller,
                errorMessage: _cameraError,
              );
            },
          ),

          const SizedBox(height: 16),

          if (_viewMode == CameraViewMode.captured && _selectedImage != null)
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    icon: Icons.replay_rounded,
                    label: l10n.retake,
                    onPressed: _isAnalyzing ? null : _retakePicture,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    icon: Icons.photo_library_rounded,
                    label: l10n.gallery,
                    onPressed: _isAnalyzing ? null : _onGalleryPressed,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    icon: _viewMode == CameraViewMode.livePreview
                        ? Icons.camera_rounded
                        : Icons.photo_camera_rounded,
                    label: cameraLabel,
                    onPressed: cameraCallback,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    icon: Icons.photo_library_rounded,
                    label: l10n.gallery,
                    onPressed: _isAnalyzing ? null : _onGalleryPressed,
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
                _isAnalyzing ? l10n.analyzingSample : l10n.analyzeSample,
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
