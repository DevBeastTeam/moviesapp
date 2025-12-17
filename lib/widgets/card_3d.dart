import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';

/// A reusable 3D card widget with neumorphic shadow effects.
/// Wrap any widget with this to give it a raised 3D appearance
/// with light source from top-left and shadow on bottom-right.
class Card3D extends StatelessWidget {
  const Card3D({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 32,
    this.backgroundColor,
    this.shadowColor,
    this.highlightColor,
    this.shadowOffset = 2,
    this.shadowBlur = 8,
    this.highlightOpacity = 0.1,
    this.shadowOpacity = 0.2,
    this.borderWidth = 0.5,
  });

  /// The child widget to wrap
  final Widget child;

  /// Padding inside the card
  final EdgeInsetsGeometry padding;

  /// Margin outside the card
  final EdgeInsetsGeometry margin;

  /// Border radius of the card
  final double borderRadius;

  /// Background color of the card (defaults to dark navy blue)
  final Color? backgroundColor;

  /// Shadow color for bottom-right shadow (defaults to black)
  final Color? shadowColor;

  /// Highlight color for top-left (defaults to grey)
  final Color? highlightColor;

  /// Shadow offset amount
  final double shadowOffset;

  /// Shadow blur radius
  final double shadowBlur;

  /// Opacity of the top-left highlight gradient (0.0 - 1.0)
  final double highlightOpacity;

  /// Opacity of the bottom-right shadow gradient (0.0 - 1.0)
  final double shadowOpacity;

  /// Width of the border highlight
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? ColorsPallet.darkBlue;
    final shadow = shadowColor ?? const Color.fromARGB(115, 18, 20, 34);
    final highlight =
        highlightColor ?? const Color.fromARGB(255, 166, 227, 255);

    return Container(
      margin: margin,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        // 3D gradient overlay - light on top-left, dark on bottom-right
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerLeft,
          colors: [
            highlight.withOpacity(highlightOpacity),
            Colors.transparent,
            Colors.transparent,
            shadow.withOpacity(shadowOpacity),
          ],
          stops: const [0.0, 0.15, 0.08, 1.0],
        ),
      ),
      child: Container(
        padding: padding,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            // Bottom-right dark shadow for 3D depth (soft blur)
            BoxShadow(
              color: shadow.withOpacity(0.6),
              offset: Offset(shadowOffset, shadowOffset),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          // 3D gradient overlay - light on top-left, dark on bottom-right
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topCenter,
            colors: [
              highlight.withOpacity(highlightOpacity),
              Colors.transparent,
              Colors.transparent,
              shadow.withOpacity(shadowOpacity),
            ],
            stops: const [0.0, 0.15, 0.08, 1.0],
          ),
          // border: Border(
          //   top: BorderSide(
          //     color: highlight.withOpacity(0.3),
          //     width: borderWidth,
          //   ),
          //   left: BorderSide(
          //     color: highlight.withOpacity(0.3),
          //     width: borderWidth,
          //   ),
          //   bottom: BorderSide(
          //     color: shadow.withOpacity(0.5),
          //     width: borderWidth,
          //   ),
          //   right: BorderSide(
          //     color: shadow.withOpacity(0.5),
          //     width: borderWidth,
          //   ),
          // ),
        ),
        child: child,
      ),
    );
  }
}
