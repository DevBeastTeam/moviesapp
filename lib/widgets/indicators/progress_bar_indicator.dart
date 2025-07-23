import 'package:flutter/material.dart';

class ProgressBarIndicator extends StatelessWidget {
  const ProgressBarIndicator({
    super.key,
    this.progressColor = Colors.white,
    this.text,
  });

  final Color progressColor;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            LinearProgressIndicator(
              color: progressColor,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
        if (text != null)
          Container(
            margin: const EdgeInsets.only(top: 20),
            width: 350,
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
