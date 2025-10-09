import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/pages/ponounciations/pselectcatg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/colors.dart';
import '../../../utils/assets/assets_icons.dart';
import '../../../widgets/icon/gradient_icon.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
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
                  text: 'GRAMMAR',
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
                    text: 'Ai CHAT',
                    assetImg: AppImages.ai2,
                    isImg: true,
                    // icon: EdutainmentIcons.writing,
                    colors: const [Color(0xff02eac1), Color(0xff2992f9)],
                    onPressed: () {
                      // context.go('/home/ai');
                      context.go('/home/ai/aichat');
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => const PeonounciationsPage(),
                          // builder: (context) => const PlevelsPage(),
                          builder: (context) => const PSelectCatgPage(),
                        ),
                      );
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
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                // SizedBox.fromSize(size: const Size(8, 8)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: _buildComponent(
                    context: context,
                    text: 'FLASHCARDS',
                    assetImg: AppImages.flashcards,
                    isImg: true,
                    colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                    onPressed: () {
                      context.go('/home/fc'); 
                    },
                  ),
                ),
              ],
            ),
          ),
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
          color: ColorsPallet.darkComponentBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isImg
                ? Image.asset(assetImg ?? "", width: 70)
                : GradientIcon(
                    icon: icon!,
                    size: 80,
                    gradient: LinearGradient(colors: colors),
                  ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
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
