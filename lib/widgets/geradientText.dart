import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final List<Color> colors;
  final double fontSize;
  final FontWeight fontWeight;

  const GradientText({
    super.key,
    required this.text,
    required this.colors,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white, // Base color (will be overridden by gradient)
        ),
      ),
    );
  }
}

// Usage example:
// GradientText(
//   text: 'Hello Name',
//   colors: [
//     Color(0xFF60A5FA), // HexColor("#60A5FA")
//     Color(0xFFA855F7), // HexColor("#A855F7")
//     Color(0xFFF87171), // HexColor("#F87171")
//   ],
//   fontSize: 20,
//   fontWeight: FontWeight.bold,
// ),
