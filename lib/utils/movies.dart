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
    // Validate movie ID
    if (id == null || id.toString().isEmpty) {
      debugPrint('❌ Cannot fetch movie: ID is null or empty');
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Invalid movie ID. Please try again.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
      return;
    }

    EasyLoading.show();
    final controller = Get.find<MoviesController>();
    var movieFetch = await controller.fetchMovieDetails(id.toString());
    EasyLoading.dismiss();

    if (movieFetch == null || getIn(movieFetch, 'success', false) == false) {
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterieurement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
    } else {
      var movieData = getIn(movieFetch, 'movie', null);
      if (movieData is Map<String, dynamic>) {
        controller.selectedMovie.value = movieData;
        if (context.mounted) {
          Get.to(() => const MoviePage());
        }
      } else {
        if (context.mounted) {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: 'Invalid movie data received.',
            btnOkOnPress: () {},
          ).show();
        }
      }
    }
  } catch (e) {
    EasyLoading.dismiss();
    debugPrint("movieFetchAndRedirect try catch error:$e");
  }
}

Future<void> movieFetchAndRedirectPlayer(id, BuildContext context) async {
  try {
    // Validate movie ID
    if (id == null || id.toString().isEmpty) {
      debugPrint('❌ Cannot fetch movie: ID is null or empty');
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Invalid movie ID. Please try again.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
      return;
    }

    EasyLoading.show();
    final controller = Get.find<MoviesController>();
    var movieFetch = await controller.fetchMovieDetails(id.toString());
    EasyLoading.dismiss();

    if (movieFetch == null || getIn(movieFetch, 'success', false) == false) {
      if (context.mounted) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          desc:
              'Une erreur est survenue, veuillez réessayer ulterieurement ou contacter le support si le problème persiste.',
          btnOkOnPress: () {},
          btnOk: PrimaryButton(
            onPressed: () => {Navigator.of(context).pop()},
            text: 'Close',
          ),
        ).show();
      }
    } else {
      var movieData = getIn(movieFetch, 'movie', null);
      if (movieData is Map<String, dynamic>) {
        controller.selectedMovie.value = movieData;
        if (context.mounted) {
          Get.to(() => const MoviePlayPage());
        }
      } else {
        if (context.mounted) {
          await AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: 'Invalid movie data received.',
            btnOkOnPress: () {},
          ).show();
        }
      }
    }
  } catch (e) {
    EasyLoading.dismiss();
    debugPrint("movieFetchAndRedirectPlayer try catch Error: $e");
  }
}
