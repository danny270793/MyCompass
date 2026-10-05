import 'package:get_it/get_it.dart';
import '../compass/app_compass_settings_controller.dart';
import '../locale/app_locale_controller.dart';
import '../security/app_biometric_unlock_controller.dart';
import '../theme/app_theme_controller.dart';
import '../../features/compass/compass_cubit.dart';
import '../../features/compass/compass_sources.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerLazySingleton<AppLocaleController>(AppLocaleController.new);
  getIt.registerLazySingleton<AppThemeController>(AppThemeController.new);
  getIt.registerLazySingleton<AppCompassSettingsController>(
    AppCompassSettingsController.new,
  );
  getIt.registerLazySingleton<AppBiometricUnlockController>(
    AppBiometricUnlockController.new,
  );

  // compass
  getIt.registerLazySingleton<HeadingSource>(FlutterCompassHeadingSource.new);
  getIt.registerLazySingleton<PositionSource>(GeolocatorPositionSource.new);
  getIt.registerFactory<CompassCubit>(
    () => CompassCubit(getIt<HeadingSource>(), getIt<PositionSource>()),
  );
}
