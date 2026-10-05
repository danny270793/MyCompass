import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

/// One magnetometer reading.
class HeadingReading {
  const HeadingReading(this.heading, this.accuracy);

  /// Degrees clockwise from magnetic north.
  final double heading;

  /// Platform accuracy estimate in degrees, if reported.
  final double? accuracy;
}

/// Seams over the device sensors so the cubit can be tested without hardware.
abstract class HeadingSource {
  /// `null` when the device has no compass sensor.
  Stream<HeadingReading>? headings();
}

abstract class PositionSource {
  Future<bool> isServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Stream<Position> positions();
  Future<bool> openLocationSettings();
  Future<bool> openAppSettings();
}

class FlutterCompassHeadingSource implements HeadingSource {
  @override
  Stream<HeadingReading>? headings() => FlutterCompass.events
      ?.where((e) => e.heading != null)
      .map((e) => HeadingReading(e.heading!, e.accuracy));
}

class GeolocatorPositionSource implements PositionSource {
  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Stream<Position> positions() => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    ),
  );

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();
}
