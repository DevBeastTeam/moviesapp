import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api_helper.dart';
import '../models/quiz_model.dart';
import '../utils/utils.dart';

class QuizController extends GetxController {
  final ApiHelper _api = ApiHelper();

  // State variables
  var categories = <QuizCategory>[].obs;
  var quizzes = <Quiz>[].obs;
  var currentQuiz = Rxn<Quiz>();
  var entryQuiz = Rxn<Quiz>();
  var quizResult = Rxn<QuizResult>();

  var selectedCategory = Rxn<QuizCategory>();
  var selectedType = 'training'.obs;

  var isLoading = false.obs;
  var isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // GET /quizz/categories/list
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await _api.get('/quizz/categories/list', null);
      debugPrint(' 👉🏻 fetchCategories response: $response');
      final List<dynamic> data = getIn(response, 'categories', []) ?? [];
      categories.value = data.map((e) => QuizCategory.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET /quizz/categories/{category}/{type}/list
  Future<void> fetchQuizzesByCategory(String categoryId, String type) async {
    try {
      isLoading.value = true;
      final response = await _api.get(
        '/quizz/categories/$categoryId/$type/list',
        null,
      );
      debugPrint(' 👉🏻 fetchQuizzesByCategory response: $response');

      final List<dynamic> data = getIn(response, 'quizz', []) ?? [];
      quizzes.value = data.map((e) => Quiz.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching quizzes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET /quizz/{id}/start
  Future<bool> startQuiz(String quizId) async {
    try {
      isLoading.value = true;
      final response = await _api.get('/quizz/$quizId/start', null);
      debugPrint(' 👉🏻 startQuiz response: $response');

      // Try different possible response structures
      var data = getIn(response, 'quiz');

      // If 'quiz' is not found, check if the response itself is the quiz data
      if (data == null && response != null && response is Map) {
        // Check if response has quiz-like fields
        if (response.containsKey('_id') || response.containsKey('questions')) {
          data = response;
        }
      }

      if (data != null) {
        currentQuiz.value = Quiz.fromJson(data);
        debugPrint(' ✅ Quiz started successfully: ${currentQuiz.value?.title}');
        return true;
      }

      debugPrint(' ❌ No quiz data found in response');
      return false;
    } catch (e) {
      debugPrint(' ❌ Error starting quiz: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // GET /quizz/{id}/results/{session}
  Future<void> fetchQuizResults(String quizId, String sessionId) async {
    try {
      isLoading.value = true;
      final response = await _api.get('/quizz/$quizId/results/$sessionId', {});
      debugPrint(' 👉🏻 fetchQuizResults response: $response');

      if (response != null) {
        quizResult.value = QuizResult.fromJson(response);
      }
    } catch (e) {
      print('Error fetching quiz results: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET /quizz/entry-quiz
  Future<void> fetchEntryQuiz() async {
    try {
      isLoading.value = true;
      final response = await _api.get('/quizz/entry-quiz', null);
      final data = getIn(response, 'entryQuiz');
      if (data != null) {
        entryQuiz.value = Quiz.fromJson(data);
      }
      debugPrint(' 👉🏻 fetchEntryQuiz response: $response');
    } catch (e) {
      print('Error fetching entry quiz: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // GET /quizz/entry-quiz/results
  Future<dynamic> fetchEntryQuizResults() async {
    try {
      isLoading.value = true;
      final response = await _api.get('/quizz/entry-quiz/results', null);
      debugPrint(' 👉🏻 fetchEntryQuizResults response: $response');

      return response;
    } catch (e) {
      print('Error fetching entry quiz results: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // POST /quizz/entry-quiz/save
  Future<void> saveEntryQuiz(Map<String, dynamic> answers) async {
    try {
      isSaving.value = true;
      var response = await _api.post('/quizz/entry-quiz/save', {
        'answers': answers,
      }, {});
      debugPrint(' 👉🏻 saveEntryQuiz response: $response');
    } catch (e) {
      print('Error saving entry quiz: $e');
    } finally {
      isSaving.value = false;
    }
  }

  // POST /quizz/{id}/save
  Future<dynamic> saveQuiz(String quizId, Map<String, dynamic> answers) async {
    try {
      isSaving.value = true;
      final response = await _api.post('/quizz/$quizId/save', {
        'answers': answers,
      }, {});
      debugPrint(' 👉🏻 saveQuiz response: $response');

      final sessionId = getIn(response, 'quizSession._id');
      if (sessionId != null) {
        await fetchQuizResults(quizId, sessionId);
      }
      return response;
    } catch (e) {
      print('Error saving quiz: $e');
      return null;
    } finally {
      isSaving.value = false;
    }
  }
}
