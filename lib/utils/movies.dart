import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../core/loader.dart';
import '../widgets/ui/custom_button.dart';
import '../widgets/ui/primary_button.dart';
import 'boxes.dart';
import 'utils.dart';

Widget buildMovieFrame(
    {required movie, required BuildContext context, String? from}) {
  return Container(
    margin: const EdgeInsets.only(top: 8, right: 8, bottom: 16),
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
          height: 92,
          width: 163,
          child: CachedNetworkImage(
            imageUrl: getIn(movie, 'picture', ''),
            placeholder: (context, url) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    ),
  );
}

Future<void> movieFetchAndRedirect(id, BuildContext context) async {
  EasyLoading.show();
  var movieFetch = await fetchMovie(id);
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
          )).show();
    }
  } else {
    await moviesBox.put('movie', getIn(movieFetch, 'movie'));
    await moviesBox.put('historyMovie', getIn(movieFetch, 'historyMovie'));
    if (context.mounted) {
      context.push('/movies/movie');
    }
  }
}

Future<void> movieFetchAndRedirectPlayer(id, BuildContext context) async {
  EasyLoading.show();
  var movieFetch = await fetchMovie(id);
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
          )).show();
    }
  } else {
    await moviesBox.put('movie', getIn(movieFetch, 'movie'));
    await moviesBox.put('historyMovie', getIn(movieFetch, 'historyMovie'));
    if (context.mounted) {
      context.go('/movies/movie/player');
    }
  }
}
