import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Mock API endpoints - replace with real API
  static const String _baseUrl = 'https://api.emmarott.com';

  Future<User?> login(String email, String password) async {
    try {
      // Mock login - replace with real API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock successful login
      if (email.contains('@') && password.length >= 6) {
        final user = User(
          id: '1',
          email: email,
          name: email.split('@')[0],
          createdAt: DateTime.now(),
          isVerified: true,
          subscriptionType: 'free',
        );
        
        await _saveUserData(user);
        await _saveToken('mock_token_${user.id}');
        
        return user;
      }
      
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      // Mock registration - replace with real API call
      await Future.delayed(const Duration(seconds: 2));
      
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        createdAt: DateTime.now(),
        isVerified: false,
        subscriptionType: 'free',
      );
      
      await _saveUserData(user);
      await _saveToken('mock_token_${user.id}');
      
      return user;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);
      
      if (token != null && userJson != null) {
        final userData = jsonDecode(userJson);
        return User.fromJson(userData);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<User?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final currentUser = await getCurrentUser();
      if (currentUser == null) return null;
      
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedUser = currentUser.copyWith(
        name: profileData['name'] ?? currentUser.name,
        phone: profileData['phone'] ?? currentUser.phone,
        profileImage: profileData['profile_image'] ?? currentUser.profileImage,
      );
      
      await _saveUserData(updatedUser);
      return updatedUser;
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock validation
      if (oldPassword.length >= 6 && newPassword.length >= 6) {
        return true;
      }
      
      return false;
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock success
      return email.contains('@');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<bool> verifyEmail(String verificationCode) async {
    try {
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));
      
      final currentUser = await getCurrentUser();
      if (currentUser == null) return false;
      
      final updatedUser = currentUser.copyWith(isVerified: true);
      await _saveUserData(updatedUser);
      
      return true;
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
}