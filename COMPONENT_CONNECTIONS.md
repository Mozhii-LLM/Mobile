# Mozhii App - Component Connections

## File Organization

### 1. Entry Point
- **main.dart**: App initialization
  - Checks if splash screen has been shown
  - Routes to either SplashScreen or HomeScreen

### 2. Constants
- **app_constants.dart**: Centralized styling
  - Colors (dark blue theme)
  - Text styles
  - Gradients

### 3. Models
- **chat_message.dart**: Data structures
  - ChatMessage: Represents a single message
  - ChatCollection: Menu collections

### 4. Screens
- **splash_screen.dart**: First-time launch screen
  - Shows Mozhii logo
  - "Get Started" button
  - Sets flag in SharedPreferences
  - Navigates to HomeScreen

- **home_screen.dart**: Main chat interface
  - Top bar with menu, logo, profile
  - Chat message display
  - Bottom input bar with controls
  - Uses AppDrawer for menu
  - Uses ChatBubble for messages

- **settings_screen.dart**: User settings
  - Profile information
  - Subscription details
  - App preferences (language, theme)
  - Logout functionality

### 5. Widgets (Reusable Components)
- **app_drawer.dart**: Side navigation menu
  - Search bar
  - Collections list
  - Settings navigation
  - Language selector

- **chat_bubble.dart**: Message display
  - User vs AI messages
  - Avatar icons
  - Action buttons (copy, check)

## Navigation Flow

```
App Start
    ↓
main.dart (AppInitializer)
    ↓
Check SharedPreferences
    ↓
    ├─→ First Launch → SplashScreen
    │                      ↓
    │                  Click "Get Started"
    │                      ↓
    │                  Set flag + Navigate
    │                      ↓
    └─→ Return Visit → HomeScreen
                           ↓
                      ┌────┴────┐
                      │         │
                  Drawer    Settings
                 (Menu)    (Settings Screen)
```

## Button Functions

### Splash Screen
- ✅ **Get Started**: Saves preference, navigates to home

### Home Screen
- ✅ **Menu (☰)**: Opens navigation drawer
- ✅ **Profile (A)**: Profile indicator (can add tap action)
- ✅ **Add (+)**: Ready for content addition
- ✅ **Text Input**: Sends messages to chat
- ✅ **Image (📷)**: Shows coming soon message
- ✅ **Microphone (🎤)**: Shows coming soon message

### Drawer
- ✅ **Search**: Search functionality ready
- ✅ **New Chat**: Closes drawer, ready for new chat
- ✅ **Settings**: Navigates to settings screen
- ✅ **Collections**: Display in list

### Settings Screen
- ✅ **Close (X)**: Returns to previous screen
- ✅ **Subscription**: Shows current plan
- ✅ **Upgrade**: Coming soon message
- ✅ **Language**: Ready for language selection
- ✅ **Theme**: Ready for theme selection
- ✅ **Auto-correct Toggle**: Fully functional
- ✅ **Logout**: Shows confirmation dialog

## Key Features Implemented

1. **Splash Screen Logic**: Only shows once using SharedPreferences
2. **Complete Navigation**: All screens connected properly
3. **Functional Buttons**: All interactive elements working
4. **Consistent Theme**: Dark blue design matching mockups
5. **Gradient Logo**: Applied consistently across screens
6. **Modular Architecture**: Separate files for maintainability
