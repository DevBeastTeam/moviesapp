import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:flutter/material.dart';

import '../../widgets/indicators/double_circular_progress_indicator.dart';

class SplashScreenContent extends StatelessWidget {
  const SplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: Colors.black),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // AssetsImage.defaultIcon.toImage(
              //   width: mediaWidth * 0.4 > 250 ? 250 : mediaWidth * 0.4,
              // ),
              Image.asset(
                AppImages.playerlightfit,
                width: Screen.isPhone(context) && Screen.isLandscape(context)
                    ? Screen.width(context) * 0.2
                    : mediaWidth * 0.4 > 250
                    ? 250
                    : mediaWidth * 0.4,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  30,
                  Screen.isPhone(context) && Screen.isLandscape(context)
                      ? 0
                      : 50,
                  30,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 12; i++)
                      Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        child: Text(
                          'E-DUTAINMENT'.characters.elementAt(i),
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Football Attack',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  30,
                  Screen.isPhone(context) && Screen.isLandscape(context)
                      ? 15
                      : 50,
                  30,
                  0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 10; i++)
                      Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        child: Text(
                          'Chargement'.characters.elementAt(i),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Football Attack',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 20; i++)
                      Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        child: Text(
                          'des informations ...'.characters.elementAt(i),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Football Attack',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: Screen.isPhone(context) && Screen.isLandscape(context)
                      ? 20
                      : 50,
                ),
                child: const DoubleCircularProgressIndicator(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
