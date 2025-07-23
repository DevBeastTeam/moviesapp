import 'package:edutainment/widgets/ui/primary_button.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class SuperDialog extends StatefulWidget {
  final EdgeInsetsGeometry contentPadding;

  final double? width;
  final double? height;

  final bool showTitle;
  final Widget titleText;

  final Widget content;

  final bool showActions;
  final bool showCancelButton;
  final Text cancelButtonText;
  final bool showConfirmButton;
  final String confirmButtonText;
  final List additionalActionsButtons;
  final String additionalActionsButtonsPosition;
  final Color? cancelButtonBackgroundColor;

  final Function()? cancelFn;
  final Function()? confirmationFn;

  const SuperDialog({
    super.key,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.width,
    this.height,
    this.showTitle = true,
    this.titleText = const Text(''),
    this.content = const Text(''),
    this.showActions = true,
    this.showCancelButton = true,
    this.cancelButtonText = const Text('Close'),
    this.cancelFn,
    this.cancelButtonBackgroundColor,
    this.showConfirmButton = true,
    this.confirmButtonText = 'Validate',
    this.confirmationFn,
    this.additionalActionsButtons = const [],
    this.additionalActionsButtonsPosition = 'after',
  });

  @override
  SuperDialogState createState() => SuperDialogState();
}

class SuperDialogState extends State<SuperDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Question!'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorsPallet.darkBlue,
      ),
      body: Container(
        padding: widget.contentPadding,
        decoration: const BoxDecoration(color: ColorsPallet.darkBlue),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showTitle) widget.titleText,
            const SizedBox(height: 24),
            Container(
              width: MediaQuery.of(context).size.width,
              height: widget.height,
              color: ColorsPallet.darkBlue,
              child: widget.content,
            ),
            const SizedBox(height: 24),
            if (widget.showActions)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showCancelButton)
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            widget.cancelButtonBackgroundColor ??
                            ColorsPallet.darkBlue,
                      ),
                      onPressed:
                          widget.cancelFn ??
                          () {
                            Navigator.pop(context);
                          },
                      child: widget.cancelButtonText,
                    ),
                  if (widget.additionalActionsButtons.isNotEmpty &&
                      widget.additionalActionsButtonsPosition == 'before')
                    for (var btn in widget.additionalActionsButtons) btn,
                  if (widget.showConfirmButton)
                    PrimaryButton(
                      onPressed:
                          widget.confirmationFn ??
                          () {
                            Navigator.pop(context);
                          },
                      text: widget.confirmButtonText,
                    ),
                  if (widget.additionalActionsButtons.isNotEmpty &&
                      widget.additionalActionsButtonsPosition == 'after')
                    for (var btn in widget.additionalActionsButtons) btn,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
