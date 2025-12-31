### Issues to Fix:
1. **Bottom Navigation Visibility:** The bottom navigation bar is not showing on certain mobile devices.
2. **Layering Conflict:** On some devices, the app's bottom navigation bar is stacked beneath the mobile system navigation bar, preventing user interaction.
__________________


### Bottom Navigation Bar Issues - FIXED ✅

## Issues Fixed:
1. **Bottom Navigation Visibility:** The bottom navigation bar is now visible on all mobile devices.
2. **Layering Conflict:** The app's bottom navigation bar now sits above the mobile system navigation bar, allowing proper interaction.

## Changes Made:

### 1. `/lib/widgets/ui/default_scaffold.dart`
- Changed `SafeArea` widget's `bottom` parameter from `false` to `true`
- This ensures the layout respects the device's bottom safe area (navigation gestures area)

### 2. `/lib/widgets/bottom_bar/custom_bottom_bar.dart`
- Added `MediaQuery.of(context).padding.bottom` to get the device's bottom safe area padding
- Wrapped the bottom navigation bar in a `Container` with bottom padding equal to the safe area
- This pushes the navigation bar above the system navigation area on devices with gesture navigation

## Technical Details:
- The fix ensures compatibility with modern devices that use gesture-based navigation
- The bottom padding is dynamically calculated based on each device's safe area
- On devices without gesture navigation, the padding will be 0, so no visual change
- On devices with gesture navigation (iPhone X and newer, modern Android devices), the navigation bar will sit above the system gesture area