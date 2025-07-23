import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';

import '../../../widgets/ui/super_dialog.dart';
import 'question.dart';

class QuestionDialog extends StatefulWidget {
  const QuestionDialog({
    super.key,
    required this.question,
    required this.onSave,
  });

  final dynamic question;
  final Function(dynamic) onSave;

  @override
  State<QuestionDialog> createState() => _QuestionDialog();
}

class _QuestionDialog extends State<QuestionDialog> {
  late bool isShown = true;
  late dynamic answer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    answer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New question!😏'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsPallet.darkBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(color: ColorsPallet.darkBlue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            QuestionContent(
              onSelectAnswer: (answerSelected) {
                setState(() {
                  answer = answerSelected;
                });
                Navigator.of(context).pop();
                widget.onSave(answer);
              },
              question: widget.question,
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (answer != null)
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onSave(answer);
                    },
                    text: 'Validate',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
    return SuperDialog(
      showTitle: false,
      showCancelButton: false,
      showConfirmButton: answer != null,
      content: QuestionContent(
        onSelectAnswer: (answerSelected) {
          setState(() {
            answer = answerSelected;
          });
          Navigator.of(context).pop();
          widget.onSave(answer);
        },
        question: widget.question,
      ),
      confirmationFn: () {
        Navigator.of(context).pop();
        widget.onSave(answer);
      },
    );
  }
}
