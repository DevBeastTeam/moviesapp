import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    super.key,
    required this.width,
    required this.child,
    required this.onPressed,
  });

  final double width;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
        elevation: WidgetStateProperty.all<double>(0),
        overlayColor: WidgetStateProperty.all<Color>(
          ColorsPallet.darkBlue.withOpacity(.2),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: ColorsPallet.dbba,
            begin: FractionalOffset.topLeft,
          ),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: ColorsPallet.darkBlue.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 7,
                offset: const Offset(6, 3),
              ),
              BoxShadow(
                color: ColorsPallet.darkBlue.withOpacity(0.1),
                spreadRadius: 0.1,
                blurRadius: 7,
                offset: const Offset(-6, -3),
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: width, minHeight: 50.0),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
