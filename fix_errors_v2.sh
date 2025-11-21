#!/bin/bash

# Script to fix migration errors - Version 2

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

# Helper to add import if missing
# Uses | as delimiter to avoid issues with / in paths
add_import() {
    local file=$1
    local import=$2
    if ! grep -q "$import" "$file"; then
        sed -i '' "1s|^|$import\n|" "$file"
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
add_import "pages/tests/tests_page.dart" "import 'tests_base_page.dart';"

# Utils
add_import "utils/movies.dart" "import '../pages/movies/movie_page.dart';"
add_import "utils/movies.dart" "import '../pages/movies/movie_play_page.dart';"
add_import "utils/utils.dart" "import '../pages/home/home_page.dart';"

# 2. Fix context.pop() -> Navigator.pop(context)
echo "Fixing context.pop()..."
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/context\.pop()/Navigator.pop(context)/g'
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/context\.pop();/Navigator.pop(context);/g'

# 3. Fix GoRouterState -> Get.arguments
echo "Fixing GoRouterState..."
# Replace GoRouterState.of(context).extra with Get.arguments
find . -name "*.dart" -print0 | xargs -0 sed -i '' 's/GoRouterState\.of(context)\.extra/Get.arguments/g'
# Remove GoRouterState import if present
find . -name "*.dart" -print0 | xargs -0 sed -i '' '/import.*go_router\.dart/d'

# 4. Fix remaining context.go / context.push and incorrect Get.to strings
echo "Fixing remaining navigation..."

# utils/movies.dart
# Fix context.push/go and incorrect Get.to strings
sed -i '' "s|Get.to(() => '/movies/movie')|Get.to(() => const MoviePage())|g" utils/movies.dart
sed -i '' "s|Get.to(() => '/movies/movie/player')|Get.to(() => const MoviePlayPage())|g" utils/movies.dart
# Handle if they are still context.go/push
sed -i '' "s|context.push('/movies/movie')|Get.to(() => const MoviePage())|g" utils/movies.dart
sed -i '' "s|context.go('/movies/movie')|Get.to(() => const MoviePage())|g" utils/movies.dart
sed -i '' "s|context.push('/movies/movie/player')|Get.to(() => const MoviePlayPage())|g" utils/movies.dart
sed -i '' "s|context.go('/movies/movie/player')|Get.to(() => const MoviePlayPage())|g" utils/movies.dart

# utils/utils.dart
sed -i '' "s|Get.to(() => '/home')|Get.to(() => const HomePage())|g" utils/utils.dart
sed -i '' "s|context.go('/home')|Get.to(() => const HomePage())|g" utils/utils.dart

# tests_page.dart
sed -i '' "s|Get.to(() => '/tests/base')|Get.to(() => const TestsBasePage())|g" pages/tests/tests_page.dart
sed -i '' "s|context.go('/tests/base')|Get.to(() => const TestsBasePage())|g" pages/tests/tests_page.dart

echo "Fix script v2 completed."
