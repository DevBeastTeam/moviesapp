import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutainment/constants/appimages.dart';
import 'package:edutainment/constants/screenssize.dart';
import 'package:edutainment/theme/colors.dart';
import 'package:edutainment/widgets/card_3d.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/search_controller.dart' as search;
import '../../icons/icons_light.dart';
import '../../utils/movies.dart';
import '../../utils/utils.dart';
import '../../widgets/indicators/double_circular_progress_indicator.dart';
import '../../widgets/ui/default_scaffold.dart';
import '../movies/widgets/tabButtonWidget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final search.WordSearchController searchController = Get.put(
    search.WordSearchController(),
  );
  final TextEditingController wordController = TextEditingController();
  late TabController _tabController;
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    searchController.performSearch('ALL');
  }

  @override
  void dispose() {
    _tabController.dispose();
    wordController.dispose();
    player.dispose();
    super.dispose();
  }

  Widget buildDefinitionContent(String type) {
    final searchResult = searchController.searchResult.value;
    if (searchResult == null) return const SizedBox.shrink();

    var wordData = searchResult['wordData'] ?? {};
    var meaningValues = wordData['meanings'] ?? {};
    var meaningValuesKeys = meaningValues.keys;

    List<Widget> items = [];
    for (var mk in meaningValuesKeys) {
      var mkk = meaningValues[mk];
      final value = type == 'definitions'
          ? '${mkk[type] ?? ''}'
          : '${(mkk[type] ?? []).join(', ')}';

      if (value.isNotEmpty && value != 'null') {
        items.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$mk:',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        );
      }
    }

    return items.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          )
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return DefaultScaffold(
      currentPage: 'search',
      child: Column(
        children: [
          const SizedBox(height: 5),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: isTablet ? 7 : 7,
              ),
              constraints: isTablet
                  ? const BoxConstraints(maxWidth: 800)
                  : null,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white38),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  onSubmitted: (value) {
                    searchController.performSearch(value);
                  },
                  controller: wordController,
                  decoration: const InputDecoration(
                    icon: Icon(AppIconsLight.magnifyingGlass),
                    labelText: 'SEARCH',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
          ),

          // Category Tabs
          Obx(
            () => Container(
              height: 47,
              width: Screen.isTablet(context)
                  ? Screen.width(context) * 0.93
                  : Screen.width(context) * 0.9,
              decoration: BoxDecoration(
                color: ColorsPallet.filmsTabBgColor,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          [
                                "ALL",
                                "DEFINITIONS",
                                "PRONUNCIATION AND SENTENCES",
                                "FILMS",
                                "EXTRACTS",
                              ]
                              .map(
                                (e) => FilmTabBtnWidget(
                                  label: e,
                                  isActive:
                                      searchController.currentTab.value == e,
                                  onTap: () {
                                    searchController.updateTab(e);
                                    if (e == 'ALL') {
                                      searchController.clearSearch();
                                    }
                                    searchController.performSearch(e);
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Content Area
          Obx(() {
            if (searchController.isLoading.value) {
              return Container(
                margin: const EdgeInsets.only(top: 50),
                child: const DoubleCircularProgressIndicator(),
              );
            }

            if (searchController.searchResult.value == null) {
              return const SizedBox.shrink();
            }

            final searchResult = searchController.searchResult.value!;

            return Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isTablet
                    ? // TABLET LAYOUT - Custom Layout
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ROW 1: Definitions Box and Pronunciation Box
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Definitions/Synonyms/Antonyms Tabs
                              Expanded(
                                flex: 2,
                                child: Card3D(
                                  borderRadius: 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: const Color(0xFF1A2332),
                                      color: ColorsPallet.darkBlue,
                                      borderRadius: BorderRadius.circular(16),
                                      // border: Border.all(
                                      //   color: Colors.white24,
                                      //   width: 1,
                                      // ),
                                    ),
                                    child: Column(
                                      children: [
                                        // Tab Bar
                                        Container(
                                          decoration: const BoxDecoration(
                                            // color: Color(0xFF0D1520),
                                            color: ColorsPallet.darkBlue,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: TabBar(
                                            controller: _tabController,
                                            indicatorColor: Colors.transparent,
                                            // 0xFF60A5FA,
                                            indicatorWeight: 3,
                                            labelColor: const Color(0xFF60A5FA),
                                            unselectedLabelColor:
                                                Colors.white60,
                                            labelStyle: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            tabs: const [
                                              Tab(text: 'DEFINITIONS'),
                                              Tab(text: 'SYNONYMS'),
                                              Tab(text: 'ANTONYMS'),
                                            ],
                                          ),
                                        ),
                                        // Tab Content
                                        Container(
                                          height: 250,
                                          padding: const EdgeInsets.all(16),
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              SingleChildScrollView(
                                                child: buildDefinitionContent(
                                                  'definitions',
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: buildDefinitionContent(
                                                  'synonyms',
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: buildDefinitionContent(
                                                  'antonyms',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Pronunciation Box Column
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final audioUrl = getIn(
                                        searchResult,
                                        'wordData.audio',
                                        '',
                                      );
                                      if (audioUrl.isNotEmpty) {
                                        player.setAudioSource(
                                          AudioSource.uri(Uri.parse(audioUrl)),
                                        );
                                        player.play();
                                      }
                                    },
                                    child: Container(
                                      height: 70,
                                      width: Screen.width(context) * 0.45,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF030D1C),
                                        borderRadius: BorderRadius.circular(40),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            offset: const Offset(4, 4),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(
                                              0.05,
                                            ),
                                            offset: const Offset(-4, -4),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'PRONUNCIATION',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Image.asset(
                                            AppImages.playerlight,
                                            height: 40,
                                            fit: BoxFit.contain,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  if (getIn(
                                    searchResult,
                                    'wordData.meanings',
                                    {},
                                  ).isNotEmpty)
                                    Card3D(
                                      borderRadius: 16,
                                      child: Container(
                                        width: Screen.width(context) * 0.45,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          // color: const Color(0xFF1A2332),
                                          color: ColorsPallet.darkBlue,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          // border: Border.all(
                                          //   color: Colors.white24,
                                          //   width: 1,
                                          // ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'REAL EXAMPLES SENTENCES',
                                              style: TextStyle(
                                                color: Color(0xFF60A5FA),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            ...(() {
                                              var meanings = getIn(
                                                searchResult,
                                                'wordData.meanings',
                                                {},
                                              );
                                              List<Widget> examples = [];
                                              meanings.forEach((key, value) {
                                                var examplesList =
                                                    value['examples'] ?? [];
                                                for (var example
                                                    in examplesList) {
                                                  if (example
                                                      .toString()
                                                      .isNotEmpty) {
                                                    examples.add(
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 8,
                                                            ),
                                                        child: Text(
                                                          example.toString(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              });
                                              return examples.isEmpty
                                                  ? [
                                                      const Text(
                                                        'No examples available',
                                                        style: TextStyle(
                                                          color: Colors.white54,
                                                        ),
                                                      ),
                                                    ]
                                                  : examples;
                                            })(),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // ROW 3: Films - Horizontal Scroll with 2 Columns
                          const Text(
                            'FILMS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 260,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                var movies =
                                    getIn(searchResult, 'movies', []) as List;
                                int itemsPerPage = 4;
                                int pageCount = (movies.length / itemsPerPage)
                                    .ceil();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pageCount,
                                  itemBuilder: (context, pageIndex) {
                                    int startIndex = pageIndex * itemsPerPage;
                                    int endIndex = (startIndex + itemsPerPage)
                                        .clamp(0, movies.length);
                                    List pageMovies = movies.sublist(
                                      startIndex,
                                      endIndex,
                                    );

                                    return Container(
                                      width: constraints.maxWidth * 0.6,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 15,
                                            ),
                                        itemCount: pageMovies.length,
                                        itemBuilder: (context, index) {
                                          var movie = pageMovies[index];
                                          return buildMovieFrame(
                                            movie: movie,
                                            context: context,
                                            fullSize: true,
                                            from: 'search',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ROW 4: Extracts - Horizontal Scroll with 2 Columns
                          const Text(
                            'EXTRACTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 240,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                var subtitles =
                                    getIn(searchResult, 'subtitles', [])
                                        as List;
                                int itemsPerPage = 4;
                                int pageCount =
                                    (subtitles.length / itemsPerPage).ceil();

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pageCount,
                                  itemBuilder: (context, pageIndex) {
                                    int startIndex = pageIndex * itemsPerPage;
                                    int endIndex = (startIndex + itemsPerPage)
                                        .clamp(0, subtitles.length);
                                    List pageSubtitles = subtitles.sublist(
                                      startIndex,
                                      endIndex,
                                    );

                                    return Container(
                                      width: constraints.maxWidth * 0.6,
                                      margin: const EdgeInsets.only(right: 16),
                                      child: GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 2.2,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                            ),
                                        itemCount: pageSubtitles.length,
                                        itemBuilder: (context, index) {
                                          var subtitle = pageSubtitles[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              await movieFetchAndRedirect(
                                                subtitle['content_reference'],
                                                context,
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1A2332),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: Colors.white24,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: getIn(
                                                        subtitle,
                                                        'content_picture',
                                                        '',
                                                      ),
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => Container(
                                                            width: 60,
                                                            height: 60,
                                                            color:
                                                                Colors.white12,
                                                            child: const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            ),
                                                          ),
                                                      errorWidget:
                                                          (
                                                            context,
                                                            url,
                                                            error,
                                                          ) => Container(
                                                            width: 60,
                                                            height: 60,
                                                            color:
                                                                Colors.white12,
                                                            child: const Icon(
                                                              Icons.error,
                                                              color: Colors
                                                                  .white54,
                                                              size: 20,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          getIn(
                                                            subtitle,
                                                            'content_label',
                                                            '',
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF60A5FA,
                                                                ),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          getIn(
                                                            subtitle,
                                                            'text',
                                                            '',
                                                          ),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 9,
                                                              ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      )
                    : // MOBILE LAYOUT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Definition/Synonyms/Antonyms Tabs Section
                          Card3D(
                            borderRadius: 16,
                            child: Container(
                              decoration: BoxDecoration(
                                // color: const Color(0xFF1A2332),
                                color: ColorsPallet.darkBlue,
                                borderRadius: BorderRadius.circular(16),
                                // border: Border.all(
                                //   color: Colors.white24,
                                //   width: 1,
                                // ),
                              ),
                              child: Column(
                                children: [
                                  // Tab Bar
                                  Container(
                                    decoration: const BoxDecoration(
                                      // color: Color(0xFF0D1520),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: TabBar(
                                      controller: _tabController,
                                      indicatorColor: Colors.transparent,
                                      // indicatorColor: const Color(0xFF60A5FA),
                                      indicatorWeight: 3,
                                      labelColor: const Color(0xFF60A5FA),
                                      unselectedLabelColor: Colors.white60,
                                      labelStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      tabs: const [
                                        Tab(text: 'DEFINITIONS'),
                                        Tab(text: 'SYNONYMS'),
                                        Tab(text: 'ANTONYMS'),
                                      ],
                                    ),
                                  ),
                                  // Tab Content
                                  Container(
                                    height: 200,
                                    padding: const EdgeInsets.all(16),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        SingleChildScrollView(
                                          child: buildDefinitionContent(
                                            'definitions',
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: buildDefinitionContent(
                                            'synonyms',
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: buildDefinitionContent(
                                            'antonyms',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Pronunciation Section
                          GestureDetector(
                            onTap: () {
                              final audioUrl = getIn(
                                searchResult,
                                'wordData.audio',
                                '',
                              );
                              if (audioUrl.isNotEmpty) {
                                player.setAudioSource(
                                  AudioSource.uri(Uri.parse(audioUrl)),
                                );
                                player.play();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF030D1C),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: const Offset(4, 4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.05),
                                    offset: const Offset(-4, -4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'PRONUNCIATION',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Image.asset(
                                    AppImages.playerlight,
                                    width: 48,
                                    height: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Real Examples Sentences
                          if (getIn(
                            searchResult,
                            'wordData.meanings',
                            {},
                          ).isNotEmpty)
                            Card3D(
                              borderRadius: 16,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  // color: const Color(0xFF1A2332),
                                  color: ColorsPallet.darkBlue,
                                  borderRadius: BorderRadius.circular(16),
                                  // border: Border.all(
                                  //   color: Colors.white24,
                                  //   width: 1,
                                  // ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'REAL EXAMPLES SENTENCES',
                                      style: TextStyle(
                                        color: Color(0xFF60A5FA),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...(() {
                                      var meanings = getIn(
                                        searchResult,
                                        'wordData.meanings',
                                        {},
                                      );
                                      List<Widget> examples = [];
                                      meanings.forEach((key, value) {
                                        var examplesList =
                                            value['examples'] ?? [];
                                        for (var example in examplesList) {
                                          if (example.toString().isNotEmpty) {
                                            examples.add(
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                ),
                                                child: Text(
                                                  example.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      });
                                      return examples.isEmpty
                                          ? [
                                              const Text(
                                                'No examples available',
                                                style: TextStyle(
                                                  color: Colors.white54,
                                                ),
                                              ),
                                            ]
                                          : examples;
                                    })(),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 20),

                          // Films Section
                          const Text(
                            'FILMS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 180,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  (getIn(searchResult, 'movies', []) as List)
                                      .length,
                              itemBuilder: (context, index) {
                                var movies =
                                    getIn(searchResult, 'movies', []) as List;
                                if (index >= movies.length) {
                                  return const SizedBox.shrink();
                                }
                                var movie = movies[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: buildMovieFrame(
                                    movie: movie,
                                    context: context,
                                    from: 'search',
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Extracts Section
                          const Text(
                            'EXTRACTS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...(() {
                            var subtitles =
                                getIn(searchResult, 'subtitles', []) as List;
                            return subtitles.map((subtitle) {
                              return GestureDetector(
                                onTap: () async {
                                  await movieFetchAndRedirect(
                                    subtitle['content_reference'],
                                    context,
                                  );
                                },
                                child: Card3D(
                                  borderRadius: 16,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    // margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: ColorsPallet.darkBlue,
                                      borderRadius: BorderRadius.circular(16),
                                      // border: Border.all(
                                      //   color: Colors.white24,
                                      //   width: 1,
                                      // ),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: getIn(
                                              subtitle,
                                              'content_picture',
                                              '',
                                            ),
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  color: Colors.white12,
                                                  child: const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      width: 100,
                                                      height: 100,
                                                      color: Colors.white12,
                                                      child: const Icon(
                                                        Icons.error,
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getIn(
                                                  subtitle,
                                                  'content_label',
                                                  '',
                                                ),
                                                style: const TextStyle(
                                                  color: Color(0xFF60A5FA),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                getIn(subtitle, 'text', ''),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList();
                          })(),

                          const SizedBox(height: 20),
                        ],
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
