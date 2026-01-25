import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AuthService - Manages user authentication state across the app
///
/// This is a singleton service that:
/// - Tracks if user is logged in
/// - Stores user info (name, email)
/// - Persists login state using SharedPreferences
/// - Notifies listeners when auth state changes
class AuthService extends ChangeNotifier {
  // Singleton pattern - ensures only one instance exists
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Private state variables
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userInitial = '';

  // Public getters for accessing state
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitial => _userInitial;

  /// Initialize the service - loads saved user data from storage
  /// Call this when the app starts
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    _userInitial = _userName.isNotEmpty ? _userName[0].toUpperCase() : '';
    notifyListeners();
  }

  /// Log in the user and save their data
  Future<void> login({required String name, required String email}) async {
    final prefs = await SharedPreferences.getInstance();

    // Save to persistent storage
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);

    // Update local state
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _userInitial = name.isNotEmpty ? name[0].toUpperCase() : '';

    // Notify all listeners (screens) to rebuild
    notifyListeners();
  }

  /// Log out the user and clear their data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear from persistent storage
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    await prefs.remove('userEmail');

    // Reset local state
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userInitial = '';

    // Notify all listeners (screens) to rebuild
    notifyListeners();
  }
}
