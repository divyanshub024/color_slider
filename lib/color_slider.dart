/// A customizable color slider widget for Flutter.
///
/// This package provides a [ColorSlider] widget that allows users to pick
/// colors from a gradient spectrum. It supports both continuous and step-based
/// color selection.
///
/// ## Features
///
/// - Continuous color selection along a gradient
/// - Step-based selection with snap behavior
/// - Customizable colors, track height, thumb size, and more
/// - Smooth animations for thumb press and step snapping
///
/// ## Usage
///
/// ```dart
/// import 'package:color_slider/color_slider.dart';
///
/// ColorSlider(
///   onChanged: (color) => print(color),
///   steps: 7,
///   showStepIndicators: true,
/// )
/// ```
library;

export 'src/color_slider_widget.dart' show ColorSlider;
export 'src/constants.dart' show defaultSliderColors;
