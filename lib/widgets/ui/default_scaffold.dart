import 'package:edutainment/widgets/ui/floating_question_button.dart';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/assets/assets_icons.dart';
import '../../utils/boxes.dart';
import '../../widgets/bottom_bar/custom_bottom_bar.dart';

class DefaultScaffold extends StatelessWidget {
  const DefaultScaffold({
    super.key,
    required this.child,
    this.bgWidget,
    required this.currentPage,
    this.hideBottomBar = false,
    this.customBgColors,
    this.drawer = const Drawer(),
    this.isShowDrawer = false,
    this.floatingBtn,
  });

  final Widget? bgWidget;
  final Widget child;
  final String currentPage;
  final bool hideBottomBar;
  final List<Color>? customBgColors;
  final Widget? drawer;
  final bool isShowDrawer;
  final Widget? floatingBtn;

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;

    var floatingQuestionAllowed =
        configBox.get('floatingQuestionAllowed') ?? false;

    return Scaffold(
      drawer: isShowDrawer ? drawer : null,
      body: Stack(
        children: [
          bgWidget ??
              Container(
                width: mediaWidth,
                height: mediaHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: customBgColors ?? ColorsPallet.bdb,
                  ),
                ),
              ),
          SafeArea(
            bottom: false,
            child: CustomBottomBar(
              height: 60,
              backgroundColor: Colors.black87,
              hideBottomBar: hideBottomBar,
              items: [
                BottomBarItem(
                  width: mediaWidth / 4.5,
                  height: 40,
                  icon: EdutainmentIcons.profile,
                  selected: currentPage == 'profile',
                  path: 'home',
                  text: 'Profile',
                ),
                BottomBarItem(
                  width: mediaWidth / 4.5,
                  height: 40,
                  icon: EdutainmentIcons.clapper,
                  selected: currentPage == 'movies',
                  path: 'movies',
                  text: 'Movies',
                ),
                BottomBarItem(
                  width: mediaWidth / 4.5,
                  height: 40,
                  icon: EdutainmentIcons.search,
                  selected: currentPage == 'search',
                  path: 'search',
                  text: 'Search',
                ),
                BottomBarItem(
                  width: mediaWidth / 4.5,
                  height: 40,
                  icon: EdutainmentIcons.flask,
                  selected: currentPage == 'tests',
                  path: 'tests',
                  text: 'Tests',
                ),
                // BottomBarItem(width: mediaWidth / 5.5, height: 40, icon: FontAwesomeIcons.gear, text: 'Tests')
              ],
              child: child,
            ),
          ),
        ],
      ),
      floatingActionButton:
          floatingQuestionAllowed && !hideBottomBar && currentPage == 'profile'
          ? const FloatingQuestionButton()
          : floatingBtn,
    );
  }
}
