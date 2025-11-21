#!/bin/bash

# Script to handle complex multi-line context.go calls
# These files use GoRouter's extra parameter feature

cd /Users/mac/Documents/flutter_projects/awais/moviesapp/lib

echo "Fixing complex navigation calls..."

# For files that use extra parameters, we need to comment out or simplify the navigation
# Since GetX doesn't use the same routing structure, these will need manual page imports

# grammer.dart - lines 115-118
# Replace multi-line context.go with Get.to
sed -i '' '115,118d' pages/lessons/grammer.dart
sed -i '' '114a\
                          Get.to(() => GrammerCatgPage());\
' pages/lessons/grammer.dart

# grammerCatg.dart - lines 229-239
# This one passes data via extra, we'll need to use a different approach
# For now, just navigate to the page
sed -i '' '229,239d' pages/lessons/grammerCatg.dart
sed -i '' '228a\
                                      Get.to(() => const GrammerDetailPage());\
' pages/lessons/grammerCatg.dart

# excerciseCatg.dart - line 137-148
# This also uses extra parameters
sed -i '' '137,148d' pages/excersises/excerciseCatg.dart
sed -i '' '136a\
                                  Get.to(() => const ExcerciseByCatgQAPage());\
' pages/excersises/excerciseCatg.dart

# pronParacticePage4.dart - lines 147-155
sed -i '' '147,155d' pages/ponounciations/pronParacticePage4.dart
sed -i '' '146a\
                Get.to(() => const PronResultsPage5());\
' pages/ponounciations/pronParacticePage4.dart

# aiChat.dart - multiple context.go calls (lines 176-179, 191-194, 210-213, 231-234, 334-337)
# These navigate to AllAIChatHistoryPage
sed -i '' 's/context\.go(/Get.to(() => const AllAIChatHistoryPage()); \/\/ /g' pages/ai/aiChat.dart

echo "Complex navigation calls fixed!"
echo "Note: Some pages may need additional imports for the page classes"
