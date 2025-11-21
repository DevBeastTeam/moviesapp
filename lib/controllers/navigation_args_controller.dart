import 'package:get/get.dart';
import '../models/flashCardsModel.dart';
import '../models/grammerModel.dart';

class NavigationArgsController extends GetxController {
  // Flashcards
  final Rx<FlashCardsMovie?> _flashCardMovie = Rx<FlashCardsMovie?>(null);
  FlashCardsMovie? get flashCardMovie => _flashCardMovie.value;
  set flashCardMovie(FlashCardsMovie? value) => _flashCardMovie.value = value;

  final RxString _flashCardSubjectId = ''.obs;
  String get flashCardSubjectId => _flashCardSubjectId.value;
  set flashCardSubjectId(String value) => _flashCardSubjectId.value = value;

  // Exercises
  final RxString _exerciseLabelTitle = ''.obs;
  String get exerciseLabelTitle => _exerciseLabelTitle.value;
  set exerciseLabelTitle(String value) => _exerciseLabelTitle.value = value;

  // AI Chat
  final RxBool _aiChatIsPinnedOnly = false.obs;
  bool get aiChatIsPinnedOnly => _aiChatIsPinnedOnly.value;
  set aiChatIsPinnedOnly(bool value) => _aiChatIsPinnedOnly.value = value;

  // Grammar
  final RxString _grammerCatgName = ''.obs;
  String get grammerCatgName => _grammerCatgName.value;
  set grammerCatgName(String value) => _grammerCatgName.value = value;

  final RxString _grammerSubCatgName = ''.obs;
  String get grammerSubCatgName => _grammerSubCatgName.value;
  set grammerSubCatgName(String value) => _grammerSubCatgName.value = value;

  final RxList<Lesson> _grammerSubLessons = <Lesson>[].obs;
  List<Lesson> get grammerSubLessons => _grammerSubLessons;
  set grammerSubLessons(List<Lesson> value) =>
      _grammerSubLessons.assignAll(value);

  final Rx<Lesson?> _grammerSelectedLesson = Rx<Lesson?>(null);
  Lesson? get grammerSelectedLesson => _grammerSelectedLesson.value;
  set grammerSelectedLesson(Lesson? value) =>
      _grammerSelectedLesson.value = value;
}
