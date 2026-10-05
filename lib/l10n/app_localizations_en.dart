// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Compass';

  @override
  String get settings => 'Settings';

  @override
  String get retry => 'Try again';

  @override
  String get dirN => 'N';

  @override
  String get dirNNE => 'NNE';

  @override
  String get dirNE => 'NE';

  @override
  String get dirENE => 'ENE';

  @override
  String get dirE => 'E';

  @override
  String get dirESE => 'ESE';

  @override
  String get dirSE => 'SE';

  @override
  String get dirSSE => 'SSE';

  @override
  String get dirS => 'S';

  @override
  String get dirSSW => 'SSW';

  @override
  String get dirSW => 'SW';

  @override
  String get dirWSW => 'WSW';

  @override
  String get dirW => 'W';

  @override
  String get dirWNW => 'WNW';

  @override
  String get dirNW => 'NW';

  @override
  String get dirNNW => 'NNW';

  @override
  String get dirNameN => 'North';

  @override
  String get dirNameNNE => 'North-northeast';

  @override
  String get dirNameNE => 'Northeast';

  @override
  String get dirNameENE => 'East-northeast';

  @override
  String get dirNameE => 'East';

  @override
  String get dirNameESE => 'East-southeast';

  @override
  String get dirNameSE => 'Southeast';

  @override
  String get dirNameSSE => 'South-southeast';

  @override
  String get dirNameS => 'South';

  @override
  String get dirNameSSW => 'South-southwest';

  @override
  String get dirNameSW => 'Southwest';

  @override
  String get dirNameWSW => 'West-southwest';

  @override
  String get dirNameW => 'West';

  @override
  String get dirNameWNW => 'West-northwest';

  @override
  String get dirNameNW => 'Northwest';

  @override
  String get dirNameNNW => 'North-northwest';

  @override
  String get bearingLock => 'Lock bearing';

  @override
  String get bearingTitle => 'Follow a bearing';

  @override
  String get bearingHint => 'Lock your current heading to follow it.';

  @override
  String get bearingUnlock => 'Clear bearing';

  @override
  String bearingLockedTo(String degrees) {
    return 'Target $degrees°';
  }

  @override
  String bearingOffset(String degrees) {
    return '$degrees° off course';
  }

  @override
  String get bearingOnCourse => 'On course';

  @override
  String get accuracyHigh => 'High accuracy';

  @override
  String get accuracyMedium => 'Medium accuracy';

  @override
  String get accuracyLow => 'Low accuracy — calibrate';

  @override
  String get calibrate => 'Calibrate';

  @override
  String get calibrateTitle => 'Calibrate the compass';

  @override
  String get calibrateBody =>
      'Move your phone in a figure-8 a few times, rotating it in every direction. Keep away from magnets, metal and electronics.';

  @override
  String get calibrateDone => 'Got it';

  @override
  String get statLatitude => 'Latitude';

  @override
  String get statLongitude => 'Longitude';

  @override
  String get statAltitude => 'Altitude';

  @override
  String get statAccuracy => 'Accuracy';

  @override
  String get locationTitle => 'Your location';

  @override
  String get locationOpenInMaps => 'Open in Maps';

  @override
  String get locationCopy => 'Copy coordinates';

  @override
  String get locationCopied => 'Coordinates copied.';

  @override
  String get locationWaiting => 'Getting your location…';

  @override
  String get locationOffTitle => 'Location is off';

  @override
  String get locationOffBody =>
      'Turn on location to see your coordinates and altitude.';

  @override
  String get openLocationSettings => 'Open location settings';

  @override
  String get locationPermissionTitle => 'Show your coordinates';

  @override
  String get locationPermissionBody =>
      'Allow location to see where you are. The compass works without it.';

  @override
  String get grantPermission => 'Allow location';

  @override
  String get locationBlockedTitle => 'Location access blocked';

  @override
  String get locationBlockedBody =>
      'Enable location from the app settings to see your coordinates.';

  @override
  String get openAppSettings => 'Open app settings';

  @override
  String get noSensorTitle => 'No compass sensor';

  @override
  String get noSensorBody =>
      'This device does not have a magnetometer, so it cannot show a heading.';

  @override
  String get sensorStartingTitle => 'Starting compass';

  @override
  String get sensorStartingBody =>
      'Hold your phone flat while the sensor wakes up.';

  @override
  String get unitMeters => 'm';

  @override
  String get settingsMeasurementSection => 'Compass';

  @override
  String get settingsCoordinates => 'Coordinate format';

  @override
  String get settingsCoordinatesDecimal => 'Decimal (-0.18065°)';

  @override
  String get settingsCoordinatesDms => 'Degrees, minutes, seconds (0°10′50″ S)';

  @override
  String get settingsHaptics => 'Haptic feedback';

  @override
  String get settingsHapticsSubtitle =>
      'Vibrate gently when passing a cardinal direction.';

  @override
  String get settingsKeepScreenOn => 'Keep screen on';

  @override
  String get settingsKeepScreenOnSubtitle =>
      'Prevents the display from sleeping while the compass is open.';

  @override
  String get settingsAboutTagline =>
      'Find your way with a precise, easy-to-read compass.';

  @override
  String get settingsAboutBulletHeading =>
      'See your heading in degrees and cardinal direction on a smooth, animated dial.';

  @override
  String get settingsAboutBulletBearing =>
      'Lock a bearing and follow it to stay on course.';

  @override
  String get settingsAboutBulletLocation =>
      'Check your coordinates and altitude and open them in Maps.';

  @override
  String get settingsAboutDataBody =>
      'Sensor readings and your location are processed only on your device and are never stored or uploaded.';

  @override
  String get settingsPrivacyTagline => 'Your location stays on your device.';

  @override
  String get settingsPrivacyDataTitle => 'Sensors and location';

  @override
  String get settingsPrivacyDataBody =>
      'Compass reads the magnetometer and, if you allow it, your GPS position while the app is open. Everything is processed on your device and is not recorded, uploaded or shared.';

  @override
  String get settingsPrivacyInfraTitle => 'What we store';

  @override
  String get settingsPrivacyInfraBody =>
      'Only your preferences (language, theme, coordinate format, haptics, keep screen on and biometric unlock) are saved on this device. There are no accounts and no servers.';

  @override
  String get settingsPrivacySharingTitle => 'Sharing and ads';

  @override
  String get settingsPrivacySharingBody =>
      'We do not sell your personal information, show ads or use analytics. Opening your location in Maps hands the coordinates to the maps app you choose.';

  @override
  String get settingsPrivacyNoticeTitle => 'Changes';

  @override
  String get settingsPrivacyNoticeBody =>
      'This policy may be updated from time to time. Continuing to use the app after changes are published means you accept the updated policy.';

  @override
  String get settingsTermsTagline => 'Rules for using this app.';

  @override
  String get settingsTermsAcceptanceTitle => 'Acceptance';

  @override
  String get settingsTermsAcceptanceBody =>
      'By accessing or using Compass, you agree to these terms. If you do not agree, do not use the app.';

  @override
  String get settingsTermsDisclaimerTitle => 'Not a navigation instrument';

  @override
  String get settingsTermsDisclaimerBody =>
      'Phone sensors can be affected by magnets, metal and interference, and readings may be inaccurate. Do not rely on the app for safety-critical navigation; carry a proper compass and map outdoors.';

  @override
  String get settingsTermsLiabilityTitle => 'Limitation of liability';

  @override
  String get settingsTermsLiabilityBody =>
      'To the fullest extent permitted by law, the authors and contributors are not liable for any indirect, incidental, special, consequential or punitive damages, or any loss resulting from your use of the app or reliance on its readings.';

  @override
  String get settingsTermsResponsibilitiesTitle => 'Your responsibilities';

  @override
  String get settingsTermsResponsibilitiesBody =>
      'You are responsible for using the app safely and in compliance with the laws that apply to you.';

  @override
  String get settingsTermsNoticeTitle => 'Changes';

  @override
  String get settingsTermsNoticeBody =>
      'These terms may be updated from time to time. If you continue to use the app after changes are posted, that indicates you accept the revised terms.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageSpanish => 'Spanish';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsBiometricUnlockTitle => 'Face ID & fingerprint';

  @override
  String get settingsBiometricUnlockSubtitle =>
      'Use biometrics to unlock the app.';

  @override
  String get settingsBiometricUnavailable =>
      'Biometric unlock is not available on this device.';

  @override
  String get settingsBiometricAuthReason =>
      'Confirm to enable biometric unlock.';

  @override
  String get settingsBiometricResumeReason => 'Authenticate to continue.';

  @override
  String get biometricLockTitle => 'App locked';

  @override
  String get biometricLockBody => 'Use Face ID or fingerprint to continue.';

  @override
  String get biometricLockUnlockButton => 'Unlock';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsAboutApp => 'About';

  @override
  String get settingsRateApp => 'Rate on Google Play';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTermsOfUse => 'Terms of use';

  @override
  String get settingsAboutVersionLabel => 'Version';

  @override
  String get settingsAboutFeaturesHeading => 'What you can do';

  @override
  String get settingsAboutDataHeading => 'Your data';

  @override
  String get settingsAboutDeveloperHeading => 'Developer';

  @override
  String get settingsAboutDeveloperGithub => 'GitHub';

  @override
  String get settingsAboutDeveloperWebsite => 'Website';

  @override
  String get settingsAboutDeveloperYoutube => 'YouTube';

  @override
  String get settingsAboutDeveloperLinkedin => 'LinkedIn';
}
