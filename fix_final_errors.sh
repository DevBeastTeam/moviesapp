#!/bin/bash

# Script to fix final migration errors

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

# Helper to add import if missing
add_import() {
    local file=$1
    local import=$2
    if ! grep -q "$import" "$file"; then
        sed -i '' "1s|^|$import\n|" "$file"
    fi
}

echo "Fixing final errors..."

# 1. lib/pages/flashcards/flashcardslist.dart
FILE="pages/flashcards/flashcardslist.dart"
add_import "$FILE" "import 'falscarddetails.dart';"
# Replace context.go with Get.to and arguments
# We match the pattern context.go("/home/fc/fcdetails", extra:
sed -i '' 's|context.go("/home/fc/fcdetails", extra:|Get.to(() => const FlashCardDetailsPage(), arguments:|g' "$FILE"
# Also handle the case with newlines if any (sed is line based, so this might be tricky if split across lines)
# The grep output showed it on one line or start of line.
# Let's try to handle the specific lines if possible or use a more generic replacement.
# The file view showed:
# context.go(
#   "/home/fc/fcdetails",
#   extra: {
# This is multi-line. sed works line by line.
# I'll use perl for multi-line replacement or just replace the function call start and the path.

# Replace 'context.go(' with 'Get.to(() => const FlashCardDetailsPage(), arguments: ' 
# BUT wait, context.go takes path as first arg.
# I need to remove the path argument.

# Strategy:
# 1. Replace `context.go("/home/fc/fcdetails", extra: {` with `Get.to(() => const FlashCardDetailsPage(), arguments: {`
# This assumes it's all on one line or I can match the start.
# The view showed:
# 258:                                     context.go(
# 259:                                       "/home/fc/fcdetails",
# 260:                                       extra: {

# This is split across lines.
# I will use a perl one-liner to handle multi-line replacement.
perl -i -0777 -pe 's/context\.go\(\s*"\/(home\/fc\/fcdetails|movies\/movie\/player|movies\/movie)",\s*extra:/Get.to(() => const FlashCardDetailsPage(), arguments:/gs' "$FILE"

# 2. lib/pages/home/home_page.dart
FILE="pages/home/home_page.dart"
add_import "$FILE" "import '../movies/movies_page.dart';"

echo "Fix script final completed."
