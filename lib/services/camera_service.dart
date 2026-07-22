import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCapturing = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isCapturing => _isCapturing;

  Future<void> initialize() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) {
      throw CameraException('noCamera', 'No cameras available');
    }

    final backCamera = _cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  Future<File> takePicture({
    required double frameWidth,
    required double frameHeight,
  }) async {
    if (_controller == null || !isInitialized) {
      throw CameraException('notInitialized', 'Camera not initialized');
    }
    if (_isCapturing) {
      throw CameraException('alreadyCapturing', 'Capture already in progress');
    }

    _isCapturing = true;
    try {
      final xFile = await _controller!.takePicture();
      final rawFile = File(xFile.path);

      final corrected = await _correctOrientation(rawFile);
      final cropped = await _cropToAspectRatio(
        corrected,
        frameWidth / frameHeight,
      );

      if (cropped.path != rawFile.path) {
        await rawFile.delete();
      }
      if (corrected.path != rawFile.path && corrected.path != cropped.path) {
        await corrected.delete();
      }

      return cropped;
    } finally {
      _isCapturing = false;
    }
  }

  Future<void> dispose() async {
    final ctrl = _controller;
    _controller = null;
    if (ctrl != null) {
      await ctrl.dispose();
    }
  }

  Future<File> _correctOrientation(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final oriented = img.bakeOrientation(image);
    if (oriented.width == image.width && oriented.height == image.height) {
      return file;
    }

    final tempDir = await getTemporaryDirectory();
    final outPath =
        '${tempDir.path}/oriented_${DateTime.now().millisecondsSinceEpoch}.png';
    final outBytes = img.encodePng(oriented);
    return File(outPath)..writeAsBytesSync(outBytes);
  }

  Future<File> _cropToAspectRatio(File file, double targetRatio) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final currentRatio = image.width / image.height;
    int cropX, cropY, cropW, cropH;

    if (currentRatio > targetRatio) {
      cropH = image.height;
      cropW = (cropH * targetRatio).round();
      cropX = (image.width - cropW) ~/ 2;
      cropY = 0;
    } else {
      cropW = image.width;
      cropH = (cropW / targetRatio).round();
      cropX = 0;
      cropY = (image.height - cropH) ~/ 2;
    }

    cropX = max(0, cropX);
    cropY = max(0, cropY);
    cropW = min(cropW, image.width - cropX);
    cropH = min(cropH, image.height - cropY);

    if (cropW == image.width && cropH == image.height) {
      return file;
    }

    final cropped = img.copyCrop(
      image,
      x: cropX,
      y: cropY,
      width: cropW,
      height: cropH,
    );

    final tempDir = await getTemporaryDirectory();
    final outPath =
        '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png';
    final outBytes = img.encodePng(cropped);
    return File(outPath)..writeAsBytesSync(outBytes);
  }

  static Future<File> processGalleryImage(
    String path, {
    required double frameWidth,
    required double frameHeight,
  }) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final oriented = img.bakeOrientation(image);

    final targetRatio = frameWidth / frameHeight;
    final currentRatio = oriented.width / oriented.height;
    int cropX, cropY, cropW, cropH;

    if (currentRatio > targetRatio) {
      cropH = oriented.height;
      cropW = (cropH * targetRatio).round();
      cropX = (oriented.width - cropW) ~/ 2;
      cropY = 0;
    } else {
      cropW = oriented.width;
      cropH = (cropW / targetRatio).round();
      cropX = 0;
      cropY = (oriented.height - cropH) ~/ 2;
    }

    cropX = max(0, cropX);
    cropY = max(0, cropY);
    cropW = min(cropW, oriented.width - cropX);
    cropH = min(cropH, oriented.height - cropY);

    final cropped = img.copyCrop(
      oriented,
      x: cropX,
      y: cropY,
      width: cropW,
      height: cropH,
    );

    final tempDir = await getTemporaryDirectory();
    final outPath =
        '${tempDir.path}/gallery_${DateTime.now().millisecondsSinceEpoch}.png';
    final outBytes = img.encodePng(cropped);
    return File(outPath)..writeAsBytesSync(outBytes);
  }
}
