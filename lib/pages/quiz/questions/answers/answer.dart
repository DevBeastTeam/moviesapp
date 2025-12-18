import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:flutter/material.dart';

class AnswerContent extends StatelessWidget {
  const AnswerContent({
    super.key,
    required this.answer,
    required this.answerIndex,
    this.active = false,
    this.isInLandScapeMode = false,
  });

  final dynamic answer;
  final int answerIndex;

  final bool active;
  final bool isInLandScapeMode;

  @override
  Widget build(BuildContext context) {
    final allowedLetter = ['A', 'B', 'C', 'D', 'E'];

    return Card3D(
      child: Container(
        width: Screen.isPhone(context)
            ? Screen.width(context) * 0.9
            : Screen.width(context) * 0.5,
        height: 70,
        // margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorsPallet.darkBlue,
          // color: active ? ColorsPallet.blueAccent : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  answer['label'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isInLandScapeMode ? 16 : 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    // color: active ? Colors.white : ColorsPallet.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
