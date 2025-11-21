import '../pages/movies/movie_play_page.dart';
import '../pages/movies/movie_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../controllers/movies_controller.dart';

import '../widgets/ui/custom_button.dart';
import '../widgets/ui/primary_button.dart';
import 'utils.dart';

Widget buildMovieFrame({
  required movie,
  required BuildContext context,
  String? from,
  bool fullSize = false,
  bool showPlayerLogo = false,
}) {
  return Container(
    margin: fullSize ? null : EdgeInsets.only(top: 8, right: 8, bottom: 16),
    child: CustomButton(
      marginEnd: false,
      splashColor: Colors.white.withOpacity(.1),
      highlightColor: Colors.white.withOpacity(.09),
      onPressed: () async {
        if (from == 'search') {
          await movieFetchAndRedirectPlayer(getIn(movie, '_id'), context);
        } else {
          await movieFetchAndRedirect(getIn(movie, '_id'), context);
        }
      },
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: fullSize ? null : 92,
          width: fullSize ? null : 163,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: getIn(movie, 'picture', ''),
                placeholder: (context, url) => const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              showPlayerLogo
                  ? Image.asset(
                      AppImages.playerlight,
                      opacity: AlwaysStoppedAnimation(0.5),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> movieFetchAndRedirect(id, BuildContext context) async {
  try {
    EasyLoading.show();
    final controller = Get.find<MoviesController>();
    var movieFetch = await controller.fetchMovieDetails(id.toString());
    EasyLoading.dismiss();

    if (getIn(movieFetch, 'success') == false) {
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
    } else {
      // Update controller state instead of Hive
      controller.selectedMovie.value = getIn(movieFetch, 'movie');
      // We might also want to store historyMovie if needed
      // controller.historyMovie.value = getIn(movieFetch, 'historyMovie');

      if (context.mounted) {
        Get.to(() => const MoviePage());
      }
    }
  } catch (e) {
    EasyLoading.dismiss();
    debugPrint("movieFetchAndRedirect try catch error:$e");
  }
}

Future<void> movieFetchAndRedirectPlayer(id, BuildContext context) async {
  try {
    EasyLoading.show();
    final controller = Get.find<MoviesController>();
    var movieFetch = await controller.fetchMovieDetails(id.toString());
    EasyLoading.dismiss();

    if (getIn(movieFetch, 'success') == false) {
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterierement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
    } else {
      controller.selectedMovie.value = getIn(movieFetch, 'movie');
      if (context.mounted) {
        Get.to(() => const MoviePlayPage());
      }
    }
  } catch (e) {
    EasyLoading.dismiss();
    debugPrint("movieFetchAndRedirectPlayer try catch Error: $e");
  }
}
