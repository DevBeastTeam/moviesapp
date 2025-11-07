import 'package:flutter/material.dart';

import '../../../constants/screenssize.dart';
import '../../../theme/colors.dart';

class FilmTabBtnWidget extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const FilmTabBtnWidget({
    super.key,
    this.label = "Tab Name",
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Screen.width(context) * 0.02,
          vertical: 5,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: currentSubject == 'all'
          //       ? ColorsPallet.blueAccent
          //       : Colors.white,
          //   width: 1,
          // ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [ColorsPallet.filmsTabBgColor, Colors.black],
                )
              : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            '  $label  ',
            style: TextStyle(
              fontSize: 12,
              color: isActive ? ColorsPallet.lightBlueComponent : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
