import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/appimages.dart';

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
              context.go("/home");
            },
            child: Text("PROFILES"),
          ),
        if (showMoviesButton)
          TextButton(
            onPressed: () {
              context.go("/movies");
            },
            child: Text("FILMS"),
          ),
        if (showSearchButton)
          TextButton(
            onPressed: () {
              context.go("/search");
            },
            child: Text("SEARCH"),
          ),
        if (showTestButton)
          TextButton(
            onPressed: () {
              context.go("/tests");
            },
            child: Text("TEST"),
          ),
      ],
    );
  }
}
