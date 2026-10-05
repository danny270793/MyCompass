/// Pure helpers for headings, bearings and coordinates.
abstract final class CompassMath {
  /// Normalizes any angle to [0, 360).
  static double normalize(double degrees) {
    final r = degrees % 360;
    return r < 0 ? r + 360 : r;
  }

  /// Signed shortest difference `to - from`, in (-180, 180].
  static double delta(double from, double to) {
    final d = normalize(to - from);
    return d > 180 ? d - 360 : d;
  }

  /// Exponential smoothing that takes the short way around 0/360, so a needle
  /// near North does not spin a full turn when the heading wraps.
  static double smooth(double previous, double next, double factor) =>
      normalize(previous + delta(previous, next) * factor);

  /// Index into the 16-point compass rose (0 = N, 4 = E, 8 = S, 12 = W).
  static int point16(double heading) =>
      ((normalize(heading) + 11.25) / 22.5).floor() % 16;

  /// Index into the 8 principal winds (0 = N, 2 = E, 4 = S, 6 = W).
  static int point8(double heading) =>
      ((normalize(heading) + 22.5) / 45).floor() % 8;

  /// Formats a coordinate as degrees, minutes, seconds with a hemisphere.
  static String dms(double value, {required bool isLatitude}) {
    final hemisphere = isLatitude
        ? (value >= 0 ? 'N' : 'S')
        : (value >= 0 ? 'E' : 'W');
    final abs = value.abs();
    var d = abs.floor();
    final minutesFull = (abs - d) * 60;
    var m = minutesFull.floor();
    var s = ((minutesFull - m) * 60).round();
    if (s == 60) {
      s = 0;
      m++;
    }
    if (m == 60) {
      m = 0;
      d++;
    }
    return '$d°$m′$s″ $hemisphere';
  }
}
