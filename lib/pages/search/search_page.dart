import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/utils/assets/assets_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

import '../../icons/icons_light.dart';
import '../../utils/movies.dart';
import '../../utils/search.dart';
import '../../utils/utils.dart';
import '../../widgets/indicators/double_circular_progress_indicator.dart';
import '../../widgets/ui/default_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController wordController = TextEditingController();

  List<Widget> buildDefinitions(wordData, type) {
    var returnColumn = <Widget>[];
    var meaningValues = wordData['meanings'] ?? {};
    var meaningValuesKeys = meaningValues.keys;

    for (var mk in meaningValuesKeys) {
      var mkk = meaningValues[mk];
      final value = type == 'definitions'
          ? '${mkk[type]}'
          : '${mkk[type].join('')}';

      if (value.isNotEmpty) {
        returnColumn.addAll([
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$mk :',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 15, color: Colors.transparent),
        ]);
      }
    }
    return returnColumn;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return DefaultScaffold(
      currentPage: 'search',
      child: Column(
        children: [
          const SizedBox(height: 30), // Added top padding
          if (isTablet) const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ), // Added left and right padding
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: isTablet ? 20 : 10,
              ),
              constraints: isTablet
                  ? const BoxConstraints(maxWidth: 800)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsPallet.blueAccent.withOpacity(.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  controller: wordController,
                  decoration: const InputDecoration(
                    icon: Icon(AppIconsLight.magnifyingGlass),
                    labelText: 'Movies, Definitions, Extracts, ...',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),
          if (wordController.text != '')
            FutureBuilder(
              future: fetchWord(wordController.text),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const DoubleCircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  var result = snapshot.data;
                  var movies = getIn(result, 'movies', []);
                  if (movies.length > 15) {
                    movies = movies.sublist(0, 15);
                  }
                  final player = AudioPlayer();
                  return Expanded(
                    child: Center(
                      child: Container(
                        constraints: isTablet
                            ? const BoxConstraints(maxWidth: 900)
                            : null,
                        padding: const EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      getIn(result, 'wordData.phonetic', ''),
                                      style: GoogleFonts.notoSerif(
                                        textStyle: const TextStyle(
                                          fontSize: 18,
                                          color: ColorsPallet.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      EdutainmentIcons.playEdutainment,
                                    ),
                                    iconSize: 56.0,
                                    onPressed: () {
                                      player.setAudioSource(
                                        AudioSource.uri(
                                          Uri.parse(
                                            result['wordData']['audio'],
                                          ),
                                        ),
                                      );
                                      player.play();
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 20),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Definitions',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...buildDefinitions(
                                result['wordData'],
                                'definitions',
                              ),
                              const Divider(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Synonyms',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...buildDefinitions(
                                result['wordData'],
                                'synonyms',
                              ),
                              const Divider(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Antonyms',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...buildDefinitions(
                                result['wordData'],
                                'antonyms',
                              ),
                              const Divider(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Examples',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...buildDefinitions(
                                result['wordData'],
                                'examples',
                              ),
                              const Divider(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Films',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    for (var movie in movies)
                                      buildMovieFrame(
                                        movie: movie,
                                        context: context,
                                        from: 'search',
                                      ),
                                  ],
                                ),
                              ),
                              const Divider(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Extracts',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              for (var subtitle in result['subtitles'] ?? [])
                                GestureDetector(
                                  onTap: () async {
                                    await movieFetchAndRedirect(
                                      subtitle['content_reference'],
                                      context,
                                    );
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(24),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color:
                                          ColorsPallet.darkComponentBackground,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    height: 150,
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: getIn(
                                            subtitle,
                                            'content_picture',
                                            '',
                                          ),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    height: 150,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                      ),
                                                    ),
                                                  ),
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                                height: 150,
                                                width: 100,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        const VerticalDivider(
                                          width: 15,
                                          color: Colors.transparent,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  getIn(
                                                    subtitle,
                                                    'content_label',
                                                  ),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Divider(height: 10),
                                              Expanded(
                                                child: Text(
                                                  getIn(subtitle, 'text'),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: const DoubleCircularProgressIndicator(),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
