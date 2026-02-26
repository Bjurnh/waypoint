# Lazy Load Storage Implementation Plan

## Information Gathered:
- `lib/main.dart`: Previously blocked app startup with `await StorageService.loadPrayers()` and `await NotificationService.initialize()`
- `lib/state/app_state.dart`: Loaded all data synchronously in constructor
- `lib/services/storage_service.dart`: Uses SharedPreferences for persistence
- `lib/services/notification_service.dart`: Initializes timezone database on startup

## Plan - COMPLETED:
- [x] `lib/main.dart`
  - [x] Remove blocking `await StorageService.loadPrayers()` call
  - [x] Make notification initialization non-blocking
  - [x] Add splash/loading screen while services initialize in background

- [x] `lib/state/app_state.dart`
  - [x] Add `isInitialized` flag to track loading state
  - [x] Make data loading lazy - load on first access instead of constructor
  - [x] Add `initialize()` method for explicit initialization when needed

- [x] `lib/widgets/splash_screen.dart` (created new)
  - [x] Create a simple splash screen widget
  - [x] Show loading indicator while services initialize

## Dependent Files Edited:
- `lib/main.dart`
- `lib/state/app_state.dart`
- `lib/widgets/splash_screen.dart` (new file)

## Summary of Changes:
1. **AppState** - Now has lazy loading with `isInitialized` flag and `initialize()` method
2. **main.dart** - Shows splash screen immediately, initializes services in background
3. **SplashScreen** - New widget showing app logo and loading indicator

## Expected Improvement:
- App now shows splash screen immediately (no blocking)
- Storage and notification initialization happens in background
- User sees UI faster while data loads in background
