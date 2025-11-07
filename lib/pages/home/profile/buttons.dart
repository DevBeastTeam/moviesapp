import 'package:edutainment/constants/appimages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/colors.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/assets/assets_icons.dart';
import '../../../widgets/icon/gradient_icon.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    if (screen.isTablet && screen.isLandscape) {
      return SizedBox(
        height: screen.height * 0.35,
        width: screen.width * 0.35,
        child: GridView(
          shrinkWrap: true,
          controller: ScrollController(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          padding: const EdgeInsets.all(8),
          children: [
            _buildComponent(
              context: context,
              text: 'COPILOT',
              assetImg: AppImages.ai2,
              isImg: true,
              imgSize: 45,
              fontSize: 11,
              // icon: EdutainmentIcons.writing,
              colors: const [Color(0xff02eac1), Color(0xff2992f9)],
              onPressed: () {
                context.go('/home/AIMenuPage');
              },
            ),
            _buildComponent(
              fontSize: 11,
              context: context,
              text: 'PRONUNCIATION',
              imgSize: 45,
              icon: EdutainmentIcons.pronunciation,
              colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
              onPressed: () {
                context.go('/home/PronlevelsPage1');
              },
            ),
            // _buildComponent(
            // fontSize: 11,
            //   context: context,
            //   text: 'FLASHCARDS',
            //   assetImg: AppImages.flashcards,
            //   isImg: true,
            // imgSize: 45,
            //   colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
            //   onPressed: () {
            //     context.go('/home/fc');
            //   },
            // ),
            _buildComponent(
              fontSize: 11,
              context: context,
              // text: 'GRAMMAR',
              text: 'LESSONS',
              imgSize: 45,
              icon: EdutainmentIcons.grammar,
              colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
              onPressed: () async {
                context.go('/home/GrammerPage');
              },
            ),
            _buildComponent(
              fontSize: 11,
              context: context,
              text: 'EXERCISES',
              imgSize: 45,
              icon: EdutainmentIcons.exercices,
              colors: const [Color(0xfffd6378), Color(0xffa11111)],
              onPressed: () {
                context.go('/home/ExcersisesPage');
              },
            ),
          ],
        ),
      );
    }
    if (screen.isTablet && !screen.isLandscape) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        decoration: BoxDecoration(
          // color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        width: screen.width * 0.43,
        height: screen.width * 0.43,
        child: GridView(
          shrinkWrap: true,
          controller: ScrollController(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: screen.isLandscape ? 1.5 : 1.1,
          ),
          padding: const EdgeInsets.all(8),
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsPallet.borderCardBgColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  width: 1,
                  color: ColorsPallet.borderCardBorderColor,
                ),
              ),
              child: _buildComponent(
                context: context,
                text: 'EXERCISES',
                icon: EdutainmentIcons.exercices,
                colors: const [Color(0xfffd6378), Color(0xffa11111)],
                onPressed: () {
                  context.go('/home/ExcersisesPage');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsPallet.borderCardBgColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  width: 1,
                  color: ColorsPallet.borderCardBorderColor,
                ),
              ),
              child: _buildComponent(
                context: context,
                // text: 'GRAMMAR',
                text: 'LESSONS',
                icon: EdutainmentIcons.grammar,
                colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                onPressed: () async {
                  context.go('/home/GrammerPage');
                },
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: ColorsPallet.borderCardBgColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  width: 1,
                  color: ColorsPallet.borderCardBorderColor,
                ),
              ),
              child: _buildComponent(
                context: context,
                text: 'COPILOT',
                assetImg: AppImages.ai2,
                isImg: true,
                // icon: EdutainmentIcons.writing,
                colors: const [Color(0xff02eac1), Color(0xff2992f9)],
                onPressed: () {
                  context.go('/home/AIMenuPage');
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsPallet.borderCardBgColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  width: 1,
                  color: ColorsPallet.borderCardBorderColor,
                ),
              ),
              child: _buildComponent(
                context: context,
                text: 'PRONUNCIATION',
                icon: EdutainmentIcons.pronunciation,
                colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                onPressed: () {
                  context.go('/home/PronlevelsPage1');
                },
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: ColorsPallet.darkComponentBackground,
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: _buildComponent(
            //     context: context,
            //     text: 'FLASHCARDS',
            //     assetImg: AppImages.flashcards,
            //     isImg: true,
            //     colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
            //     onPressed: () {
            //       context.go('/home/fc');
            //     },
            //   ),
            // ),
          ],
        ),
      );
    }
    return Container(
      margin: screen.isLandscape
          ? const EdgeInsets.all(8)
          : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _buildComponent(
                  context: context,
                  // text: 'GRAMMAR',
                  text: 'LESSONS',
                  icon: EdutainmentIcons.grammar,
                  colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                  onPressed: () async {
                    // Provider.of(context, listen: false).
                    // await context
                    //     .watch<grammerData>()
                    //     .getGrammersF(context);

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const GrammerPage(),
                    //   ),
                    // );

                    context.go('/home/GrammerPage');

                    ///// api calles
                    // await Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             const GrammarPage()));

                    // AwesomeDialog(
                    //     context: context,
                    //     dialogType: DialogType.info,
                    //     title: '',
                    //     desc: 'Coming soon',
                    //     btnOkOnPress: () {},
                    //     btnOk: PrimaryButton(
                    //       onPressed: () =>
                    //           {Navigator.of(context).pop()},
                    //       text: 'Close',
                    //     )).show();
                  },
                ),
              ),
              SizedBox.fromSize(size: const Size(8, 8)),
              Expanded(
                child: _buildComponent(
                  context: context,
                  text: 'EXERCISES',
                  icon: EdutainmentIcons.exercices,
                  colors: const [Color(0xfffd6378), Color(0xffa11111)],
                  onPressed: () {
                    context.go('/home/ExcersisesPage');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ExcersisesPage(),
                    //   ),
                    // );
                    // AwesomeDialog(
                    //         context: context,
                    //         dialogType: DialogType.info,
                    //         title: '',
                    //         desc: 'Coming soon',
                    //         btnOkOnPress: () {},
                    //         btnOk: PrimaryButton(
                    //             onPressed: () =>
                    //                 {Navigator.of(context).pop()},
                    //             text: 'Close'))
                    //     .show();
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildComponent(
                    context: context,
                    text: 'COPILOT',
                    assetImg: AppImages.ai2,
                    isImg: true,
                    // icon: EdutainmentIcons.writing,
                    colors: const [Color(0xff02eac1), Color(0xff2992f9)],
                    onPressed: () {
                      // context.go('/home/ai');
                      // context.go('/home/AIMenuPage/AIChatPage');
                      context.go('/home/AIMenuPage');
                    },
                  ),
                ),
                SizedBox.fromSize(size: const Size(8, 8)),
                Expanded(
                  child: _buildComponent(
                    context: context,
                    text: 'PRONUNCIATION',
                    icon: EdutainmentIcons.pronunciation,
                    colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                    onPressed: () {
                      context.go('/home/PronlevelsPage1');
                      // ref.watch(pronounciationVm).getPronounciationF();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     // builder: (context) => const PeonounciationsPage(),
                      //     builder: (context) => const PronlevelsPage(),
                      //     // builder: (context) => const PSelectCatgPage(),
                      //   ),
                      // );

                      // AwesomeDialog(
                      //         context: context,
                      //         dialogType: DialogType.info,
                      //         title: '',
                      //         desc: 'Coming soon',
                      //         btnOkOnPress: () {},
                      //         btnOk: PrimaryButton(
                      //             onPressed: () =>
                      //                 {Navigator.of(context).pop()},
                      //             text: 'Close'))
                      //     .show();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 8),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     // mainAxisSize: MainAxisSize.min,
          //     children: [
          //       // SizedBox.fromSize(size: const Size(8, 8)),
          //       SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.42,
          //         child: _buildComponent(
          //           context: context,
          //           text: 'FLASHCARDS',
          //           assetImg: AppImages.flashcards,
          //           isImg: true,
          //           colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
          //           onPressed: () {
          //             context.go('/home/fc');
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildComponent({
    required BuildContext context,
    required String text,
    IconData? icon,
    String? assetImg,
    required List<Color> colors,
    bool isImg = false,
    required VoidCallback onPressed,
    double imgSize = 70,
    double fontSize = 14,
  }) {
    return RawMaterialButton(
      hoverElevation: 0,
      elevation: 0,
      focusElevation: 0,
      splashColor: Colors.white.withOpacity(.1),
      highlightColor: Colors.white.withOpacity(.09),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          color: ColorsPallet.borderCardBgColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: 1,
            color: ColorsPallet.borderCardBorderColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isImg
                ? Image.asset(assetImg ?? "", width: imgSize)
                : GradientIcon(
                    icon: icon!,
                    size: imgSize,
                    gradient: LinearGradient(colors: colors),
                  ),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
