import 'package:edutainment/widgets/card_3d.dart';
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
    return isActive
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade700,
                  spreadRadius: 0,
                  blurRadius: 0.3,
                  offset: const Offset(0, 0.7),
                ),
              ],
            ),
            child: Card3D(
              child: InkWell(
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
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      '  $label  ',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsPallet.lightBlueComponent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
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
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  '  $label  ',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          );

    // InkWell(
    //   onTap: () {
    //     onTap?.call();
    //   },
    //   borderRadius: BorderRadius.circular(25),
    //   child: Container(
    //     padding: EdgeInsets.symmetric(
    //       horizontal: Screen.width(context) * 0.02,
    //       vertical: 5,
    //     ),
    //     margin: const EdgeInsets.symmetric(horizontal: 4),
    //     decoration: BoxDecoration(
    //       // border: Border.all(
    //       //   color: currentSubject == 'all'
    //       //       ? ColorsPallet.blueAccent
    //       //       : Colors.white,
    //       //   width: 1,
    //       // ),
    //       boxShadow: isActive
    //           ? [
    //               BoxShadow(
    //                 color: Colors.blue,
    //                 spreadRadius: 1,
    //                 blurRadius: 0,
    //                 offset: const Offset(1, 1),
    //               ),
    //             ]
    //           : null,
    //       // boxShadow: isActive
    //       //     ? [
    //       //         BoxShadow(
    //       //           color: Colors.black,
    //       //           spreadRadius: 1,
    //       //           blurRadius: 1,
    //       //           offset: const Offset(0, 1),
    //       //         ),
    //       //       ]
    //       //     : null,
    //       gradient: isActive
    //           ? LinearGradient(
    //               begin: Alignment.bottomCenter,
    //               end: Alignment.topCenter,
    //               colors: [
    //                 ColorsPallet.darkBlue,
    //                 const Color.fromARGB(255, 9, 30, 52),
    //               ],
    //             )
    //           : null,
    //       // gradient: isActive
    //       //     ? LinearGradient(
    //       //         begin: Alignment.bottomCenter,
    //       //         end: Alignment.topCenter,
    //       //         colors: [ColorsPallet.filmsTabBgColor, Colors.black],
    //       //       )
    //       //     : null,
    //       borderRadius: BorderRadius.circular(25),
    //     ),
    //     child: Center(
    //       child: Text(
    //         '  $label  ',
    //         style: TextStyle(
    //           fontSize: 12,
    //           color: isActive ? ColorsPallet.lightBlueComponent : Colors.white,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
