import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({
    super.key,
    required this.height,
    required this.width,
    required this.value,
    required this.radius,
    required this.backgroundColor,
    required this.accentColor,
    this.gradient,
  });

  final double height, width, value, radius;
  final Color backgroundColor;
  final Color accentColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(.3),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
        ),
        Container(
          height: height,
          width: width * value,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: accentColor,
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(.1),
                spreadRadius: 1,
                blurRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
