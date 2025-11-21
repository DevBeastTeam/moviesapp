import 'dart:developer';
import 'package:get/get.dart';
import '../utils/search.dart';

class WordSearchController extends GetxController {
  // Observable state
  var isLoading = false.obs;
  var searchResult = Rxn<Map<String, dynamic>>();
  var currentTab = 'ALL'.obs;

  // Perform search
  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;

    isLoading.value = true;

    try {
      var result = await fetchWord(query);
      log("👉🏻 fetchWord: $result");
      searchResult.value = result;
    } catch (e) {
      log("❌ Error fetching word: $e");
      searchResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Clear search results
  void clearSearch() {
    searchResult.value = null;
    isLoading.value = false;
  }

  // Update current tab
  void updateTab(String tab) {
    currentTab.value = tab;
  }
}
