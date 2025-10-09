import 'package:edutainment/pages/excersises/excerciseCatg.dart';
import 'package:edutainment/pages/excersises/excersise.dart';
import 'package:edutainment/pages/flashcards/flashcardslist.dart';
import 'package:edutainment/pages/grammer/grammer.dart';
import 'package:edutainment/pages/home/profile/profile_settings_page.dart';
import 'package:edutainment/pages/home/writings/writingsmenu.dart';
import 'package:edutainment/pages/grammer/grammerdetail.dart';
import 'package:edutainment/pages/grammer/grammerCatg.dart';
import 'package:edutainment/pages/tests/tests_base_page.dart';
import 'package:edutainment/utils/boxes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../pages/ai/chat.dart';
import '../pages/auth/auth_page.dart';
import '../pages/auth/auth_splash_screen.dart';
import '../pages/entry_quiz/entry_quiz_page.dart';
import '../pages/entry_quiz/level_page.dart';
import '../pages/entry_quiz/results_page.dart';
import '../pages/excersises/exercisesByCatgQA.dart';
import '../pages/flashcards/falscarddetails.dart';
import '../pages/home/home_page.dart';
import '../pages/home/profile/edit.dart';
import '../pages/movies/movie_page.dart';
import '../pages/movies/movie_play_page.dart';
import '../pages/movies/movies_page.dart';
import '../pages/search/search_page.dart';
import '../pages/splash_screen/splash_screen_page.dart';
import '../pages/start/start_page.dart';
import '../pages/tests/tests_list_page.dart';
import '../pages/tests/tests_page.dart';
import '../pages/tests/tests_quiz_page.dart';
import '../pages/tests/tests_quiz_results.dart';
import '../pages/welcome/welcome_page.dart';
import '../utils/utils.dart';

GoRouter appRoutes = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreenPage()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(
      path: '/auth-splash',
      builder: (context, state) => const AuthSplashScreenPage(),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const WelcomePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/start',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const StartPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/entry-quiz',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const EntryQuizPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/entry-quiz-level',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const EntryQuizLevelPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/entry-quiz-results',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const EntryQuizResultsPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const HomePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'settings',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const ProfileSettingsPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
          routes: [
            GoRoute(
              path: 'profile-edit',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const ProfileEditPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'ai',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const CopilotMenuPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
          routes: [
            GoRoute(
              path: 'aichat',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const ChatAiPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'fc',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const FlashCardsListPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
          routes: [
            GoRoute(
              path: 'fcdetails',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const FlashCardDetailsPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'GrammerPage',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const GrammerPage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
          routes: [
            GoRoute(
              path: 'grammerCatg',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: GrammerCatgPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
              routes: [
                GoRoute(
                  path: 'grammerDetail',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      key: UniqueKey(),
                      child: GrammerDetailPage(),
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: CurveTween(
                                curve: Curves.easeInOut,
                              ).animate(animation),
                              child: child,
                            );
                          },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movies',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const MoviesPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'movie',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const MoviePage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
          routes: [
            GoRoute(
              path: 'player',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const MoviePlayPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const SearchPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/tests',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const TestsPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: 'base',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: UniqueKey(),
              child: const TestsBasePage(),
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/tests/base',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const TestsBasePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/tests/list',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const TestsListPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/tests/quiz',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const TestsQuizPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/tests/quiz/results',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const TestsQuizResultsPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    ///////////////////////////////////////
    /////////// changes are here //////////
    ///////////////////////////////////////
    GoRoute(
      path: '/lessons',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: GrammerCatgPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/lessondetail',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: const GrammerDetailPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    ////// excercises menu 
    GoRoute(
      path: '/ExcersisesPage',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: UniqueKey(),
          child: ExcersisesPage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
       routes: [
            GoRoute(
              path: 'ExcerciseCatgPage',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const ExcerciseCatgPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
            GoRoute( 
              path: 'ExcerciseByCatgQAPage',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: UniqueKey(),
                  child: const ExcerciseByCatgQAPage(),
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: CurveTween(
                            curve: Curves.easeInOut,
                          ).animate(animation),
                          child: child,
                        );
                      },
                );
              },
            ),
          ],
    ),
  ],
  

  redirect: (context, state) {
    var allowedPath = [
      '/home',
      '/profile-edit',
      '/movies',
      '/movie/movie',
      '/movie',
      '/search',
      '/tests',
      '/tests/list',
      '/home/flashcards',
    ];

    configBox.put(
      'floatingQuestionAllowed',
      allowedPath.contains(state.location),
    );

    if (state.location != '/' && state.location != '/auth') {
      if (isLoggedIn() != '' && isLoggedIn() != null) {
        return null;
      } else {
        return '/auth';
      }
      
    } else if (state.location.contains('/auth') &&
        userBox.get('token') != null &&
        userBox.get('token') != '' &&
        !JwtDecoder.isExpired(userBox.get('token'))) {
      return '/auth-splash';
    } else {
      return null;
    }
  },
);
