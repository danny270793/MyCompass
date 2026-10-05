import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'compass_math.dart';
import 'compass_sources.dart';
import 'compass_state.dart';

class CompassCubit extends Cubit<CompassState> {
  CompassCubit(this._headings, this._positions) : super(const CompassState());

  final HeadingSource _headings;
  final PositionSource _positions;
  StreamSubscription<HeadingReading>? _headingSub;
  StreamSubscription<Position>? _positionSub;

  /// Weight of each new reading; lower is steadier but laggier.
  static const double smoothing = 0.25;

  /// Within this many degrees of the target bearing counts as on course.
  static const double onCourseToleranceDegrees = 5;

  /// Emitted (as the new 8-point index) each time the heading crosses into
  /// another principal direction, for haptic feedback.
  final _crossings = StreamController<int>.broadcast();
  Stream<int> get directionCrossings => _crossings.stream;

  Future<void> start() async {
    _startHeading();
    await startLocation();
  }

  void _startHeading() {
    if (_headingSub != null) return;
    final stream = _headings.headings();
    if (stream == null) {
      emit(state.copyWith(sensor: SensorStatus.unavailable));
      return;
    }
    _headingSub = stream.listen(
      _onHeading,
      onError: (_) => emit(state.copyWith(sensor: SensorStatus.unavailable)),
    );
  }

  void _onHeading(HeadingReading reading) {
    final raw = CompassMath.normalize(reading.heading);
    final previous = state.heading;
    final next = previous == null
        ? raw
        : CompassMath.smooth(previous, raw, smoothing);
    if (previous != null) {
      final before = CompassMath.point8(previous);
      final after = CompassMath.point8(next);
      if (before != after) _crossings.add(after);
    }
    emit(
      state.copyWith(
        sensor: SensorStatus.active,
        heading: next,
        accuracyDegrees: reading.accuracy,
      ),
    );
  }

  Future<void> startLocation() async {
    if (!await _positions.isServiceEnabled()) {
      if (!isClosed) {
        emit(state.copyWith(location: LocationStatus.serviceDisabled));
      }
      return;
    }
    var permission = await _positions.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _positions.requestPermission();
    }
    if (isClosed) return;

    switch (permission) {
      case LocationPermission.denied:
        emit(state.copyWith(location: LocationStatus.permissionDenied));
      case LocationPermission.deniedForever:
        emit(state.copyWith(location: LocationStatus.permissionDeniedForever));
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        if (_positionSub != null) return;
        if (state.location != LocationStatus.active) {
          emit(state.copyWith(location: LocationStatus.waiting));
        }
        _positionSub = _positions.positions().listen(
          (p) => emit(
            state.copyWith(location: LocationStatus.active, position: p),
          ),
          onError: (_) {
            unawaited(_positionSub?.cancel());
            _positionSub = null;
            if (!isClosed) {
              emit(state.copyWith(location: LocationStatus.serviceDisabled));
            }
          },
        );
    }
  }

  /// Locks the current heading as the bearing to follow, or clears it.
  void toggleBearingLock() {
    if (state.targetBearing != null) {
      emit(state.copyWith(targetBearing: () => null));
    } else if (state.heading != null) {
      final rounded = state.heading!.roundToDouble();
      emit(state.copyWith(targetBearing: () => CompassMath.normalize(rounded)));
    }
  }

  /// Signed degrees to turn to face the locked bearing (positive = right).
  double? get courseCorrection {
    final h = state.heading;
    final t = state.targetBearing;
    if (h == null || t == null) return null;
    return CompassMath.delta(h, t);
  }

  Future<void> openLocationSettings() => _positions.openLocationSettings();

  Future<void> openAppSettings() => _positions.openAppSettings();

  @override
  Future<void> close() async {
    await _headingSub?.cancel();
    await _positionSub?.cancel();
    await _crossings.close();
    return super.close();
  }
}
