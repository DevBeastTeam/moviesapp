#!/bin/bash

# Comprehensive script to update all remaining navigation calls

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

# Function to replace go_router import with get
replace_imports() {
    local file=$1
    sed -i '' 's/import '\''package:go_router\/go_router.dart'\'';/import '\''package:get\/get.dart'\'';/g' "$file"
    # Also handle commented imports
    sed -i '' 's/\/\/ import '\''package:go_router\/go_router.dart'\'';/\/\/ import '\''package:get\/get.dart'\'';/g' "$file"
}

# Update all files with go_router import
echo "Updating imports..."

# Home and profile pages
replace_imports "pages/home/home_page.dart"
replace_imports "pages/home/profile/buttons.dart"
replace_imports "pages/home/profile/profile_settings_page.dart"
replace_imports "pages/home/profile/edit.dart"
replace_imports "pages/home/profile/header.dart"
replace_imports "pages/home/writings/writingsmenu.dart"

# Tests pages
replace_imports "pages/tests/tests_page.dart"
replace_imports "pages/tests/tests_quiz_page.dart"
replace_imports "pages/tests/tests_quiz_results.dart"
replace_imports "pages/tests/tests_list_component.dart"
replace_imports "pages/tests/tests_list_page.dart"

# Movies pages
replace_imports "pages/movies/movie_page.dart"
replace_imports "pages/movies/widgets/player.dart"

# Pronunciation pages
replace_imports "pages/ponounciations/pronLevels1.dart"
replace_imports "pages/ponounciations/pronCatgPage2.dart"
replace_imports "pages/ponounciations/pronCatgLessonsPage3.dart"
replace_imports "pages/ponounciations/pronParacticePage4.dart"
replace_imports "pages/ponounciations/pronResult5.dart"

# Lessons pages
replace_imports "pages/lessons/grammer.dart"
replace_imports "pages/lessons/grammerCatg.dart"
replace_imports "pages/lessons/grammerdetail.dart"

# Exercises pages
replace_imports "pages/excersises/excersise.dart"
replace_imports "pages/excersises/excerciseCatg.dart"
replace_imports "pages/excersises/exercisesByCatgQA.dart"

# AI pages
replace_imports "pages/ai/aiChat.dart"
replace_imports "pages/ai/aiChat2.dart"
replace_imports "pages/ai/aIAllChatHistoryPage.dart"

# Flashcards pages
replace_imports "pages/flashcards/flashcardslist.dart"
replace_imports "pages/flashcards/falscarddetails.dart"

# Utils
replace_imports "utils/utils.dart"
replace_imports "utils/movies.dart"

echo "Import replacements completed!"

# Now replace specific navigation calls
echo "Updating navigation calls..."

# Home page - context.go("/movies") -> Get.to(() => const MoviesPage())
sed -i '' 's/context\.go("\/movies")/Get.to(() => const MoviesPage())/g' pages/home/home_page.dart

# Movie page
sed -i '' 's/context\.go('\''\/movies\/movie\/player'\'')/Get.to(() => const MoviePlayPage())/g' pages/movies/movie_page.dart
sed -i '' 's/context\.go('\''\/home\/fc'\'')/Get.to(() => const FlashCardsListPage())/g' pages/movies/movie_page.dart

# Tests pages
sed -i '' 's/context\.go('\''\/tests\/base'\'')/Get.to(() => const TestsBasePage())/g' pages/tests/tests_quiz_page.dart
sed -i '' 's/context\.go('\''\/tests\/quiz\/results'\'')/Get.to(() => const TestsQuizResultsPage())/g' pages/tests/tests_quiz_page.dart
sed -i '' 's/context\.go('\''\/tests'\'')/Get.to(() => const TestsPage())/g' pages/tests/tests_quiz_results.dart
sed -i '' 's/context\.go('\''\/tests\/quiz'\'')/Get.to(() => const TestsQuizPage())/g' pages/tests/tests_list_component.dart
sed -i '' 's/context\.go('\''\/tests'\'')/Get.to(() => const TestsPage())/g' pages/tests/tests_list_page.dart
sed -i '' 's/context\.go('\''\/tests\/quiz'\'')/Get.to(() => const TestsQuizPage())/g' pages/tests/tests_list_page.dart

# Pronunciation pages
sed -i '' 's/context\.go("\/home\/PronlevelsPage1\/2")/Get.to(() => const PronCatgPage2())/g' pages/ponounciations/pronLevels1.dart
sed -i '' 's/context\.go("\/home\/PronlevelsPage1\/2\/3")/Get.to(() => const PronCatgLessonsPage3())/g' pages/ponounciations/pronCatgPage2.dart
sed -i '' 's/context\.go("\/home\/PronlevelsPage1\/2\/3\/4")/Get.to(() => const PronParacticePage4())/g' pages/ponounciations/pronCatgLessonsPage3.dart

# Handle multi-line context.go calls (these need manual review)
echo "Note: Multi-line context.go() calls in the following files may need manual review:"
echo "  - pages/lessons/grammer.dart"
echo "  - pages/lessons/grammerCatg.dart"
echo "  - pages/excersises/excerciseCatg.dart"
echo "  - pages/ai/aiChat.dart"
echo "  - pages/ponounciations/pronParacticePage4.dart"

echo "Navigation call replacements completed!"
echo "All batch updates finished!"
