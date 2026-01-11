import 'package:flutter/material.dart';

/// Utility class for color-related calculations.
abstract final class ColorUtils {
  /// Calculates the squared Euclidean distance between two colors in RGB space.
  ///
  /// Used for finding the closest color match.
  static double colorDistance(Color a, Color b) {
    final dr = (a.r - b.r) * 255;
    final dg = (a.g - b.g) * 255;
    final db = (a.b - b.b) * 255;
    return dr * dr + dg * dg + db * db;
  }

  /// Interpolates a color at the given [position] (0.0 to 1.0) within
  /// the gradient defined by [colors].
  ///
  /// Returns [Colors.black] if [colors] is empty.
  static Color getColorAtPosition(List<Color> colors, double position) {
    if (colors.isEmpty) return Colors.black;
    if (colors.length == 1) return colors.first;

    position = position.clamp(0.0, 1.0);

    final segmentCount = colors.length - 1;
    final scaledPosition = position * segmentCount;
    final segmentIndex = scaledPosition.floor().clamp(0, segmentCount - 1);
    final segmentProgress = scaledPosition - segmentIndex;

    final startColor = colors[segmentIndex];
    final endColor = colors[segmentIndex + 1];

    return Color.lerp(startColor, endColor, segmentProgress) ?? startColor;
  }
}
