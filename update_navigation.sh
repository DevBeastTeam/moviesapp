#!/bin/bash

# Script to batch update navigation calls from context.go to Get.to

cd /Users/mac/Documents/flutter_projects/awais/moviesapp

# Array of files to update with their navigation mappings
# Format: filepath|old_import|new_imports|navigation_replacements

# Start page
sed -i '' 's/import '\''package:go_router\/go_router.dart'\'';/import '\''package:get\/get.dart'\'';\nimport '\''..\/entry_quiz\/entry_quiz_page.dart'\'';/g' lib/pages/start/start_page.dart
sed -i '' 's/context\.go('\''\/entry-quiz'\'');/Get.to(() => const EntryQuizPage());/g' lib/pages/start/start_page.dart

# Entry quiz pages
sed -i '' 's/import '\''package:go_router\/go_router.dart'\'';/import '\''package:get\/get.dart'\'';\nimport '\''level_page.dart'\'';/g' lib/pages/entry_quiz/entry_quiz_page.dart
sed -i '' 's/context\.go('\''\/entry-quiz-level'\'');/Get.to(() => const EntryQuizLevelPage());/g' lib/pages/entry_quiz/entry_quiz_page.dart

sed -i '' 's/import '\''package:go_router\/go_router.dart'\'';/import '\''package:get\/get.dart'\'';\nimport '\''results_page.dart'\'';/g' lib/pages/entry_quiz/level_page.dart
sed -i '' 's/context\.go('\''\/entry-quiz-results'\'');/Get.to(() => const EntryQuizResultsPage());/g' lib/pages/entry_quiz/level_page.dart

sed -i '' 's/import '\''package:go_router\/go_router.dart'\'';/import '\''package:get\/get.dart'\'';\nimport '\''..\/home\/home_page.dart'\'';/g' lib/pages/entry_quiz/results_page.dart
sed -i '' 's/context\.go('\''\/home'\'');/Get.to(() => const HomePage());/g' lib/pages/entry_quiz/results_page.dart

echo "Batch update completed!"
