import 'package:hive/hive.dart';

import '../core/hive.dart';

HiveHelper _hiveHelper = HiveHelper();

Box userBox = _hiveHelper.box('user');
Box badgesBox = _hiveHelper.box('badges');
Box quizBox = _hiveHelper.box('quiz');
Box moviesBox = _hiveHelper.box('movies');
Box configBox = _hiveHelper.box('config');
Box statisticsBox = _hiveHelper.box('statistics');
