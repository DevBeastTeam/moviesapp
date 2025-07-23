import 'package:edutainment/theme/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.text = '',
    this.onPressed,
    this.colors,
    this.radius = 10,
  });

  final String text;
  final Function? onPressed;
  final List<Color>? colors;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        if (onPressed != null) {onPressed!()},
      },
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors ?? [ColorsPallet.darkBlue, ColorsPallet.blueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: ColorsPallet.darkBlue.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 7,
                offset: const Offset(6, 3), // changes position of shadow
              ),
              BoxShadow(
                color: ColorsPallet.darkBlue.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 7,
                offset: const Offset(-6, -3), // changes position of shadow
              ),
            ],
          ),
          constraints: const BoxConstraints(
            // maxWidth: (mediaWidth * 0.8 > 200 ? 200 : mediaWidth * 0.8),
            minHeight: 50.0,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize!,
            ),
          ),
        ),
      ),
    );
  }
}
