import 'package:edutainment/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/boxes.dart';
import '../../widgets/ui/default_scaffold.dart';
import 'profile/badges.dart';
import 'profile/buttons.dart';
import 'profile/header.dart';
import 'profile/progress.dart';
import 'profile/statistics.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  // final dynamic userData = userBox.get('data');
  final dynamic statisticsData = statisticsBox.get('data');
  final dynamic badgesData = badgesBox.get('data');
  final dynamic historyBadgesData = badgesBox.get('history');

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userProvider);
    return DefaultScaffold(
      currentPage: 'profile',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileHeader(user: userData),
                ProfileProgress(user: userData),
                ProfileStatistics(user: userData, statistics: statisticsData),
                const ProfileButtons(),
                ProfileBadges(
                  badges: badgesData,
                  historyBadges: historyBadgesData,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
