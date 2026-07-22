import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HeliDx'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Detect. Understand. Take Action.'**
  String get tagline;

  /// No description provided for @cameraGalleryError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the camera or gallery.'**
  String get cameraGalleryError;

  /// No description provided for @checkSample.
  ///
  /// In en, this message translates to:
  /// **'Check a sample'**
  String get checkSample;

  /// No description provided for @capturePhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Capture a clear photo inside the frame, then start the comparison.'**
  String get capturePhotoHint;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @analyzingSample.
  ///
  /// In en, this message translates to:
  /// **'Analyzing sample...'**
  String get analyzingSample;

  /// No description provided for @analyzeSample.
  ///
  /// In en, this message translates to:
  /// **'Analyze sample'**
  String get analyzeSample;

  /// No description provided for @scanAnotherSample.
  ///
  /// In en, this message translates to:
  /// **'Scan another sample'**
  String get scanAnotherSample;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'HeliDx compares the captured sample with verified reference images. Final medical decisions should be reviewed by a qualified specialist.'**
  String get disclaimer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get chooseLanguage;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @playSounds.
  ///
  /// In en, this message translates to:
  /// **'Play sounds during analysis'**
  String get playSounds;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @vibrateOnAlerts.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on alerts and results'**
  String get vibrateOnAlerts;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @cameraInstructions.
  ///
  /// In en, this message translates to:
  /// **'Camera instructions'**
  String get cameraInstructions;

  /// No description provided for @tipsForCapturing.
  ///
  /// In en, this message translates to:
  /// **'Tips for capturing clear samples'**
  String get tipsForCapturing;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutHeliDx.
  ///
  /// In en, this message translates to:
  /// **'About HeliDx'**
  String get aboutHeliDx;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more about the app'**
  String get learnMore;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Medical disclaimer'**
  String get medicalDisclaimer;

  /// No description provided for @importantInfo.
  ///
  /// In en, this message translates to:
  /// **'Important information'**
  String get importantInfo;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @cameraInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Instructions'**
  String get cameraInstructionsTitle;

  /// No description provided for @cameraInstructionsBody.
  ///
  /// In en, this message translates to:
  /// **'• Hold the device steady and parallel to the sample.\n• Use even lighting — avoid harsh shadows.\n• Place the sample on a plain, contrasting background.\n• Keep the entire sample inside the frame.\n• Avoid reflections on the sample surface.'**
  String get cameraInstructionsBody;

  /// No description provided for @aboutHeliDxTitle.
  ///
  /// In en, this message translates to:
  /// **'About HeliDx'**
  String get aboutHeliDxTitle;

  /// No description provided for @aboutHeliDxBody.
  ///
  /// In en, this message translates to:
  /// **'HeliDx is a portable screening tool that compares captured specimen images against a verified reference database.\n\nThe app is designed to support — not replace — professional medical evaluation.'**
  String get aboutHeliDxBody;

  /// No description provided for @medicalDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer'**
  String get medicalDisclaimerTitle;

  /// No description provided for @medicalDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'HeliDx is intended for informational and screening purposes only. It does not provide a medical diagnosis.\n\nAlways consult a qualified healthcare professional for medical decisions. Do not rely solely on the results of this application.'**
  String get medicalDisclaimerBody;

  /// No description provided for @comparingSamples.
  ///
  /// In en, this message translates to:
  /// **'Comparing with reference samples'**
  String get comparingSamples;

  /// No description provided for @placeSampleInFrame.
  ///
  /// In en, this message translates to:
  /// **'Place the sample inside the frame'**
  String get placeSampleInFrame;

  /// No description provided for @clearBackgroundHint.
  ///
  /// In en, this message translates to:
  /// **'Use a clear background and steady lighting for the best match.'**
  String get clearBackgroundHint;

  /// No description provided for @comparisonResult.
  ///
  /// In en, this message translates to:
  /// **'Comparison result'**
  String get comparisonResult;

  /// No description provided for @positive.
  ///
  /// In en, this message translates to:
  /// **'POSITIVE'**
  String get positive;

  /// No description provided for @negative.
  ///
  /// In en, this message translates to:
  /// **'NEGATIVE'**
  String get negative;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission denied. Please enable it in settings.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera unavailable.'**
  String get cameraUnavailable;

  /// No description provided for @initializingCamera.
  ///
  /// In en, this message translates to:
  /// **'Initializing camera...'**
  String get initializingCamera;

  /// No description provided for @holdSteady.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone steady'**
  String get holdSteady;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
