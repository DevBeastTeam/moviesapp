import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.marginEnd = true,
    required this.splashColor,
    required this.highlightColor,
    this.fillColor,
    this.onPressed,
    required this.child,
  });

  final bool marginEnd;
  final Color splashColor;
  final Color highlightColor;
  final Color? fillColor;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      hoverElevation: 0,
      elevation: 0,
      focusElevation: 0,
      fillColor: fillColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: onPressed,
      child: Container(
        margin: marginEnd ? const EdgeInsets.only(left: 8, right: 8) : null,
        child: child,
      ),
    );
  }
}
