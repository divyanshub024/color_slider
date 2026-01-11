import 'package:color_slider/color_slider.dart';
import 'package:color_slider/src/color_utils.dart';
import 'package:color_slider/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ColorSlider', () {
    testWidgets('renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ColorSlider(onChanged: (_) {})),
        ),
      );

      expect(find.byType(ColorSlider), findsOneWidget);
    });

    testWidgets('uses default colors when not specified', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ColorSlider(onChanged: (_) {})),
        ),
      );

      final colorSlider = tester.widget<ColorSlider>(find.byType(ColorSlider));
      expect(colorSlider.colors, equals(defaultSliderColors));
    });

    testWidgets('accepts custom colors', (WidgetTester tester) async {
      const customColors = [Colors.red, Colors.blue, Colors.green];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorSlider(colors: customColors, onChanged: (_) {}),
          ),
        ),
      );

      final colorSlider = tester.widget<ColorSlider>(find.byType(ColorSlider));
      expect(colorSlider.colors, equals(customColors));
    });

    testWidgets('calls onChanged when tapped', (WidgetTester tester) async {
      Color? selectedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ColorSlider(
                  onChanged: (color) {
                    selectedColor = color;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap in the middle of the slider
      await tester.tap(find.byType(ColorSlider));
      await tester.pump();

      expect(selectedColor, isNotNull);
    });

    testWidgets('calls onChanged when dragged', (WidgetTester tester) async {
      final selectedColors = <Color>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ColorSlider(
                  onChanged: (color) {
                    selectedColors.add(color);
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Drag across the slider
      await tester.drag(find.byType(ColorSlider), const Offset(100, 0));
      await tester.pump();

      expect(selectedColors, isNotEmpty);
    });

    testWidgets('returns different colors at different positions', (
      WidgetTester tester,
    ) async {
      Color? colorAtStart;
      Color? colorAtEnd;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: ColorSlider(
                  onChanged: (color) {
                    colorAtStart ??= color;
                    colorAtEnd = color;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      // Tap at the start
      final sliderRect = tester.getRect(find.byType(ColorSlider));
      await tester.tapAt(Offset(sliderRect.left + 20, sliderRect.center.dy));
      await tester.pump();

      // Tap at the end
      await tester.tapAt(Offset(sliderRect.right - 20, sliderRect.center.dy));
      await tester.pump();

      expect(colorAtStart, isNotNull);
      expect(colorAtEnd, isNotNull);
      expect(colorAtStart, isNot(equals(colorAtEnd)));
    });

    group('Continuous Mode', () {
      testWidgets('does not snap to steps when steps is null', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 300,
                  child: ColorSlider(onChanged: (_) {}),
                ),
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.steps, isNull);
      });

      testWidgets('does not show step indicators', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {})),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.showStepIndicators, isFalse);
      });
    });

    group('Step Mode', () {
      testWidgets('accepts steps parameter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(steps: 7, onChanged: (_) {}),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.steps, equals(7));
      });

      testWidgets('shows step indicators by default', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(steps: 5, onChanged: (_) {}),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.showStepIndicators, isTrue);
      });

      testWidgets('shows step indicators when enabled', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(
                steps: 5,
                onChanged: (_) {},
                showStepIndicators: true,
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.showStepIndicators, isTrue);
        expect(colorSlider.steps, equals(5));
      });

      testWidgets('hides step indicators when disabled', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(
                steps: 5,
                onChanged: (_) {},
                showStepIndicators: false,
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.showStepIndicators, isFalse);
      });

      testWidgets('works with minimum steps (2)', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(steps: 2, onChanged: (_) {}),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.steps, equals(2));
      });
    });

    group('Customization', () {
      testWidgets('accepts custom height', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {}, height: 30.0)),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.height, equals(30.0));
      });

      testWidgets('accepts custom thumb size', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider(onChanged: (_) {}, thumbSize: 36.0),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbSize, equals(36.0));
      });

      testWidgets('accepts custom border radius', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider(onChanged: (_) {}, borderRadius: 8.0),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.borderRadius, equals(8.0));
      });

      testWidgets('accepts custom thumb border width', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider(onChanged: (_) {}, thumbBorderWidth: 5.0),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbBorderWidth, equals(5.0));
      });

      testWidgets('accepts custom thumb border color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider(
                onChanged: (_) {},
                thumbBorderColor: Colors.black,
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbBorderColor, equals(Colors.black));
      });

      testWidgets('accepts custom step indicator radius', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(
                steps: 5,
                onChanged: (_) {},
                stepIndicatorRadius: 5.0,
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.stepIndicatorRadius, equals(5.0));
      });

      testWidgets('accepts custom step indicator color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(
                steps: 5,
                onChanged: (_) {},
                stepIndicatorColor: Colors.red,
              ),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.stepIndicatorColor, equals(Colors.red));
      });

      testWidgets('accepts initial color', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider(onChanged: (_) {}, initialColor: Colors.green),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.initialColor, equals(Colors.green));
      });
    });

    group('Default Values', () {
      testWidgets('uses default height', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {})),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.height, equals(defaultSliderHeight));
      });

      testWidgets('uses default thumb size', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {})),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbSize, equals(defaultThumbSize));
      });

      testWidgets('uses default thumb border width', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {})),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbBorderWidth, equals(defaultThumbBorderWidth));
      });

      testWidgets('uses default thumb border color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: ColorSlider(onChanged: (_) {})),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(colorSlider.thumbBorderColor, equals(defaultThumbBorderColor));
      });

      testWidgets('steps slider uses default step indicator radius', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(steps: 5, onChanged: (_) {}),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(
          colorSlider.stepIndicatorRadius,
          equals(defaultStepIndicatorRadius),
        );
      });

      testWidgets('steps slider uses default step indicator color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorSlider.steps(steps: 5, onChanged: (_) {}),
            ),
          ),
        );

        final colorSlider = tester.widget<ColorSlider>(
          find.byType(ColorSlider),
        );
        expect(
          colorSlider.stepIndicatorColor,
          equals(defaultStepIndicatorColor),
        );
      });
    });
  });

  group('defaultSliderColors', () {
    test('contains 6 colors', () {
      expect(defaultSliderColors.length, equals(6));
    });

    test('starts with orange and ends with purple', () {
      expect(defaultSliderColors.first, equals(const Color(0xFFFF6B00)));
      expect(defaultSliderColors.last, equals(const Color(0xFFAA00FF)));
    });
  });

  group('Default Constants', () {
    test('defaultSliderHeight is 16.0', () {
      expect(defaultSliderHeight, equals(16.0));
    });

    test('defaultThumbSize is 24.0', () {
      expect(defaultThumbSize, equals(24.0));
    });

    test('defaultThumbBorderWidth is 3.0', () {
      expect(defaultThumbBorderWidth, equals(3.0));
    });

    test('defaultThumbBorderColor is white', () {
      expect(defaultThumbBorderColor, equals(Colors.white));
    });

    test('defaultStepIndicatorRadius is 3.0', () {
      expect(defaultStepIndicatorRadius, equals(3.0));
    });

    test('defaultStepIndicatorColor is semi-transparent white', () {
      expect(defaultStepIndicatorColor, equals(const Color(0x80FFFFFF)));
    });

    test('defaultShowStepIndicators is true', () {
      expect(defaultShowStepIndicators, isTrue);
    });
  });

  group('ColorUtils', () {
    group('getColorAtPosition', () {
      test('returns first color at position 0.0', () {
        const colors = [
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
        ];
        final result = ColorUtils.getColorAtPosition(colors, 0.0);
        expect(result, equals(const Color(0xFFFF0000)));
      });

      test('returns last color at position 1.0', () {
        const colors = [
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
        ];
        final result = ColorUtils.getColorAtPosition(colors, 1.0);
        expect(result, equals(const Color(0xFF0000FF)));
      });

      test('returns middle color at position 0.5 with 3 colors', () {
        const colors = [
          Color(0xFFFF0000),
          Color(0xFF00FF00),
          Color(0xFF0000FF),
        ];
        final result = ColorUtils.getColorAtPosition(colors, 0.5);
        expect(result, equals(const Color(0xFF00FF00)));
      });

      test('interpolates between colors', () {
        const colors = [Colors.black, Colors.white];
        final result = ColorUtils.getColorAtPosition(colors, 0.5);
        // Should be gray (midpoint between black and white)
        expect(result.r, closeTo(0.5, 0.01));
        expect(result.g, closeTo(0.5, 0.01));
        expect(result.b, closeTo(0.5, 0.01));
      });

      test('returns black for empty colors list', () {
        final result = ColorUtils.getColorAtPosition([], 0.5);
        expect(result, equals(Colors.black));
      });

      test('returns single color for single-element list', () {
        const color = Color(0xFFFF0000);
        final result = ColorUtils.getColorAtPosition([color], 0.5);
        expect(result, equals(color));
      });

      test('clamps position below 0.0', () {
        const colors = [Color(0xFFFF0000), Color(0xFF0000FF)];
        final result = ColorUtils.getColorAtPosition(colors, -0.5);
        expect(result, equals(const Color(0xFFFF0000)));
      });

      test('clamps position above 1.0', () {
        const colors = [Color(0xFFFF0000), Color(0xFF0000FF)];
        final result = ColorUtils.getColorAtPosition(colors, 1.5);
        expect(result, equals(const Color(0xFF0000FF)));
      });
    });

    group('colorDistance', () {
      test('returns 0 for identical colors', () {
        final distance = ColorUtils.colorDistance(Colors.red, Colors.red);
        expect(distance, equals(0.0));
      });

      test('returns non-zero for different colors', () {
        final distance = ColorUtils.colorDistance(Colors.red, Colors.blue);
        expect(distance, greaterThan(0.0));
      });

      test('returns max distance for black and white', () {
        final distance = ColorUtils.colorDistance(Colors.black, Colors.white);
        // Max distance in RGB space: 255^2 * 3 = 195075
        expect(distance, closeTo(195075.0, 1.0));
      });

      test('is symmetric', () {
        final distanceAB = ColorUtils.colorDistance(Colors.red, Colors.green);
        final distanceBA = ColorUtils.colorDistance(Colors.green, Colors.red);
        expect(distanceAB, equals(distanceBA));
      });
    });
  });
}
