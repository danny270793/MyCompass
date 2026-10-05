import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mycompass/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../core/compass/app_compass_settings_controller.dart';
import '../core/di/injection.dart';
import '../features/compass/compass_cubit.dart';
import '../features/compass/compass_math.dart';
import '../features/compass/compass_state.dart';
import '../widgets/compass_dial.dart';

List<String> _points16(AppLocalizations l10n) => [
  l10n.dirN,
  l10n.dirNNE,
  l10n.dirNE,
  l10n.dirENE,
  l10n.dirE,
  l10n.dirESE,
  l10n.dirSE,
  l10n.dirSSE,
  l10n.dirS,
  l10n.dirSSW,
  l10n.dirSW,
  l10n.dirWSW,
  l10n.dirW,
  l10n.dirWNW,
  l10n.dirNW,
  l10n.dirNNW,
];

List<String> _names16(AppLocalizations l10n) => [
  l10n.dirNameN,
  l10n.dirNameNNE,
  l10n.dirNameNE,
  l10n.dirNameENE,
  l10n.dirNameE,
  l10n.dirNameESE,
  l10n.dirNameSE,
  l10n.dirNameSSE,
  l10n.dirNameS,
  l10n.dirNameSSW,
  l10n.dirNameSW,
  l10n.dirNameWSW,
  l10n.dirNameW,
  l10n.dirNameWNW,
  l10n.dirNameNW,
  l10n.dirNameNNW,
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CompassCubit>()..start(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> with WidgetsBindingObserver {
  final _settings = getIt<AppCompassSettingsController>();
  StreamSubscription<int>? _crossingSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settings.addListener(_syncWakelock);
    _syncWakelock();
    _crossingSub = context.read<CompassCubit>().directionCrossings.listen((_) {
      if (_settings.haptics) HapticFeedback.selectionClick();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settings.removeListener(_syncWakelock);
    _crossingSub?.cancel();
    _setWakelock(false);
    super.dispose();
  }

  void _syncWakelock() => _setWakelock(_settings.keepScreenOn);

  /// Best-effort: platforms without wakelock support just keep default sleep.
  static void _setWakelock(bool enable) {
    WakelockPlus.toggle(enable: enable).catchError((_) {});
  }

  // Coming back from system settings: re-check location access.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final cubit = context.read<CompassCubit>();
    if (cubit.state.location != LocationStatus.active &&
        cubit.state.location != LocationStatus.waiting) {
      cubit.startLocation();
    }
  }

  void _showCalibration() {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.all_inclusive_rounded, size: 40),
        title: Text(l10n.calibrateTitle),
        content: Text(l10n.calibrateBody, textAlign: TextAlign.center),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.calibrateDone),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.calibrate,
            icon: const Icon(Icons.all_inclusive_rounded),
            onPressed: _showCalibration,
          ),
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CompassCubit, CompassState>(
          buildWhen: (a, b) => a.sensor != b.sensor,
          builder: (context, state) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: switch (state.sensor) {
              SensorStatus.starting => _StatusPanel(
                key: const ValueKey('starting'),
                icon: Icons.explore_outlined,
                title: l10n.sensorStartingTitle,
                body: l10n.sensorStartingBody,
                busy: true,
              ),
              SensorStatus.unavailable => _StatusPanel(
                key: const ValueKey('none'),
                icon: Icons.explore_off_outlined,
                title: l10n.noSensorTitle,
                body: l10n.noSensorBody,
              ),
              SensorStatus.active => _Dashboard(
                key: const ValueKey('active'),
                onCalibrate: _showCalibration,
              ),
            },
          ),
        ),
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({super.key, required this.onCalibrate});

  final VoidCallback onCalibrate;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CompassCubit, CompassState>(
      builder: (context, state) {
        final cubit = context.read<CompassCubit>();
        final heading = state.heading ?? 0;
        final correction = cubit.courseCorrection;
        final onCourse =
            correction != null &&
            correction.abs() <= CompassCubit.onCourseToleranceDegrees;

        final dial = CompassDial(
          heading: heading,
          targetBearing: state.targetBearing,
          onCourse: onCourse,
          cardinals: [l10n.dirN, l10n.dirE, l10n.dirS, l10n.dirW],
        );

        final readout = _HeadingReadout(
          heading: heading,
          point: _points16(l10n)[CompassMath.point16(heading)],
          name: _names16(l10n)[CompassMath.point16(heading)],
        );

        final bearing = _BearingBar(
          target: state.targetBearing,
          correction: correction,
          onCourse: onCourse,
          onToggle: cubit.toggleBearingLock,
        );

        final accuracy = state.accuracy == HeadingAccuracy.high
            ? null
            : _AccuracyBanner(accuracy: state.accuracy, onTap: onCalibrate);

        final location = _LocationCard(state: state);

        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: dial),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(0, 16, 24, 16),
                      child: Column(
                        children: [
                          readout,
                          const SizedBox(height: 16),
                          bearing,
                          if (accuracy != null) ...[
                            const SizedBox(height: 12),
                            accuracy,
                          ],
                          const SizedBox(height: 12),
                          location,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                children: [
                  readout,
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: dial,
                    ),
                  ),
                  const SizedBox(height: 8),
                  bearing,
                  if (accuracy != null) ...[
                    const SizedBox(height: 12),
                    accuracy,
                  ],
                  const SizedBox(height: 12),
                  location,
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HeadingReadout extends StatelessWidget {
  const _HeadingReadout({
    required this.heading,
    required this.point,
    required this.name,
  });

  final double heading;
  final String point;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading.round().remainder(360).toString(),
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -2,
                height: 1,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              '°',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  point,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _BearingBar extends StatelessWidget {
  const _BearingBar({
    required this.target,
    required this.correction,
    required this.onCourse,
    required this.onToggle,
  });

  final double? target;
  final double? correction;
  final bool onCourse;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locked = target != null;
    const green = Color(0xFF43A047);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
        child: Row(
          children: [
            Icon(
              locked
                  ? (onCourse
                        ? Icons.check_circle_rounded
                        : (correction! > 0
                              ? Icons.turn_right_rounded
                              : Icons.turn_left_rounded))
                  : Icons.navigation_outlined,
              color: locked && onCourse ? green : scheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: locked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.bearingLockedTo(target!.round().toString()),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          onCourse
                              ? l10n.bearingOnCourse
                              : l10n.bearingOffset(
                                  correction!.abs().round().toString(),
                                ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onCourse ? green : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.bearingTitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.bearingHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
            locked
                ? OutlinedButton.icon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.lock_open_rounded, size: 18),
                    label: Text(l10n.bearingUnlock),
                  )
                : FilledButton.tonalIcon(
                    onPressed: onToggle,
                    icon: const Icon(Icons.lock_outline_rounded, size: 18),
                    label: Text(l10n.bearingLock),
                  ),
          ],
        ),
      ),
    );
  }
}

class _AccuracyBanner extends StatelessWidget {
  const _AccuracyBanner({required this.accuracy, required this.onTap});

  final HeadingAccuracy accuracy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final low = accuracy == HeadingAccuracy.low;
    final color = low ? scheme.error : const Color(0xFFFB8C00);
    return Material(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  low ? l10n.accuracyLow : l10n.accuracyMedium,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                l10n.calibrate,
                style: theme.textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.state});

  final CompassState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final cubit = context.read<CompassCubit>();

    Widget prompt(
      String title,
      String body,
      String action,
      VoidCallback onTap,
    ) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  Icons.location_off_outlined,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(onPressed: onTap, child: Text(action)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    switch (state.location) {
      case LocationStatus.serviceDisabled:
        return prompt(
          l10n.locationOffTitle,
          l10n.locationOffBody,
          l10n.openLocationSettings,
          cubit.openLocationSettings,
        );
      case LocationStatus.permissionDenied:
        return prompt(
          l10n.locationPermissionTitle,
          l10n.locationPermissionBody,
          l10n.grantPermission,
          cubit.startLocation,
        );
      case LocationStatus.permissionDeniedForever:
        return prompt(
          l10n.locationBlockedTitle,
          l10n.locationBlockedBody,
          l10n.openAppSettings,
          cubit.openAppSettings,
        );
      case LocationStatus.checking:
      case LocationStatus.waiting:
        return Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            leading: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            title: Text(l10n.locationWaiting),
          ),
        );
      case LocationStatus.active:
        break;
    }

    final p = state.position!;
    return ListenableBuilder(
      listenable: getIt<AppCompassSettingsController>(),
      builder: (context, _) {
        final dms =
            getIt<AppCompassSettingsController>().coordinateFormat ==
            CoordinateFormat.dms;
        final lat = dms
            ? CompassMath.dms(p.latitude, isLatitude: true)
            : '${p.latitude.toStringAsFixed(5)}°';
        final lng = dms
            ? CompassMath.dms(p.longitude, isLatitude: false)
            : '${p.longitude.toStringAsFixed(5)}°';

        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.place_outlined, size: 18, color: scheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.locationTitle,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.locationCopy,
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: '${p.latitude}, ${p.longitude}'),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(content: Text(l10n.locationCopied)),
                          );
                      },
                    ),
                    IconButton.filledTonal(
                      tooltip: l10n.locationOpenInMaps,
                      icon: const Icon(Icons.map_outlined, size: 20),
                      onPressed: () => launchUrl(
                        Uri.parse(
                          'https://www.google.com/maps/search/?api=1&query=${p.latitude},${p.longitude}',
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 24,
                  runSpacing: 10,
                  children: [
                    _Stat(label: l10n.statLatitude, value: lat),
                    _Stat(label: l10n.statLongitude, value: lng),
                    _Stat(
                      label: l10n.statAltitude,
                      value:
                          '${p.altitude.toStringAsFixed(0)} ${l10n.unitMeters}',
                    ),
                    _Stat(
                      label: l10n.statAccuracy,
                      value:
                          '±${p.accuracy.toStringAsFixed(0)} ${l10n.unitMeters}',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// Centered illustration + message for sensor states.
class _StatusPanel extends StatelessWidget {
  const _StatusPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.busy = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (busy)
                    SizedBox(
                      width: 112,
                      height: 112,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: scheme.primary,
                      ),
                    ),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: scheme.primaryContainer,
                    child: Icon(
                      icon,
                      size: 44,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
