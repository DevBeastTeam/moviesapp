# Authentication Flow V2

## Overview
This is the new version 2 of the authentication flow with a modern, dark blue gradient design.

## Structure

### V1 (Old Design)
Located in:
- `lib/pages/auth/v1/` - Old auth pages
- `lib/pages/splash_screen/v1/` - Old splash screen

### V2 (New Design)
Located in:
- `lib/pages/auth/v2/` - New auth pages
- `lib/pages/splash_screen/v2/` - New splash screen

## V2 Flow

### 1. Splash Screen
**File:** `lib/pages/splash_screen/v2/splash_screen_page.dart`

- Shows app logo with white rounded background
- Dark blue gradient background
- "E-DUTAINMENT" title
- "WATCH. PLAY. PROGRESS" tagline
- Loading indicator
- Marmignon Brothers branding footer
- Checks for saved token for persistent login
- Duration: 3 seconds

### 2. Intro Screen (Swipeable)
**File:** `lib/pages/auth/v2/intro_screen.dart`

- Same dark blue gradient design
- Welcome message in French
- Swipe instruction: "Pour vous connecter, veuillez swiper à droite"
- Swipe indicator with arrows
- User swipes right to access login

### 3. Login Screen
**File:** `lib/pages/auth/v2/login_screen.dart`

- Dark blue gradient background
- App logo at top
- Username input field (rounded with blue border)
- Password input field (rounded with blue border)
- Blue "LOG IN" button
- Marmignon Brothers branding footer

## Design Features

### Color Scheme
- **Background Gradient:**
  - Top: `#0A1929`
  - Middle: `#0D2137`
  - Bottom: `#0A1929`
  
- **Primary Blue:** Used for borders and buttons
- **White:** Text and logo background
- **Opacity Effects:** Subtle background patterns

### Components
- **Logo Container:**
  - White background
  - Rounded corners (30px radius)
  - Blue shadow with 0.3 opacity
  - Padding: 20px (splash), 15px (login)

- **Input Fields:**
  - Rounded borders (30px radius)
  - Blue border with 0.5 opacity
  - White text
  - Placeholder text with 0.5 opacity
  - Padding: 25px horizontal, 18px vertical

- **Login Button:**
  - Blue background
  - White text
  - Rounded (30px radius)
  - Letter spacing: 1.5
  - Padding: 18px vertical

### Typography
- **App Title:** 32px, Football Attack font, white, letter-spacing: 2
- **Tagline:** 16px, Football Attack font, white70, letter-spacing: 3
- **Body Text:** 16px, white70
- **Button Text:** 16px, bold, white, letter-spacing: 1.5

## Implementation

The v2 design is now active in the app. The flow is:

1. App starts → `SplashScreenPageV2`
2. After 3 seconds → Checks for saved token
3. If token exists → Auto-login to home
4. If no token → `AuthPageV2` (PageView with intro and login)
5. User swipes right → Login screen
6. User logs in → Home screen

## Files Created

### Splash Screen
- `lib/pages/splash_screen/v2/splash_screen_page.dart`
- `lib/pages/splash_screen/v2/splash_screen_content.dart`

### Auth
- `lib/pages/auth/v2/auth_page.dart` - Main auth page with PageView
- `lib/pages/auth/v2/intro_screen.dart` - Welcome/intro screen
- `lib/pages/auth/v2/login_screen.dart` - Login form screen

## Switching Between Versions

To switch back to v1, update `lib/main.dart`:

```dart
// V2 (current)
import 'pages/splash_screen/v2/splash_screen_page.dart';
home: const SplashScreenPageV2(),

// V1 (old)
import 'pages/splash_screen/v1/splash_screen_page.dart';
home: const SplashScreenPage(),
```

And update `lib/pages/splash_screen/v2/splash_screen_page.dart` (or v1) to use the correct auth page:

```dart
// V2
Get.to(() => const AuthPageV2());

// V1
Get.to(() => const AuthPage());
```

## Notes

- V1 files are preserved in their respective v1 folders
- V2 is the active version
- Both versions support persistent login
- V2 uses PageView for swipeable screens
- All screens maintain the same dark blue gradient theme
