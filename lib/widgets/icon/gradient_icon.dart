import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    super.key,
    required this.icon,
    this.size,
    required this.gradient,
  });

  final IconData icon;
  final double? size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.modulate,
      child: Padding(
        padding: EdgeInsets.all(size != null ? (size! / 10) : 1),
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
          shadows: [
            for (Color color in gradient.colors)
              Shadow(color: color, blurRadius: 2),
          ],
        ),
      ),
      shaderCallback: (Rect bounds) => gradient.createShader(bounds),
    );
  }
}
