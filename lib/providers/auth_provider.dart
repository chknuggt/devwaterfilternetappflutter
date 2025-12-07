import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Mock AuthProvider - works without Firebase
/// Any email/password combination will work for login
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isAdmin = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _isAdmin;

  // Sign in - mock implementation (always succeeds)
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if admin login
    _isAdmin = email.toLowerCase().contains('admin');

    _currentUser = UserModel(
      uid: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      isEmailVerified: true,
      role: _isAdmin ? UserRole.admin : UserRole.user,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Sign up - mock implementation (always succeeds)
  Future<bool> signUp(String email, String password, String displayName) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = UserModel(
      uid: 'mock-user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
      isEmailVerified: false,
      role: UserRole.user,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    _currentUser = null;
    _isAdmin = false;

    _isLoading = false;
    notifyListeners();
  }

  // Update user data
  void updateUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  // Toggle admin status (for testing)
  void toggleAdmin() {
    _isAdmin = !_isAdmin;
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        role: _isAdmin ? UserRole.admin : UserRole.user,
      );
    }
    notifyListeners();
  }
}
