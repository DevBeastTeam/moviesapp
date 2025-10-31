import 'package:edutainment/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:humanize_duration/humanize_duration.dart';

import '../../../theme/colors.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/assets/assets_icons.dart';
import '../../../widgets/icon/gradient_icon.dart';

class ProfileStatistics extends StatelessWidget {
  const ProfileStatistics({
    super.key,
    required this.user,
    required this.statistics,
  });

  final dynamic user;
  final dynamic statistics;

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);

    if (screen.isTablet && screen.isLandscape) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        width: screen.width * 0.6,
        height: screen.height * 0.33,
        decoration: BoxDecoration(
          color: ColorsPallet.borderCardBgColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: 1,
            color: ColorsPallet.borderCardBorderColor,
          ),
        ),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            controller: ScrollController(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildComponent(
                    text: 'COMPLETED QUESTIONS',
                    value: '${getIn(statistics, 'questions', 0)}',
                    icon: EdutainmentIcons.question,
                    iconSize: 25,
                    colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                  ),
                  _buildComponent(
                    text: 'VALIDATED QUESTIONS',
                    value: '${getIn(statistics, 'questions_validated', 0)}',
                    icon: EdutainmentIcons.check,
                    iconSize: 25,
                    colors: const [Color(0xff1df370), Color(0xff2589e0)],
                  ),
                  _buildComponent(
                    text: 'TIME SPENT',
                    value: humanizeDuration(
                      Duration(seconds: getIn(statistics, 'time', 0)),
                    ),
                    iconSize: 25,
                    icon: EdutainmentIcons.clock,
                    colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                  ),
                ],
              ),
              const Divider(color: Colors.transparent, height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildComponent(
                    text: 'FINISHED MOVIES',
                    value: '${getIn(statistics, 'movies', 0)}',
                    icon: EdutainmentIcons.movie,
                    iconSize: 25,
                    colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                  ),
                  _buildComponent(
                    text: 'PASSED TESTS',
                    value: '${getIn(statistics, 'quizz', 0)}',
                    icon: EdutainmentIcons.validateTest,
                    iconSize: 25,
                    colors: const [Color(0xff1df370), Color(0xff2589e0)],
                  ),
                  _buildComponent(
                    text: 'COMPLETED LESSONS',
                    value: '${getIn(statistics, 'lessons', 0)}',
                    icon: EdutainmentIcons.validateLesson,
                    iconSize: 25,
                    colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (screen.isTablet && !screen.isLandscape) {
      return Container(
        margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
        padding: const EdgeInsets.all(10),
        width: screen.width * 0.47,
        height: screen.height * 0.7,
        decoration: BoxDecoration(
          color: ColorsPallet.borderCardBgColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            width: 1,
            color: ColorsPallet.borderCardBorderColor,
          ),
        ),
        child: Column(
          // shrinkWrap: true,
          // controller: ScrollController(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildComponent(
                  text: 'COMPLETED QUESTIONS',
                  value: '${getIn(statistics, 'questions', 0)}',
                  icon: EdutainmentIcons.question,
                  colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                ),
                _buildComponent(
                  text: 'VALIDATED QUESTIONS',
                  value: '${getIn(statistics, 'questions_validated', 0)}',
                  icon: EdutainmentIcons.check,
                  colors: const [Color(0xff1df370), Color(0xff2589e0)],
                ),
              ],
            ),
            const Divider(color: Colors.transparent, height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                _buildComponent(
                  text: 'TIME SPENT',
                  value: humanizeDuration(
                    Duration(seconds: getIn(statistics, 'time', 0)),
                  ),
                  icon: EdutainmentIcons.clock,
                  colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
                ),
                _buildComponent(
                  text: 'FINISHED MOVIES',
                  value: '${getIn(statistics, 'movies', 0)}',
                  icon: EdutainmentIcons.movie,
                  colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                ),
              ],
            ),
            const Divider(color: Colors.transparent, height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildComponent(
                  text: 'PASSED TESTS',
                  value: '${getIn(statistics, 'quizz', 0)}',
                  icon: EdutainmentIcons.validateTest,
                  colors: const [Color(0xff1df370), Color(0xff2589e0)],
                ),
                _buildComponent(
                  text: 'COMPLETED LESSONS',
                  value: '${getIn(statistics, 'lessons', 0)}',
                  icon: EdutainmentIcons.validateLesson,
                  colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
                ),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      margin: screen.isLandscape
          ? const EdgeInsets.all(8)
          : const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorsPallet.borderCardBgColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(width: 1, color: ColorsPallet.borderCardBorderColor),
      ),
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
              _buildComponent(
                text: 'COMPLETED QUESTIONS',
                value: '${getIn(statistics, 'questions', 0)}',
                icon: EdutainmentIcons.question,
                colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
              ),
              _buildComponent(
                text: 'VALIDATED QUESTIONS',
                value: '${getIn(statistics, 'questions_validated', 0)}',
                icon: EdutainmentIcons.check,
                colors: const [Color(0xff1df370), Color(0xff2589e0)],
              ),
            ],
          ),
          const Divider(color: Colors.transparent, height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildComponent(
                text: 'TIME SPENT',
                value: humanizeDuration(
                  Duration(seconds: getIn(statistics, 'time', 0)),
                ),
                icon: EdutainmentIcons.clock,
                colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
              ),
              _buildComponent(
                text: 'FINISHED MOVIES',
                value: '${getIn(statistics, 'movies', 0)}',
                icon: EdutainmentIcons.movie,
                colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
              ),
            ],
          ),
          const Divider(color: Colors.transparent, height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildComponent(
                text: 'PASSED TESTS',
                value: '${getIn(statistics, 'quizz', 0)}',
                icon: EdutainmentIcons.validateTest,
                colors: const [Color(0xff1df370), Color(0xff2589e0)],
              ),
              _buildComponent(
                text: 'COMPLETED LESSONS',
                value: '${getIn(statistics, 'lessons', 0)}',
                icon: EdutainmentIcons.validateLesson,
                colors: const [Color(0xfffaeb48), Color(0xffe83e3b)],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComponent({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required String value,
    double iconSize = 47,
  }) {
    return SizedBox(
      width: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientIcon(
            icon: icon,
            size: iconSize,
            gradient: LinearGradient(colors: colors),
          ),
          const Divider(color: Colors.transparent, height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.first,
            ),
          ),
          const Divider(color: Colors.transparent, height: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String str in text.split(' '))
                Text(
                  str,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
