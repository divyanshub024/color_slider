import 'package:flutter/material.dart';

/// Default colors for the color slider gradient.
///
/// A rainbow spectrum from orange through yellow, green, cyan, blue to purple.
const List<Color> defaultSliderColors = [
  Color(0xFFFF6B00), // Orange
  Color(0xFFFFD500), // Yellow
  Color(0xFF7ED321), // Green
  Color(0xFF00D4AA), // Cyan
  Color(0xFF0066FF), // Blue
  Color(0xFFAA00FF), // Purple/Magenta
];

/// Default height of the slider track.
const double defaultSliderHeight = 16.0;

/// Default size of the thumb indicator.
const double defaultThumbSize = 24.0;

/// Default width of the thumb border.
const double defaultThumbBorderWidth = 3.0;

/// Default color of the thumb border.
const Color defaultThumbBorderColor = Colors.white;

/// Default radius of step indicator dots.
const double defaultStepIndicatorRadius = 3.0;

/// Default color of step indicator dots.
const Color defaultStepIndicatorColor = Color(0x80FFFFFF);

/// Default value for showing step indicators in step mode.
const bool defaultShowStepIndicators = true;

/// Default padding around the slider for increased touch area.
const EdgeInsets defaultSliderPadding = EdgeInsets.symmetric(vertical: 8.0);
