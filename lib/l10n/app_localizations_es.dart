// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Brújula';

  @override
  String get settings => 'Ajustes';

  @override
  String get retry => 'Reintentar';

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
  String get dirSSW => 'SSO';

  @override
  String get dirSW => 'SO';

  @override
  String get dirWSW => 'OSO';

  @override
  String get dirW => 'O';

  @override
  String get dirWNW => 'ONO';

  @override
  String get dirNW => 'NO';

  @override
  String get dirNNW => 'NNO';

  @override
  String get dirNameN => 'Norte';

  @override
  String get dirNameNNE => 'Nornoreste';

  @override
  String get dirNameNE => 'Noreste';

  @override
  String get dirNameENE => 'Estenoreste';

  @override
  String get dirNameE => 'Este';

  @override
  String get dirNameESE => 'Estesureste';

  @override
  String get dirNameSE => 'Sureste';

  @override
  String get dirNameSSE => 'Sursureste';

  @override
  String get dirNameS => 'Sur';

  @override
  String get dirNameSSW => 'Sursuroeste';

  @override
  String get dirNameSW => 'Suroeste';

  @override
  String get dirNameWSW => 'Oestesuroeste';

  @override
  String get dirNameW => 'Oeste';

  @override
  String get dirNameWNW => 'Oestenoroeste';

  @override
  String get dirNameNW => 'Noroeste';

  @override
  String get dirNameNNW => 'Nornoroeste';

  @override
  String get bearingLock => 'Fijar rumbo';

  @override
  String get bearingTitle => 'Seguir un rumbo';

  @override
  String get bearingHint => 'Fija tu rumbo actual para seguirlo.';

  @override
  String get bearingUnlock => 'Quitar rumbo';

  @override
  String bearingLockedTo(String degrees) {
    return 'Objetivo $degrees°';
  }

  @override
  String bearingOffset(String degrees) {
    return '$degrees° fuera de rumbo';
  }

  @override
  String get bearingOnCourse => 'En rumbo';

  @override
  String get accuracyHigh => 'Precisión alta';

  @override
  String get accuracyMedium => 'Precisión media';

  @override
  String get accuracyLow => 'Precisión baja — calibra';

  @override
  String get calibrate => 'Calibrar';

  @override
  String get calibrateTitle => 'Calibra la brújula';

  @override
  String get calibrateBody =>
      'Mueve tu teléfono formando un 8 varias veces, girándolo en todas las direcciones. Aléjate de imanes, metales y aparatos electrónicos.';

  @override
  String get calibrateDone => 'Entendido';

  @override
  String get statLatitude => 'Latitud';

  @override
  String get statLongitude => 'Longitud';

  @override
  String get statAltitude => 'Altitud';

  @override
  String get statAccuracy => 'Precisión';

  @override
  String get locationTitle => 'Tu ubicación';

  @override
  String get locationOpenInMaps => 'Abrir en Mapas';

  @override
  String get locationCopy => 'Copiar coordenadas';

  @override
  String get locationCopied => 'Coordenadas copiadas.';

  @override
  String get locationWaiting => 'Obteniendo tu ubicación…';

  @override
  String get locationOffTitle => 'La ubicación está desactivada';

  @override
  String get locationOffBody =>
      'Activa la ubicación para ver tus coordenadas y altitud.';

  @override
  String get openLocationSettings => 'Abrir ajustes de ubicación';

  @override
  String get locationPermissionTitle => 'Muestra tus coordenadas';

  @override
  String get locationPermissionBody =>
      'Permite la ubicación para ver dónde estás. La brújula funciona sin ella.';

  @override
  String get grantPermission => 'Permitir ubicación';

  @override
  String get locationBlockedTitle => 'Acceso a la ubicación bloqueado';

  @override
  String get locationBlockedBody =>
      'Activa la ubicación desde los ajustes de la app para ver tus coordenadas.';

  @override
  String get openAppSettings => 'Abrir ajustes de la app';

  @override
  String get noSensorTitle => 'Sin sensor de brújula';

  @override
  String get noSensorBody =>
      'Este dispositivo no tiene magnetómetro, por lo que no puede mostrar el rumbo.';

  @override
  String get sensorStartingTitle => 'Iniciando brújula';

  @override
  String get sensorStartingBody =>
      'Mantén tu teléfono plano mientras el sensor se activa.';

  @override
  String get unitMeters => 'm';

  @override
  String get settingsMeasurementSection => 'Brújula';

  @override
  String get settingsCoordinates => 'Formato de coordenadas';

  @override
  String get settingsCoordinatesDecimal => 'Decimal (-0.18065°)';

  @override
  String get settingsCoordinatesDms => 'Grados, minutos, segundos (0°10′50″ S)';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsHapticsSubtitle =>
      'Vibra suavemente al pasar por un punto cardinal.';

  @override
  String get settingsKeepScreenOn => 'Mantener pantalla encendida';

  @override
  String get settingsKeepScreenOnSubtitle =>
      'Evita que la pantalla se apague mientras la brújula está abierta.';

  @override
  String get settingsAboutTagline =>
      'Encuentra tu camino con una brújula precisa y fácil de leer.';

  @override
  String get settingsAboutBulletHeading =>
      'Ve tu rumbo en grados y punto cardinal en un dial animado y fluido.';

  @override
  String get settingsAboutBulletBearing =>
      'Fija un rumbo y síguelo para no desviarte.';

  @override
  String get settingsAboutBulletLocation =>
      'Consulta tus coordenadas y altitud y ábrelas en Mapas.';

  @override
  String get settingsAboutDataBody =>
      'Las lecturas del sensor y tu ubicación se procesan solo en tu dispositivo y nunca se guardan ni se suben.';

  @override
  String get settingsPrivacyTagline =>
      'Tu ubicación se queda en tu dispositivo.';

  @override
  String get settingsPrivacyDataTitle => 'Sensores y ubicación';

  @override
  String get settingsPrivacyDataBody =>
      'Mi Brújula lee el magnetómetro y, si lo permites, tu posición GPS mientras la app está abierta. Todo se procesa en tu dispositivo y no se registra, sube ni comparte.';

  @override
  String get settingsPrivacyInfraTitle => 'Qué guardamos';

  @override
  String get settingsPrivacyInfraBody =>
      'Solo se guardan tus preferencias (idioma, tema, formato de coordenadas, vibración, pantalla encendida y desbloqueo biométrico) en este dispositivo. No hay cuentas ni servidores.';

  @override
  String get settingsPrivacySharingTitle => 'Compartir y anuncios';

  @override
  String get settingsPrivacySharingBody =>
      'No vendemos tu información personal, no mostramos anuncios ni usamos analíticas. Al abrir tu ubicación en Mapas, las coordenadas se envían a la app de mapas que elijas.';

  @override
  String get settingsPrivacyNoticeTitle => 'Cambios';

  @override
  String get settingsPrivacyNoticeBody =>
      'Esta política puede actualizarse ocasionalmente. Si sigues usando la app después de publicarse los cambios, aceptas la política actualizada.';

  @override
  String get settingsTermsTagline => 'Reglas para usar esta app.';

  @override
  String get settingsTermsAcceptanceTitle => 'Aceptación';

  @override
  String get settingsTermsAcceptanceBody =>
      'Al acceder o usar Mi Brújula, aceptas estos términos. Si no estás de acuerdo, no uses la app.';

  @override
  String get settingsTermsDisclaimerTitle =>
      'No es un instrumento de navegación';

  @override
  String get settingsTermsDisclaimerBody =>
      'Los sensores del teléfono pueden verse afectados por imanes, metales e interferencias, y las lecturas pueden ser imprecisas. No confíes en la app para navegación crítica; lleva una brújula y un mapa adecuados al aire libre.';

  @override
  String get settingsTermsLiabilityTitle => 'Limitación de responsabilidad';

  @override
  String get settingsTermsLiabilityBody =>
      'En la máxima medida permitida por la ley, los autores y colaboradores no son responsables de daños indirectos, incidentales, especiales, consecuentes o punitivos, ni de pérdidas derivadas del uso de la app o de la confianza en sus lecturas.';

  @override
  String get settingsTermsResponsibilitiesTitle => 'Tus responsabilidades';

  @override
  String get settingsTermsResponsibilitiesBody =>
      'Eres responsable de usar la app de forma segura y conforme a las leyes que te apliquen.';

  @override
  String get settingsTermsNoticeTitle => 'Cambios';

  @override
  String get settingsTermsNoticeBody =>
      'Estos términos pueden actualizarse ocasionalmente. Si sigues usando la app después de publicarse los cambios, aceptas los términos revisados.';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Predeterminado del sistema';

  @override
  String get settingsLanguageEnglish => 'Inglés';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Predeterminado del sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsSecuritySection => 'Seguridad';

  @override
  String get settingsBiometricUnlockTitle => 'Face ID y huella digital';

  @override
  String get settingsBiometricUnlockSubtitle =>
      'Usa biometría para desbloquear la app.';

  @override
  String get settingsBiometricUnavailable =>
      'El desbloqueo biométrico no está disponible en este dispositivo.';

  @override
  String get settingsBiometricAuthReason =>
      'Confirma para activar el desbloqueo biométrico.';

  @override
  String get settingsBiometricResumeReason => 'Autentícate para continuar.';

  @override
  String get biometricLockTitle => 'App bloqueada';

  @override
  String get biometricLockBody =>
      'Usa Face ID o tu huella digital para continuar.';

  @override
  String get biometricLockUnlockButton => 'Desbloquear';

  @override
  String get settingsAboutSection => 'Acerca de';

  @override
  String get settingsAboutApp => 'Acerca de';

  @override
  String get settingsRateApp => 'Calificar en Google Play';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsTermsOfUse => 'Términos de uso';

  @override
  String get settingsAboutVersionLabel => 'Versión';

  @override
  String get settingsAboutFeaturesHeading => 'Qué puedes hacer';

  @override
  String get settingsAboutDataHeading => 'Tus datos';

  @override
  String get settingsAboutDeveloperHeading => 'Desarrollador';

  @override
  String get settingsAboutDeveloperGithub => 'GitHub';

  @override
  String get settingsAboutDeveloperWebsite => 'Sitio web';

  @override
  String get settingsAboutDeveloperYoutube => 'YouTube';

  @override
  String get settingsAboutDeveloperLinkedin => 'LinkedIn';
}
