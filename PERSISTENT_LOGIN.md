# Persistent Login Session

## Overview
The app now supports persistent login sessions. Users will remain logged in even after closing and reopening the app, eliminating the need to enter credentials repeatedly.

## How It Works

### 1. **Login Flow**
- User enters username and password on the login page
- Upon successful authentication, the server returns a token
- Token is saved to local storage (Hive) in `userBox`
- User is redirected to the home screen

### 2. **Auto-Login on App Start**
- When the app launches, it checks for a saved token in local storage
- If a valid token exists:
  - User is automatically logged in
  - Redirected to `AuthSplashScreenPage` which fetches user data
  - User proceeds to the appropriate screen based on their profile
- If no token exists:
  - User is shown the login page

### 3. **Logout**
- User can manually log out from Settings → Logout button
- This clears all stored data including the token
- User is redirected to the login page
- Next app launch will require login

## Implementation Details

### Files Modified

1. **`lib/pages/splash_screen/splash_screen_page.dart`**
   - Added token check on app initialization
   - Auto-redirects to `AuthSplashScreenPage` if token exists
   - Shows login page if no token found

2. **`lib/controllers/user_controller.dart`**
   - Added `isLoggedIn` observable for tracking auth state
   - Added `getToken()` method to retrieve stored token
   - Added `logout()` method for clean logout
   - Added `_checkLoginStatus()` to sync auth state

3. **`lib/pages/home/profile/profile_settings_page.dart`**
   - Updated logout button to use `UserController.logout()`
   - Changed navigation to `Get.offAll()` to clear navigation stack

## Storage

The token is stored using **Hive** (local NoSQL database):
- Box name: `userBox`
- Key: `'token'`
- The token persists across app restarts until explicitly cleared

## Security Considerations

- Token is stored locally on the device
- Token is cleared on logout
- Consider implementing token expiration validation in future updates
- Consider adding biometric authentication for additional security

## Testing

To test the feature:
1. Login with valid credentials
2. Close the app completely
3. Reopen the app
4. You should be automatically logged in without seeing the login screen
5. Use the logout button to test manual logout
6. After logout, app restart should show the login screen

## Future Enhancements

- Add token expiration checking
- Implement refresh token mechanism
- Add biometric authentication option
- Add "Remember me" toggle on login page
- Implement secure storage for sensitive data
