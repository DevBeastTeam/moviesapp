#!/bin/bash

# Script to fix remaining migration errors - Version 3

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

# Helper to add import if missing
add_import() {
    local file=$1
    local import=$2
    if ! grep -q "$import" "$file"; then
        sed -i '' "1s|^|$import\n|" "$file"
    fi
}

echo "Fixing remaining errors..."

# 1. lib/pages/home/profile/header.dart
FILE="pages/home/profile/header.dart"
add_import "$FILE" "import 'profile_settings_page.dart';"
add_import "$FILE" "import '../../flashcards/flashcardslist.dart';"
sed -i '' "s|context.go('/home/settings')|Get.to(() => const ProfileSettingsPage())|g" "$FILE"
sed -i '' "s|context.go('/home/fc')|Get.to(() => const FlashCardsListPage())|g" "$FILE"

# 2. lib/pages/home/profile/profile_settings_page.dart
FILE="pages/home/profile/profile_settings_page.dart"
add_import "$FILE" "import 'edit.dart';"
add_import "$FILE" "import '../../auth/auth_page.dart';"
sed -i '' "s|context.go('/home/settings/profile-edit')|Get.to(() => const ProfileEditPage())|g" "$FILE"
sed -i '' "s|context.go('/auth')|Get.to(() => const AuthPage())|g" "$FILE"

# 3. lib/pages/home/profile/buttons.dart
FILE="pages/home/profile/buttons.dart"
add_import "$FILE" "import '../../lessons/grammer.dart';"
add_import "$FILE" "import '../../excersises/excersise.dart';"
add_import "$FILE" "import '../../ai/aiChat.dart';"
add_import "$FILE" "import '../../ponounciations/pronLevels1.dart';"
sed -i '' "s|context.go('/home/GrammerPage')|Get.to(() => const GrammerPage())|g" "$FILE"
sed -i '' "s|context.go('/home/ExcersisesPage')|Get.to(() => const ExcersisesPage())|g" "$FILE"
sed -i '' "s|context.go('/home/AIMenuPage')|Get.to(() => const AIMenuPage())|g" "$FILE"
sed -i '' "s|context.go('/home/PronlevelsPage1')|Get.to(() => const PronlevelsPage1())|g" "$FILE"

# 4. lib/pages/home/writings/writingsmenu.dart
FILE="pages/home/writings/writingsmenu.dart"
add_import "$FILE" "import '../../ai/aiChat.dart';"
sed -i '' "s|context.go('/home/ai/aichat')|Get.to(() => const AIMenuPage())|g" "$FILE"

# 5. lib/pages/home/profile/edit.dart
FILE="pages/home/profile/edit.dart"
add_import "$FILE" "import '../home_page.dart';"
sed -i '' "s|context.go('/home')|Get.to(() => const HomePage())|g" "$FILE"

echo "Fix script v3 completed."
