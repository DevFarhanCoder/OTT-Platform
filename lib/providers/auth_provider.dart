import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        _setError('Invalid email or password');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      final user = await _authService.register(name, email, password);
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        _setError('Registration failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Registration failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
      _currentUser = null;
      _isLoggedIn = false;
      _clearError();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
    }
    
    _setLoading(false);
  }

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
      } else {
        _currentUser = null;
        _isLoggedIn = false;
      }
    } catch (e) {
      _currentUser = null;
      _isLoggedIn = false;
    }
    
    _setLoading(false);
  }

  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedUser = await _authService.updateProfile(profileData);
      if (updatedUser != null) {
        _currentUser = updatedUser;
        _setLoading(false);
        return true;
      } else {
        _setError('Profile update failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _setLoading(true);
    _clearError();
    
    try {
      final success = await _authService.changePassword(oldPassword, newPassword);
      if (success) {
        _setLoading(false);
        return true;
      } else {
        _setError('Password change failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Password change failed: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}