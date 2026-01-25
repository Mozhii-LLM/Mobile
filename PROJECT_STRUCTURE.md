# Mozhii Mobile App

A Flutter-based mobile application with a modern chat interface.

## Project Structure

```
lib/
├── main.dart                    # App entry point with navigation logic
├── constants/
│   └── app_constants.dart       # Colors, gradients, and text styles
├── models/
│   └── chat_message.dart        # Data models for chat messages
├── screens/
│   ├── splash_screen.dart       # Splash screen (shows once)
│   ├── home_screen.dart         # Main chat interface
│   └── settings_screen.dart     # Settings screen
└── widgets/
    ├── app_drawer.dart          # Navigation drawer/menu
    └── chat_bubble.dart         # Chat message bubble widget
```

## Features

- ✅ **Splash Screen**: Shows only once on first launch
- ✅ **Home Screen**: Chat interface with input controls
- ✅ **Navigation Drawer**: Menu with collections and settings access
- ✅ **Settings Screen**: User profile, language, theme, and preferences
- ✅ **All buttons functional**: Menu, profile, input controls, etc.

## Running the App

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

## Screens

### 1. Splash Screen
- Displays app logo and "Get Started" button
- Only shows on first launch
- Navigates to Home Screen after clicking "Get Started"

### 2. Home Screen
- Top bar with menu, logo, and profile buttons
- Chat area with messages
- Bottom input bar with add, text input, image, and microphone buttons

### 3. Navigation Drawer
- Search bar
- New Chat button
- Collections list (Tamil LLM Concepts, Datasets, Fine-tuning LLMs)
- Settings button
- Language selector

### 4. Settings Screen
- User profile information
- Account section (Subscription, Upgrade)
- App settings (Language, Theme, Auto-correct)
- Logout option

## Design Features

- Dark blue theme matching your design
- Gradient logo effect
- Smooth navigation between screens
- Persistent state management using SharedPreferences
- Responsive UI components

## Technologies Used

- Flutter
- Dart
- SharedPreferences for state management
