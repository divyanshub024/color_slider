import 'package:flutter/material.dart';

import 'color_slider_painter.dart';
import 'color_utils.dart';
import 'constants.dart';

/// A customizable color slider widget that allows users to pick colors
/// from a gradient spectrum.
///
/// Supports two modes:
/// - **Continuous mode**: When [steps] is null, allows smooth color selection
/// - **Step mode**: When [steps] is provided, snaps to discrete positions
///
/// Example usage:
/// ```dart
/// ColorSlider(
///   onChanged: (color) => print(color),
///   steps: 7,
///   showStepIndicators: true,
/// )
/// ```
class ColorSlider extends StatefulWidget {
  /// Creates a continuous color slider widget.
  ///
  /// This constructor creates a slider that allows smooth color selection
  /// along the gradient without discrete steps.
  ///
  /// The [onChanged] callback is required and will be called whenever
  /// the selected color changes.
  ///
  /// For step-based selection, use [ColorSlider.steps] instead.
  const ColorSlider({
    super.key,
    required this.onChanged,
    this.colors = defaultSliderColors,
    this.initialColor,
    this.height = defaultSliderHeight,
    this.thumbSize = defaultThumbSize,
    this.borderRadius,
    this.thumbBorderWidth = defaultThumbBorderWidth,
    this.thumbBorderColor = defaultThumbBorderColor,
    this.padding = defaultSliderPadding,
  }) : steps = null,
       showStepIndicators = false,
       stepIndicatorRadius = defaultStepIndicatorRadius,
       stepIndicatorColor = defaultStepIndicatorColor;

  /// Creates a step-based color slider widget.
  ///
  /// This constructor is a convenience method for creating a slider with
  /// discrete step positions. The [stepCount] parameter is required and
  /// [showStepIndicators] defaults to `true`.
  ///
  /// Example:
  /// ```dart
  /// ColorSlider.steps(
  ///   steps: 7,
  ///   onChanged: (color) => print(color),
  /// )
  /// ```
  const ColorSlider.steps({
    super.key,
    required this.onChanged,
    required this.steps,
    this.colors = defaultSliderColors,
    this.showStepIndicators = defaultShowStepIndicators,
    this.initialColor,
    this.height = defaultSliderHeight,
    this.thumbSize = defaultThumbSize,
    this.borderRadius,
    this.thumbBorderWidth = defaultThumbBorderWidth,
    this.thumbBorderColor = defaultThumbBorderColor,
    this.stepIndicatorRadius = defaultStepIndicatorRadius,
    this.stepIndicatorColor = defaultStepIndicatorColor,
    this.padding = defaultSliderPadding,
  });

  /// The colors to use for the gradient.
  ///
  /// Defaults to a rainbow spectrum.
  final List<Color> colors;

  /// The number of steps for discrete color selection.
  ///
  /// When null, continuous color selection is enabled.
  final int? steps;

  /// Whether to show dot indicators at each step position.
  ///
  /// Only applicable when [steps] is not null.
  final bool showStepIndicators;

  /// Callback that is called when the selected color changes.
  final ValueChanged<Color> onChanged;

  /// The initial color to select.
  ///
  /// If null, defaults to the first color in [colors].
  final Color? initialColor;

  /// The height of the slider track.
  final double height;

  /// The size of the thumb indicator.
  final double thumbSize;

  /// The border radius of the slider track.
  ///
  /// Defaults to half of [height] for a pill shape.
  final double? borderRadius;

  /// The width of the thumb border.
  final double thumbBorderWidth;

  /// The color of the thumb border.
  final Color thumbBorderColor;

  /// The radius of step indicator dots.
  final double stepIndicatorRadius;

  /// The color of step indicator dots.
  final Color stepIndicatorColor;

  /// Padding around the slider to increase touch area.
  ///
  /// Defaults to 8 pixels vertical padding.
  final EdgeInsets padding;

  @override
  State<ColorSlider> createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider>
    with TickerProviderStateMixin {
  double _position = 0.0;
  double _displayPosition = 0.0;

  late final AnimationController _positionController;
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  // Cached values to avoid recalculation
  late double _effectiveBorderRadius;
  double _cachedTrackWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _position = _calculateInitialPosition();
    _displayPosition = _position;
    _effectiveBorderRadius = widget.borderRadius ?? widget.height / 2;
    _initAnimations();
  }

  @override
  void didUpdateWidget(ColorSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.borderRadius != widget.borderRadius ||
        oldWidget.height != widget.height) {
      _effectiveBorderRadius = widget.borderRadius ?? widget.height / 2;
    }
  }

  void _initAnimations() {
    _positionController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(_onPositionAnimationTick);

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..addListener(_onScaleAnimationTick);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  void _onPositionAnimationTick() {
    setState(() {});
  }

  void _onScaleAnimationTick() {
    setState(() {});
  }

  @override
  void dispose() {
    _positionController.removeListener(_onPositionAnimationTick);
    _scaleController.removeListener(_onScaleAnimationTick);
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  double _calculateInitialPosition() {
    if (widget.initialColor == null) return 0.0;

    final initialColor = widget.initialColor!;
    double closestPosition = 0.0;
    double minDistance = double.infinity;

    // Use step-based search for better performance
    const sampleCount = 100;
    for (int i = 0; i <= sampleCount; i++) {
      final pos = i / sampleCount;
      final color = ColorUtils.getColorAtPosition(widget.colors, pos);
      final distance = ColorUtils.colorDistance(color, initialColor);
      if (distance < minDistance) {
        minDistance = distance;
        closestPosition = pos;
      }
    }

    return closestPosition;
  }

  double _snapToStep(double position) {
    final steps = widget.steps;
    if (steps == null || steps <= 1) return position;

    final stepSize = 1.0 / (steps - 1);
    final snappedIndex = (position / stepSize).round();
    return (snappedIndex * stepSize).clamp(0.0, 1.0);
  }

  void _onPressStart() => _scaleController.forward();

  void _onPressEnd() => _scaleController.reverse();

  void _updatePosition(double localX, {bool animate = false}) {
    final thumbRadius = widget.thumbSize / 2;
    final effectiveWidth = _cachedTrackWidth - widget.thumbSize;
    if (effectiveWidth <= 0) return;

    final adjustedX = localX - thumbRadius;
    double newPosition = (adjustedX / effectiveWidth).clamp(0.0, 1.0);

    if (widget.steps != null) {
      newPosition = _snapToStep(newPosition);
    }

    if (newPosition != _position) {
      final oldDisplayPosition = _displayPosition;
      _position = newPosition;

      if (animate && widget.steps != null) {
        _animateToPosition(oldDisplayPosition, newPosition);
      } else {
        _displayPosition = newPosition;
        setState(() {});
      }

      widget.onChanged(ColorUtils.getColorAtPosition(widget.colors, _position));
    }
  }

  void _animateToPosition(double from, double to) {
    _positionController
      ..value = 0.0
      ..animateTo(1.0, curve: Curves.easeOutCubic);

    // Update display position during animation
    _positionController.addListener(() {
      final t = _positionController.value;
      _displayPosition = from + (to - from) * t;
    });
  }

  void _handleDragEnd() {
    _onPressEnd();
    if (widget.steps != null) {
      final snapped = _snapToStep(_position);
      if (snapped != _displayPosition) {
        _animateToPosition(_displayPosition, snapped);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _cachedTrackWidth = constraints.maxWidth - widget.padding.horizontal;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            _onPressStart();
            _updatePosition(
              details.localPosition.dx - widget.padding.left,
              animate: true,
            );
          },
          onTapUp: (_) => _onPressEnd(),
          onTapCancel: _onPressEnd,
          onHorizontalDragStart: (details) {
            _onPressStart();
            _updatePosition(details.localPosition.dx - widget.padding.left);
          },
          onHorizontalDragUpdate: (details) {
            _updatePosition(details.localPosition.dx - widget.padding.left);
          },
          onHorizontalDragEnd: (_) => _handleDragEnd(),
          onHorizontalDragCancel: _onPressEnd,
          child: Padding(
            padding: widget.padding,
            child: SizedBox(
              height: widget.thumbSize,
              width: double.infinity,
              child: CustomPaint(
                painter: ColorSliderPainter(
                  colors: widget.colors,
                  position: _displayPosition,
                  trackHeight: widget.height,
                  thumbSize: widget.thumbSize,
                  thumbScale: _scaleAnimation.value,
                  borderRadius: _effectiveBorderRadius,
                  thumbBorderWidth: widget.thumbBorderWidth,
                  thumbBorderColor: widget.thumbBorderColor,
                  steps: widget.steps,
                  showStepIndicators: widget.showStepIndicators,
                  stepIndicatorRadius: widget.stepIndicatorRadius,
                  stepIndicatorColor: widget.stepIndicatorColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
