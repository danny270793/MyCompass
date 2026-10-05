import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

enum SensorStatus { starting, unavailable, active }

/// Location is optional: the compass works without it.
enum LocationStatus {
  checking,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  waiting,
  active,
}

enum HeadingAccuracy { high, medium, low }

class CompassState extends Equatable {
  const CompassState({
    this.sensor = SensorStatus.starting,
    this.location = LocationStatus.checking,
    this.heading,
    this.accuracyDegrees,
    this.targetBearing,
    this.position,
  });

  final SensorStatus sensor;
  final LocationStatus location;

  /// Smoothed heading in [0, 360).
  final double? heading;
  final double? accuracyDegrees;

  /// Locked bearing the user wants to follow, if any.
  final double? targetBearing;
  final Position? position;

  /// iOS reports accuracy in degrees; Android reports nothing useful, which
  /// is treated as high so the UI does not nag needlessly.
  HeadingAccuracy get accuracy {
    final a = accuracyDegrees;
    if (a == null || a < 0) return HeadingAccuracy.high;
    if (a <= 15) return HeadingAccuracy.high;
    if (a <= 30) return HeadingAccuracy.medium;
    return HeadingAccuracy.low;
  }

  CompassState copyWith({
    SensorStatus? sensor,
    LocationStatus? location,
    double? heading,
    double? accuracyDegrees,
    double? Function()? targetBearing,
    Position? position,
  }) => CompassState(
    sensor: sensor ?? this.sensor,
    location: location ?? this.location,
    heading: heading ?? this.heading,
    accuracyDegrees: accuracyDegrees ?? this.accuracyDegrees,
    targetBearing: targetBearing != null ? targetBearing() : this.targetBearing,
    position: position ?? this.position,
  );

  @override
  List<Object?> get props => [
    sensor,
    location,
    heading,
    accuracyDegrees,
    targetBearing,
    position,
  ];
}
