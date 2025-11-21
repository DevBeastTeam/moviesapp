#!/bin/bash

# Script to fix migration errors

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

# Helper to add import if missing
add_import() {
    local file=$1
    local import=$2
    if ! grep -q "$import" "$file"; then
        sed -i '' "1s/^/$import\n/" "$file"
    fi
}

# 1. Fix Imports
echo "Fixing imports..."

# Movie Page
add_import "pages/movies/movie_page.dart" "import 'movie_play_page.dart';"
add_import "pages/movies/movie_page.dart" "import '../flashcards/flashcardslist.dart';"

# Pronunciation Pages
add_import "pages/ponounciations/pronCatgLessonsPage3.dart" "import 'pronParacticePage4.dart';"
add_import "pages/ponounciations/pronCatgPage2.dart" "import 'pronCatgLessonsPage3.dart';"
add_import "pages/ponounciations/pronLevels1.dart" "import 'pronCatgPage2.dart';"

# Tests Pages
add_import "pages/tests/tests_list_component.dart" "import 'tests_quiz_page.dart';"
add_import "pages/tests/tests_list_page.dart" "import 'tests_page.dart';"
add_import "pages/tests/tests_list_page.dart" "import 'tests_quiz_page.dart';"
add_import "pages/tests/tests_quiz_page.dart" "import 'tests_base_page.dart';"
add_import "pages/tests/tests_quiz_page.dart" "import 'tests_quiz_results.dart';"
add_import "pages/tests/tests_quiz_results.dart" "import 'tests_page.dart';"

# 2. Fix context.pop() -> Navigator.pop(context)
echo "Fixing context.pop()..."
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/context\.pop()/Navigator.pop(context)/g'
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/context\.pop();/Navigator.pop(context);/g'

# 3. Fix GoRouterState -> Get.arguments
echo "Fixing GoRouterState..."
# Replace GoRouterState.of(context).extra with Get.arguments
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/GoRouterState\.of(context)\.extra/Get.arguments/g'
# Remove GoRouterState import if present (it's part of go_router package which is gone)
find . -name "*.dart" -print0 | xargs -0 sed -i '' '/import.*go_router\.dart/d'

# 4. Fix remaining context.go / context.push
echo "Fixing remaining navigation..."

# utils/movies.dart
sed -i '' 's/context\.push(/Get.to(() => /g' utils/movies.dart
sed -i '' 's/context\.go(/Get.to(() => /g' utils/movies.dart
# Need to fix the closing parenthesis for push/go calls if they were simple. 
# This is tricky with sed. I'll handle utils/movies.dart manually or with more specific sed if I can see the content.
# For now, let's assume I need to check it.

# utils/utils.dart
sed -i '' 's/context\.go(/Get.to(() => /g' utils/utils.dart

# tests_page.dart
sed -i '' 's/context\.go(/Get.to(() => /g' pages/tests/tests_page.dart

echo "Fix script completed."
