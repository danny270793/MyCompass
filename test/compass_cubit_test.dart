import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mycompass/features/compass/compass_cubit.dart';
import 'package:mycompass/features/compass/compass_math.dart';
import 'package:mycompass/features/compass/compass_sources.dart';
import 'package:mycompass/features/compass/compass_state.dart';

class _FakeHeadings implements HeadingSource {
  _FakeHeadings({this.available = true});

  final bool available;
  final controller = StreamController<HeadingReading>.broadcast();

  @override
  Stream<HeadingReading>? headings() => available ? controller.stream : null;
}

class _FakePositions implements PositionSource {
  _FakePositions({
    this.serviceEnabled = true,
    this.permission = LocationPermission.whileInUse,
  });

  bool serviceEnabled;
  LocationPermission permission;
  final controller = StreamController<Position>.broadcast();

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Stream<Position> positions() => controller.stream;

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<bool> openLocationSettings() async => true;
}

Position _pos() => Position(
  latitude: -0.180653,
  longitude: -78.467838,
  timestamp: DateTime(2026),
  accuracy: 4,
  altitude: 2850,
  altitudeAccuracy: 1,
  heading: 0,
  headingAccuracy: 1,
  speed: 0,
  speedAccuracy: 1,
);

void main() {
  group('CompassMath', () {
    test('normalizes and takes the short way around north', () {
      expect(CompassMath.normalize(-10), 350);
      expect(CompassMath.normalize(725), 5);
      expect(CompassMath.delta(350, 10), 20);
      expect(CompassMath.delta(10, 350), -20);
      expect(CompassMath.smooth(350, 10, 0.5), 0);
    });

    test('maps headings to compass points', () {
      expect(CompassMath.point16(0), 0);
      expect(CompassMath.point16(359), 0);
      expect(CompassMath.point16(22.5), 1);
      expect(CompassMath.point16(90), 4);
      expect(CompassMath.point8(200), 4);
      expect(CompassMath.point8(300), 7);
    });

    test('formats degrees, minutes, seconds', () {
      expect(CompassMath.dms(-0.180653, isLatitude: true), '0°10′50″ S');
      expect(CompassMath.dms(-78.467838, isLatitude: false), '78°28′4″ W');
      expect(CompassMath.dms(10.99999, isLatitude: true), '11°0′0″ N');
    });
  });

  group('CompassCubit', () {
    test('reports a missing sensor', () async {
      final cubit = CompassCubit(
        _FakeHeadings(available: false),
        _FakePositions(),
      );
      await cubit.start();
      expect(cubit.state.sensor, SensorStatus.unavailable);
      await cubit.close();
    });

    test('smooths headings and signals cardinal crossings', () async {
      final headings = _FakeHeadings();
      final cubit = CompassCubit(headings, _FakePositions());
      final crossings = <int>[];
      cubit.directionCrossings.listen(crossings.add);
      await cubit.start();

      headings.controller.add(const HeadingReading(10, null));
      await pumpEventQueue();
      expect(cubit.state.sensor, SensorStatus.active);
      expect(cubit.state.heading, 10);

      // Smoothing moves a quarter of the way toward the new reading.
      headings.controller.add(const HeadingReading(350, null));
      await pumpEventQueue();
      expect(cubit.state.heading, closeTo(5, 1e-9));

      for (var i = 0; i < 20; i++) {
        headings.controller.add(const HeadingReading(90, null));
      }
      await pumpEventQueue();
      expect(cubit.state.heading, closeTo(90, 0.5));
      expect(crossings, [1, 2], reason: 'N → NE → E');
      await cubit.close();
    });

    test('locks a bearing and reports the course correction', () async {
      final headings = _FakeHeadings();
      final cubit = CompassCubit(headings, _FakePositions());
      await cubit.start();
      headings.controller.add(const HeadingReading(45.4, null));
      await pumpEventQueue();

      cubit.toggleBearingLock();
      expect(cubit.state.targetBearing, 45);

      for (var i = 0; i < 30; i++) {
        headings.controller.add(const HeadingReading(15, null));
      }
      await pumpEventQueue();
      expect(cubit.courseCorrection, closeTo(30, 0.5));

      cubit.toggleBearingLock();
      expect(cubit.state.targetBearing, isNull);
      expect(cubit.courseCorrection, isNull);
      await cubit.close();
    });

    test('compass keeps working when location is denied', () async {
      final headings = _FakeHeadings();
      final cubit = CompassCubit(
        headings,
        _FakePositions(permission: LocationPermission.deniedForever),
      );
      await cubit.start();
      headings.controller.add(const HeadingReading(180, null));
      await pumpEventQueue();
      expect(cubit.state.location, LocationStatus.permissionDeniedForever);
      expect(cubit.state.heading, 180);
      await cubit.close();
    });

    test('reports location services turned off', () async {
      final cubit = CompassCubit(
        _FakeHeadings(),
        _FakePositions(serviceEnabled: false),
      );
      await cubit.start();
      expect(cubit.state.location, LocationStatus.serviceDisabled);
      await cubit.close();
    });

    test('tracks position once a fix arrives', () async {
      final positions = _FakePositions();
      final cubit = CompassCubit(_FakeHeadings(), positions);
      await cubit.start();
      expect(cubit.state.location, LocationStatus.waiting);
      positions.controller.add(_pos());
      await pumpEventQueue();
      expect(cubit.state.location, LocationStatus.active);
      expect(cubit.state.position?.altitude, 2850);
      await cubit.close();
    });

    test('maps platform accuracy to levels', () {
      expect(const CompassState().accuracy, HeadingAccuracy.high);
      expect(
        const CompassState(accuracyDegrees: 20).accuracy,
        HeadingAccuracy.medium,
      );
      expect(
        const CompassState(accuracyDegrees: 45).accuracy,
        HeadingAccuracy.low,
      );
    });
  });
}
