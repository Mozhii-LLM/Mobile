import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// LanguageService - Manages app language/localization settings
/// 
/// This is a singleton service that:
/// - Tracks the current app language
/// - Persists language preference using SharedPreferences
/// - Provides list of supported languages
/// - Notifies listeners when language changes
class LanguageService extends ChangeNotifier {
  // Singleton pattern - ensures only one instance exists
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  // Current selected language
  String _currentLanguage = 'English';

  // Supported languages for Mozhii (Tamil LLM focus)
  static const List<String> supportedLanguages = [
    'English',
    'தமிழ் (Tamil)',
    'සිංහල (Sinhala)',
  ];

  // Language codes for API calls
  static const Map<String, String> languageCodes = {
    'English': 'en',
    'தமிழ் (Tamil)': 'ta',
    'සිංහල (Sinhala)': 'si',
  };

  // Public getter for current language
  String get currentLanguage => _currentLanguage;

  // Get language code for API calls
  String get currentLanguageCode => languageCodes[_currentLanguage] ?? 'en';

  /// Initialize the service - loads saved language preference
  /// Call this when the app starts
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('appLanguage') ?? 'English';
    notifyListeners();
  }

  /// Set the app language and save preference
  Future<void> setLanguage(String language) async {
    if (!supportedLanguages.contains(language)) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', language);
    _currentLanguage = language;
    
    // Notify all listeners (screens) to rebuild
    notifyListeners();
  }
}
