import 'dart:math' as math;

class CircularSmoothingFilter {
  final double alpha;
  double? _previousHeading;

  CircularSmoothingFilter({this.alpha = 0.2}) {
    if (alpha <= 0.0 || alpha > 1.0) {
      throw ArgumentError('Smoothing factor must be > 0 and <= 1.0');
    }
  }

  double smooth(double newHeading) {
    if (_previousHeading == null) {
      _previousHeading = newHeading;
      return newHeading;
    }

    // Convert degrees to radians for Cartesian smoothing
    final prevRad = _previousHeading! * (math.pi / 180.0);
    final newRad = newHeading * (math.pi / 180.0);

    // Cartesian coordinates
    final prevX = math.cos(prevRad);
    final prevY = math.sin(prevRad);

    final newX = math.cos(newRad);
    final newY = math.sin(newRad);

    // Exponential Moving Average on Cartesian plane
    final smoothX = prevX + alpha * (newX - prevX);
    final smoothY = prevY + alpha * (newY - prevY);

    // Convert back to degrees
    var smoothHeading = math.atan2(smoothY, smoothX) * (180.0 / math.pi);
    smoothHeading = (smoothHeading + 360.0) % 360.0;

    _previousHeading = smoothHeading;
    return smoothHeading;
  }
}
