import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Compass'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @dirN.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get dirN;

  /// No description provided for @dirNNE.
  ///
  /// In en, this message translates to:
  /// **'NNE'**
  String get dirNNE;

  /// No description provided for @dirNE.
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get dirNE;

  /// No description provided for @dirENE.
  ///
  /// In en, this message translates to:
  /// **'ENE'**
  String get dirENE;

  /// No description provided for @dirE.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get dirE;

  /// No description provided for @dirESE.
  ///
  /// In en, this message translates to:
  /// **'ESE'**
  String get dirESE;

  /// No description provided for @dirSE.
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get dirSE;

  /// No description provided for @dirSSE.
  ///
  /// In en, this message translates to:
  /// **'SSE'**
  String get dirSSE;

  /// No description provided for @dirS.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dirS;

  /// No description provided for @dirSSW.
  ///
  /// In en, this message translates to:
  /// **'SSW'**
  String get dirSSW;

  /// No description provided for @dirSW.
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get dirSW;

  /// No description provided for @dirWSW.
  ///
  /// In en, this message translates to:
  /// **'WSW'**
  String get dirWSW;

  /// No description provided for @dirW.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dirW;

  /// No description provided for @dirWNW.
  ///
  /// In en, this message translates to:
  /// **'WNW'**
  String get dirWNW;

  /// No description provided for @dirNW.
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get dirNW;

  /// No description provided for @dirNNW.
  ///
  /// In en, this message translates to:
  /// **'NNW'**
  String get dirNNW;

  /// No description provided for @dirNameN.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get dirNameN;

  /// No description provided for @dirNameNNE.
  ///
  /// In en, this message translates to:
  /// **'North-northeast'**
  String get dirNameNNE;

  /// No description provided for @dirNameNE.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get dirNameNE;

  /// No description provided for @dirNameENE.
  ///
  /// In en, this message translates to:
  /// **'East-northeast'**
  String get dirNameENE;

  /// No description provided for @dirNameE.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get dirNameE;

  /// No description provided for @dirNameESE.
  ///
  /// In en, this message translates to:
  /// **'East-southeast'**
  String get dirNameESE;

  /// No description provided for @dirNameSE.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get dirNameSE;

  /// No description provided for @dirNameSSE.
  ///
  /// In en, this message translates to:
  /// **'South-southeast'**
  String get dirNameSSE;

  /// No description provided for @dirNameS.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get dirNameS;

  /// No description provided for @dirNameSSW.
  ///
  /// In en, this message translates to:
  /// **'South-southwest'**
  String get dirNameSSW;

  /// No description provided for @dirNameSW.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get dirNameSW;

  /// No description provided for @dirNameWSW.
  ///
  /// In en, this message translates to:
  /// **'West-southwest'**
  String get dirNameWSW;

  /// No description provided for @dirNameW.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get dirNameW;

  /// No description provided for @dirNameWNW.
  ///
  /// In en, this message translates to:
  /// **'West-northwest'**
  String get dirNameWNW;

  /// No description provided for @dirNameNW.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get dirNameNW;

  /// No description provided for @dirNameNNW.
  ///
  /// In en, this message translates to:
  /// **'North-northwest'**
  String get dirNameNNW;

  /// No description provided for @bearingLock.
  ///
  /// In en, this message translates to:
  /// **'Lock bearing'**
  String get bearingLock;

  /// No description provided for @bearingTitle.
  ///
  /// In en, this message translates to:
  /// **'Follow a bearing'**
  String get bearingTitle;

  /// No description provided for @bearingHint.
  ///
  /// In en, this message translates to:
  /// **'Lock your current heading to follow it.'**
  String get bearingHint;

  /// No description provided for @bearingUnlock.
  ///
  /// In en, this message translates to:
  /// **'Clear bearing'**
  String get bearingUnlock;

  /// No description provided for @bearingLockedTo.
  ///
  /// In en, this message translates to:
  /// **'Target {degrees}°'**
  String bearingLockedTo(String degrees);

  /// No description provided for @bearingOffset.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° off course'**
  String bearingOffset(String degrees);

  /// No description provided for @bearingOnCourse.
  ///
  /// In en, this message translates to:
  /// **'On course'**
  String get bearingOnCourse;

  /// No description provided for @accuracyHigh.
  ///
  /// In en, this message translates to:
  /// **'High accuracy'**
  String get accuracyHigh;

  /// No description provided for @accuracyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium accuracy'**
  String get accuracyMedium;

  /// No description provided for @accuracyLow.
  ///
  /// In en, this message translates to:
  /// **'Low accuracy — calibrate'**
  String get accuracyLow;

  /// No description provided for @calibrate.
  ///
  /// In en, this message translates to:
  /// **'Calibrate'**
  String get calibrate;

  /// No description provided for @calibrateTitle.
  ///
  /// In en, this message translates to:
  /// **'Calibrate the compass'**
  String get calibrateTitle;

  /// No description provided for @calibrateBody.
  ///
  /// In en, this message translates to:
  /// **'Move your phone in a figure-8 a few times, rotating it in every direction. Keep away from magnets, metal and electronics.'**
  String get calibrateBody;

  /// No description provided for @calibrateDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get calibrateDone;

  /// No description provided for @statLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get statLatitude;

  /// No description provided for @statLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get statLongitude;

  /// No description provided for @statAltitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get statAltitude;

  /// No description provided for @statAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get statAccuracy;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get locationTitle;

  /// No description provided for @locationOpenInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get locationOpenInMaps;

  /// No description provided for @locationCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy coordinates'**
  String get locationCopy;

  /// No description provided for @locationCopied.
  ///
  /// In en, this message translates to:
  /// **'Coordinates copied.'**
  String get locationCopied;

  /// No description provided for @locationWaiting.
  ///
  /// In en, this message translates to:
  /// **'Getting your location…'**
  String get locationWaiting;

  /// No description provided for @locationOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Location is off'**
  String get locationOffTitle;

  /// No description provided for @locationOffBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on location to see your coordinates and altitude.'**
  String get locationOffBody;

  /// No description provided for @openLocationSettings.
  ///
  /// In en, this message translates to:
  /// **'Open location settings'**
  String get openLocationSettings;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Show your coordinates'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow location to see where you are. The compass works without it.'**
  String get locationPermissionBody;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get grantPermission;

  /// No description provided for @locationBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Location access blocked'**
  String get locationBlockedTitle;

  /// No description provided for @locationBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Enable location from the app settings to see your coordinates.'**
  String get locationBlockedBody;

  /// No description provided for @openAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Open app settings'**
  String get openAppSettings;

  /// No description provided for @noSensorTitle.
  ///
  /// In en, this message translates to:
  /// **'No compass sensor'**
  String get noSensorTitle;

  /// No description provided for @noSensorBody.
  ///
  /// In en, this message translates to:
  /// **'This device does not have a magnetometer, so it cannot show a heading.'**
  String get noSensorBody;

  /// No description provided for @sensorStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Starting compass'**
  String get sensorStartingTitle;

  /// No description provided for @sensorStartingBody.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat while the sensor wakes up.'**
  String get sensorStartingBody;

  /// No description provided for @unitMeters.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitMeters;

  /// No description provided for @settingsMeasurementSection.
  ///
  /// In en, this message translates to:
  /// **'Compass'**
  String get settingsMeasurementSection;

  /// No description provided for @settingsCoordinates.
  ///
  /// In en, this message translates to:
  /// **'Coordinate format'**
  String get settingsCoordinates;

  /// No description provided for @settingsCoordinatesDecimal.
  ///
  /// In en, this message translates to:
  /// **'Decimal (-0.18065°)'**
  String get settingsCoordinatesDecimal;

  /// No description provided for @settingsCoordinatesDms.
  ///
  /// In en, this message translates to:
  /// **'Degrees, minutes, seconds (0°10′50″ S)'**
  String get settingsCoordinatesDms;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHaptics;

  /// No description provided for @settingsHapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrate gently when passing a cardinal direction.'**
  String get settingsHapticsSubtitle;

  /// No description provided for @settingsKeepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get settingsKeepScreenOn;

  /// No description provided for @settingsKeepScreenOnSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prevents the display from sleeping while the compass is open.'**
  String get settingsKeepScreenOnSubtitle;

  /// No description provided for @settingsAboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Find your way with a precise, easy-to-read compass.'**
  String get settingsAboutTagline;

  /// No description provided for @settingsAboutBulletHeading.
  ///
  /// In en, this message translates to:
  /// **'See your heading in degrees and cardinal direction on a smooth, animated dial.'**
  String get settingsAboutBulletHeading;

  /// No description provided for @settingsAboutBulletBearing.
  ///
  /// In en, this message translates to:
  /// **'Lock a bearing and follow it to stay on course.'**
  String get settingsAboutBulletBearing;

  /// No description provided for @settingsAboutBulletLocation.
  ///
  /// In en, this message translates to:
  /// **'Check your coordinates and altitude and open them in Maps.'**
  String get settingsAboutBulletLocation;

  /// No description provided for @settingsAboutDataBody.
  ///
  /// In en, this message translates to:
  /// **'Sensor readings and your location are processed only on your device and are never stored or uploaded.'**
  String get settingsAboutDataBody;

  /// No description provided for @settingsPrivacyTagline.
  ///
  /// In en, this message translates to:
  /// **'Your location stays on your device.'**
  String get settingsPrivacyTagline;

  /// No description provided for @settingsPrivacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensors and location'**
  String get settingsPrivacyDataTitle;

  /// No description provided for @settingsPrivacyDataBody.
  ///
  /// In en, this message translates to:
  /// **'My Compass reads the magnetometer and, if you allow it, your GPS position while the app is open. Everything is processed on your device and is not recorded, uploaded or shared.'**
  String get settingsPrivacyDataBody;

  /// No description provided for @settingsPrivacyInfraTitle.
  ///
  /// In en, this message translates to:
  /// **'What we store'**
  String get settingsPrivacyInfraTitle;

  /// No description provided for @settingsPrivacyInfraBody.
  ///
  /// In en, this message translates to:
  /// **'Only your preferences (language, theme, coordinate format, haptics, keep screen on and biometric unlock) are saved on this device. There are no accounts and no servers.'**
  String get settingsPrivacyInfraBody;

  /// No description provided for @settingsPrivacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Sharing and ads'**
  String get settingsPrivacySharingTitle;

  /// No description provided for @settingsPrivacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information, show ads or use analytics. Opening your location in Maps hands the coordinates to the maps app you choose.'**
  String get settingsPrivacySharingBody;

  /// No description provided for @settingsPrivacyNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get settingsPrivacyNoticeTitle;

  /// No description provided for @settingsPrivacyNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This policy may be updated from time to time. Continuing to use the app after changes are published means you accept the updated policy.'**
  String get settingsPrivacyNoticeBody;

  /// No description provided for @settingsTermsTagline.
  ///
  /// In en, this message translates to:
  /// **'Rules for using this app.'**
  String get settingsTermsTagline;

  /// No description provided for @settingsTermsAcceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get settingsTermsAcceptanceTitle;

  /// No description provided for @settingsTermsAcceptanceBody.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using My Compass, you agree to these terms. If you do not agree, do not use the app.'**
  String get settingsTermsAcceptanceBody;

  /// No description provided for @settingsTermsDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Not a navigation instrument'**
  String get settingsTermsDisclaimerTitle;

  /// No description provided for @settingsTermsDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Phone sensors can be affected by magnets, metal and interference, and readings may be inaccurate. Do not rely on the app for safety-critical navigation; carry a proper compass and map outdoors.'**
  String get settingsTermsDisclaimerBody;

  /// No description provided for @settingsTermsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Limitation of liability'**
  String get settingsTermsLiabilityTitle;

  /// No description provided for @settingsTermsLiabilityBody.
  ///
  /// In en, this message translates to:
  /// **'To the fullest extent permitted by law, the authors and contributors are not liable for any indirect, incidental, special, consequential or punitive damages, or any loss resulting from your use of the app or reliance on its readings.'**
  String get settingsTermsLiabilityBody;

  /// No description provided for @settingsTermsResponsibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your responsibilities'**
  String get settingsTermsResponsibilitiesTitle;

  /// No description provided for @settingsTermsResponsibilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for using the app safely and in compliance with the laws that apply to you.'**
  String get settingsTermsResponsibilitiesBody;

  /// No description provided for @settingsTermsNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get settingsTermsNoticeTitle;

  /// No description provided for @settingsTermsNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'These terms may be updated from time to time. If you continue to use the app after changes are posted, that indicates you accept the revised terms.'**
  String get settingsTermsNoticeBody;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsSecuritySection.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecuritySection;

  /// No description provided for @settingsBiometricUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Face ID & fingerprint'**
  String get settingsBiometricUnlockTitle;

  /// No description provided for @settingsBiometricUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics to unlock the app.'**
  String get settingsBiometricUnlockSubtitle;

  /// No description provided for @settingsBiometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock is not available on this device.'**
  String get settingsBiometricUnavailable;

  /// No description provided for @settingsBiometricAuthReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm to enable biometric unlock.'**
  String get settingsBiometricAuthReason;

  /// No description provided for @settingsBiometricResumeReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue.'**
  String get settingsBiometricResumeReason;

  /// No description provided for @biometricLockTitle.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get biometricLockTitle;

  /// No description provided for @biometricLockBody.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID or fingerprint to continue.'**
  String get biometricLockBody;

  /// No description provided for @biometricLockUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get biometricLockUnlockButton;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsAboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutApp;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate on Google Play'**
  String get settingsRateApp;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTermsOfUse;

  /// No description provided for @settingsAboutVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsAboutVersionLabel;

  /// No description provided for @settingsAboutFeaturesHeading.
  ///
  /// In en, this message translates to:
  /// **'What you can do'**
  String get settingsAboutFeaturesHeading;

  /// No description provided for @settingsAboutDataHeading.
  ///
  /// In en, this message translates to:
  /// **'Your data'**
  String get settingsAboutDataHeading;

  /// No description provided for @settingsAboutDeveloperHeading.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get settingsAboutDeveloperHeading;

  /// No description provided for @settingsAboutDeveloperGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get settingsAboutDeveloperGithub;

  /// No description provided for @settingsAboutDeveloperWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get settingsAboutDeveloperWebsite;

  /// No description provided for @settingsAboutDeveloperYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get settingsAboutDeveloperYoutube;

  /// No description provided for @settingsAboutDeveloperLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get settingsAboutDeveloperLinkedin;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
