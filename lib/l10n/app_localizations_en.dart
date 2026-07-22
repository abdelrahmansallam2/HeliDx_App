// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HeliDx';

  @override
  String get tagline => 'Detect. Understand. Take Action.';

  @override
  String get cameraGalleryError => 'Could not open the camera or gallery.';

  @override
  String get checkSample => 'Check a sample';

  @override
  String get capturePhotoHint =>
      'Capture a clear photo inside the frame, then start the comparison.';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get analyzingSample => 'Analyzing sample...';

  @override
  String get analyzeSample => 'Analyze sample';

  @override
  String get scanAnotherSample => 'Scan another sample';

  @override
  String get disclaimer =>
      'HeliDx compares the captured sample with verified reference images. Final medical decisions should be reviewed by a qualified specialist.';

  @override
  String get settings => 'Settings';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose the app language';

  @override
  String get sound => 'Sound';

  @override
  String get playSounds => 'Play sounds during analysis';

  @override
  String get vibration => 'Vibration';

  @override
  String get vibrateOnAlerts => 'Vibrate on alerts and results';

  @override
  String get usage => 'Usage';

  @override
  String get cameraInstructions => 'Camera instructions';

  @override
  String get tipsForCapturing => 'Tips for capturing clear samples';

  @override
  String get about => 'About';

  @override
  String get aboutHeliDx => 'About HeliDx';

  @override
  String get learnMore => 'Learn more about the app';

  @override
  String get appVersion => 'App version';

  @override
  String get medicalDisclaimer => 'Medical disclaimer';

  @override
  String get importantInfo => 'Important information';

  @override
  String get gotIt => 'Got it';

  @override
  String get cameraInstructionsTitle => 'Camera Instructions';

  @override
  String get cameraInstructionsBody =>
      '• Hold the device steady and parallel to the sample.\n• Use even lighting — avoid harsh shadows.\n• Place the sample on a plain, contrasting background.\n• Keep the entire sample inside the frame.\n• Avoid reflections on the sample surface.';

  @override
  String get aboutHeliDxTitle => 'About HeliDx';

  @override
  String get aboutHeliDxBody =>
      'HeliDx is a portable screening tool that compares captured specimen images against a verified reference database.\n\nThe app is designed to support — not replace — professional medical evaluation.';

  @override
  String get medicalDisclaimerTitle => 'Medical Disclaimer';

  @override
  String get medicalDisclaimerBody =>
      'HeliDx is intended for informational and screening purposes only. It does not provide a medical diagnosis.\n\nAlways consult a qualified healthcare professional for medical decisions. Do not rely solely on the results of this application.';

  @override
  String get comparingSamples => 'Comparing with reference samples';

  @override
  String get placeSampleInFrame => 'Place the sample inside the frame';

  @override
  String get clearBackgroundHint =>
      'Use a clear background and steady lighting for the best match.';

  @override
  String get comparisonResult => 'Comparison result';

  @override
  String get positive => 'POSITIVE';

  @override
  String get negative => 'NEGATIVE';

  @override
  String get capture => 'Capture';

  @override
  String get retake => 'Retake';

  @override
  String get cameraPermissionDenied =>
      'Camera permission denied. Please enable it in settings.';

  @override
  String get cameraUnavailable => 'Camera unavailable.';

  @override
  String get initializingCamera => 'Initializing camera...';

  @override
  String get holdSteady => 'Hold the phone steady';
}
