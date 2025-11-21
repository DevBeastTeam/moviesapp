import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/appimages.dart';
import '../../pages/home/home_page.dart';
import '../../pages/movies/movies_page.dart';
import '../../pages/search/search_page.dart';
import '../../pages/tests/tests_page.dart';

class TopBarWidget extends StatelessWidget {
  final bool showProfileButton;
  final bool showMoviesButton;
  final bool showSearchButton;
  final bool showTestButton;
  final double paddingLeft;
  const TopBarWidget({
    super.key,
    this.paddingLeft = 5,
    this.showProfileButton = true,
    this.showMoviesButton = true,
    this.showSearchButton = false,
    this.showTestButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: paddingLeft),
        Image.asset(AppImages.lion, width: 25),
        Text(
          ' E-DUTAINMENT  ',
          style: TextStyle(
            fontFamily: 'Football Attack',
            color: Colors.white,
            height: 0,
            fontWeight: Theme.of(context).textTheme.titleLarge?.fontWeight!,
            fontSize: 20,
          ),
        ),
        if (showProfileButton)
          TextButton(
            onPressed: () {
              Get.to(() => const HomePage());
            },
            child: Text("PROFILES"),
          ),
        if (showMoviesButton)
          TextButton(
            onPressed: () {
              Get.to(() => const MoviesPage());
            },
            child: Text("FILMS"),
          ),
        if (showSearchButton)
          TextButton(
            onPressed: () {
              Get.to(() => const SearchPage());
            },
            child: Text("SEARCH"),
          ),
        if (showTestButton)
          TextButton(
            onPressed: () {
              Get.to(() => const TestsPage());
            },
            child: Text("TEST"),
          ),
      ],
    );
  }
}
