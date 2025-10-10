import 'package:edutainment/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:humanize_duration/humanize_duration.dart';

import '../../../theme/colors.dart';
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
     var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    bool isTablet = w > 450 ? true : false;
    
    if(isTablet){
          return Container(
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
      padding: const EdgeInsets.all(10),
      width: w* 0.3,
      height: w* 0.3,
      decoration: BoxDecoration(
        color: ColorsPallet.darkComponentBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        shrinkWrap: true,
        controller: ScrollController(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildComponentForTablet(
                text: 'COMPLETED QUESTIONS',
                value: '${getIn(statistics, 'questions', 0)}',
                icon: EdutainmentIcons.question,
                colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
              ),
              _buildComponentForTablet(
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
              _buildComponentForTablet(
                text: 'TIME SPENT',
                value: humanizeDuration(
                  Duration(seconds: getIn(statistics, 'time', 0)),
                ),
                icon: EdutainmentIcons.clock,
                colors: const [Color(0xffF82BD6), Color(0xff4F0AE1)],
              ),
              _buildComponentForTablet(
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
              _buildComponentForTablet(
                text: 'PASSED TESTS',
                value: '${getIn(statistics, 'quizz', 0)}',
                icon: EdutainmentIcons.validateTest,
                colors: const [Color(0xff1df370), Color(0xff2589e0)],
              ),
              _buildComponentForTablet(
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
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: ColorsPallet.darkComponentBackground,
        borderRadius: BorderRadius.circular(32),
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

    Widget _buildComponentForTablet({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required String value,
  }) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GradientIcon(
            icon: icon,
            size: 30,
            gradient: LinearGradient(colors: colors),
          ),
          const Divider(color: Colors.transparent, height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
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
                    fontSize: 8,
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



  Widget _buildComponent({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required String value,
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
            size: 48,
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
