import 'package:color_slider/color_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Slider Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ColorSliderDemo(),
    );
  }
}

class ColorSliderDemo extends StatefulWidget {
  const ColorSliderDemo({super.key});

  @override
  State<ColorSliderDemo> createState() => _ColorSliderDemoState();
}

class _ColorSliderDemoState extends State<ColorSliderDemo> {
  Color _continuousColor = const Color(0xFFFF6B00);
  Color _steppedColor = const Color(0xFFFF6B00);
  Color _customColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Color Slider Demo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Continuous Mode Example
            DemoSection(
              title: 'Continuous Mode',
              subtitle: 'Smooth color selection along the gradient',
              selectedColor: _continuousColor,
              child: ColorSlider(
                onChanged: (color) {
                  setState(() => _continuousColor = color);
                },
              ),
            ),

            const SizedBox(height: 40),

            // Stepped Mode Example
            DemoSection(
              title: 'Step Mode (7 steps)',
              subtitle: 'Snaps to discrete positions with indicators',
              selectedColor: _steppedColor,
              child: ColorSlider.steps(
                steps: 7,
                showStepIndicators: true,
                onChanged: (color) {
                  setState(() => _steppedColor = color);
                },
              ),
            ),

            const SizedBox(height: 40),

            // Custom Colors Example
            DemoSection(
              title: 'Custom Colors & Styling',
              subtitle: 'Pink to Purple gradient with 5 steps',
              selectedColor: _customColor,
              child: ColorSlider.steps(
                steps: 5,
                colors: const [
                  Color(0xFFFF006E),
                  Color(0xFFFF4D6D),
                  Color(0xFFC9184A),
                  Color(0xFF9D4EDD),
                  Color(0xFF7B2CBF),
                ],
                showStepIndicators: true,
                height: 32,
                thumbSize: 40,
                thumbBorderWidth: 4,
                thumbBorderColor: Colors.white,
                borderRadius: 16,
                onChanged: (color) {
                  setState(() => _customColor = color);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selectedColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Color selectedColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
          const SizedBox(height: 12),
          Text(
            _colorToHex(selectedColor),
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).toInt().toRadixString(16).padLeft(2, '0');
    return '#${r.toUpperCase()}${g.toUpperCase()}${b.toUpperCase()}';
  }
}
