import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'color_utils.dart';

/// Custom painter for rendering the color slider.
///
/// Paints three layers:
/// 1. Gradient track background
/// 2. Step indicator dots (optional)
/// 3. Circular thumb with border
class ColorSliderPainter extends CustomPainter {
  /// Creates a color slider painter.
  const ColorSliderPainter({
    required this.colors,
    required this.position,
    required this.trackHeight,
    required this.thumbSize,
    required this.thumbScale,
    required this.borderRadius,
    required this.thumbBorderWidth,
    required this.thumbBorderColor,
    required this.steps,
    required this.showStepIndicators,
    required this.stepIndicatorRadius,
    required this.stepIndicatorColor,
  });

  /// The colors for the gradient.
  final List<Color> colors;

  /// Current position (0.0 to 1.0).
  final double position;

  /// Height of the track.
  final double trackHeight;

  /// Base size of the thumb.
  final double thumbSize;

  /// Scale multiplier for thumb (for press animation).
  final double thumbScale;

  /// Border radius of the track.
  final double borderRadius;

  /// Width of the thumb border.
  final double thumbBorderWidth;

  /// Color of the thumb border.
  final Color thumbBorderColor;

  /// Number of steps (null for continuous mode).
  final int? steps;

  /// Whether to show step indicator dots.
  final bool showStepIndicators;

  /// Radius of step indicator dots.
  final double stepIndicatorRadius;

  /// Color of step indicator dots.
  final Color stepIndicatorColor;

  // Constants for shadow rendering
  static const double _shadowOffsetY = 1.0;
  static const double _shadowBlurBase = 3.0;
  static const Color _shadowColor = Color(0x4D000000); // 0.3 alpha black

  @override
  void paint(Canvas canvas, Size size) {
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        (size.height - trackHeight) / 2,
        size.width,
        trackHeight,
      ),
      Radius.circular(borderRadius),
    );

    _paintGradient(canvas, trackRect);

    if (steps != null && showStepIndicators) {
      _paintStepIndicators(canvas, size);
    }

    _paintThumb(canvas, size);
  }

  void _paintGradient(Canvas canvas, RRect trackRect) {
    final gradient = LinearGradient(colors: colors);
    final paint = Paint()..shader = gradient.createShader(trackRect.outerRect);
    canvas.drawRRect(trackRect, paint);
  }

  void _paintStepIndicators(Canvas canvas, Size size) {
    final stepCount = steps;
    if (stepCount == null || stepCount <= 1) return;

    final paint = Paint()
      ..color = stepIndicatorColor
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final thumbRadius = thumbSize / 2;
    final startX = thumbRadius;
    final effectiveWidth = size.width - thumbSize;

    for (int i = 0; i < stepCount; i++) {
      final stepPosition = i / (stepCount - 1);
      final x = startX + (stepPosition * effectiveWidth);
      canvas.drawCircle(Offset(x, centerY), stepIndicatorRadius, paint);
    }
  }

  void _paintThumb(Canvas canvas, Size size) {
    final thumbRadius = thumbSize / 2;
    final scaledRadius = thumbRadius * thumbScale;
    final thumbY = size.height / 2;
    final startX = thumbRadius;
    final effectiveWidth = size.width - thumbSize;
    final thumbX = startX + (position * effectiveWidth);
    final thumbOffset = Offset(thumbX, thumbY);

    final currentColor = ColorUtils.getColorAtPosition(colors, position);

    // Shadow
    canvas.drawCircle(
      Offset(thumbX, thumbY + _shadowOffsetY),
      scaledRadius,
      Paint()
        ..color = _shadowColor
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          _shadowBlurBase * thumbScale,
        ),
    );

    // Fill
    canvas.drawCircle(thumbOffset, scaledRadius, Paint()..color = currentColor);

    // Border
    canvas.drawCircle(
      thumbOffset,
      scaledRadius - thumbBorderWidth / 2,
      Paint()
        ..color = thumbBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = thumbBorderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant ColorSliderPainter oldDelegate) {
    // Check most frequently changing properties first for early exit
    if (oldDelegate.position != position ||
        oldDelegate.thumbScale != thumbScale) {
      return true;
    }

    // Check list equality properly (not reference equality)
    if (!listEquals(oldDelegate.colors, colors)) {
      return true;
    }

    // Check remaining properties
    return oldDelegate.trackHeight != trackHeight ||
        oldDelegate.thumbSize != thumbSize ||
        oldDelegate.steps != steps ||
        oldDelegate.showStepIndicators != showStepIndicators ||
        oldDelegate.stepIndicatorRadius != stepIndicatorRadius ||
        oldDelegate.stepIndicatorColor != stepIndicatorColor ||
        oldDelegate.thumbBorderWidth != thumbBorderWidth ||
        oldDelegate.thumbBorderColor != thumbBorderColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
