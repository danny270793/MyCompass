import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How latitude / longitude are shown.
enum CoordinateFormat {
  decimal,
  dms;

  static CoordinateFormat fromStorage(String? raw) =>
      raw == 'dms' ? CoordinateFormat.dms : CoordinateFormat.decimal;

  String get storageValue => switch (this) {
    CoordinateFormat.decimal => 'decimal',
    CoordinateFormat.dms => 'dms',
  };
}

/// Persisted compass preferences: coordinate format, haptics and keep-screen-on.
class AppCompassSettingsController extends ChangeNotifier {
  AppCompassSettingsController();

  static const _formatKey = 'app_compass_coordinate_format';
  static const _hapticsKey = 'app_compass_haptics';
  static const _keepScreenOnKey = 'app_compass_keep_screen_on';

  CoordinateFormat _format = CoordinateFormat.decimal;
  bool _haptics = true;
  bool _keepScreenOn = true;

  CoordinateFormat get coordinateFormat => _format;
  bool get haptics => _haptics;
  bool get keepScreenOn => _keepScreenOn;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _format = CoordinateFormat.fromStorage(prefs.getString(_formatKey));
    _haptics = prefs.getBool(_hapticsKey) ?? true;
    _keepScreenOn = prefs.getBool(_keepScreenOnKey) ?? true;
    notifyListeners();
  }

  Future<void> setCoordinateFormat(CoordinateFormat value) async {
    if (_format == value) return;
    _format = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_formatKey, value.storageValue);
  }

  Future<void> setHaptics(bool value) async {
    if (_haptics == value) return;
    _haptics = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
  }

  Future<void> setKeepScreenOn(bool value) async {
    if (_keepScreenOn == value) return;
    _keepScreenOn = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepScreenOnKey, value);
  }
}
