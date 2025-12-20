import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:outing/services/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:outing/config/api_config.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  
  bool _isAuthenticated = false;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  String? get userId => _currentUser?.uid;
  String? get userName => _currentUser?.displayName ?? 'User';
  String? get userEmail => _currentUser?.email;
  String? get userPhotoUrl => _currentUser?.photoURL;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isEmailVerified => _firebaseAuthService.isEmailVerified;

  AuthProvider() {
    // Listen to auth state changes
    _firebaseAuthService.authStateChanges.listen((User? user) {
      _currentUser = user;
      _isAuthenticated = user != null;
      notifyListeners();
    });
  }

  // Initialize - check for current user
  Future<void> initialize() async {
    _currentUser = _firebaseAuthService.currentUser;
    _isAuthenticated = _currentUser != null;
    notifyListeners();
  }

  // Register with email and password
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuthService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (userCredential != null) {
        _currentUser = userCredential.user;
        _isAuthenticated = true;
        
        // Save user data for profile
        await _saveUserData(name, email);
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuthService.signInWithEmail(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        _currentUser = userCredential.user;
        _isAuthenticated = true;
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login with Google
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuthService.signInWithGoogle();

      if (userCredential != null) {
        _currentUser = userCredential.user;
        _isAuthenticated = true;
        
        // Save user data locally
        if (_currentUser != null) {
          await _saveUserData(
            _currentUser!.displayName ?? 'User',
            _currentUser!.email ?? '',
          );
          
          // Sync with backend
          await _syncWithBackend();
        }
        
        _isLoading = false;
        notifyListeners();
        return true;
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sync user with backend
  Future<void> _syncWithBackend() async {
    if (_currentUser == null) return;
    
    try {
      final token = await _currentUser!.getIdToken();
      
      // Send user data to backend
      final response = await http.post(
        Uri.parse('${ApiConfig.authEndpoint}/google'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'uid': _currentUser!.uid,
          'email': _currentUser!.email,
          'displayName': _currentUser!.displayName,
          'photoURL': _currentUser!.photoURL,
        }),
      );
      
      if (response.statusCode == 200) {
        print('User synced with backend successfully');
      } else {
        print('Failed to sync with backend: ${response.statusCode}');
      }
    } catch (e) {
      print('Error syncing with backend: $e');
      // Don't fail the login if backend sync fails
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseAuthService.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      
      // Clear saved data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fullName');
      await prefs.remove('email');
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to sign out';
      notifyListeners();
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firebaseAuthService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile({String? displayName, String? photoURL}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firebaseAuthService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      
      await _firebaseAuthService.reloadUser();
      _currentUser = _firebaseAuthService.currentUser;
      
      if (displayName != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fullName', displayName);
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      await _firebaseAuthService.sendEmailVerification();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _firebaseAuthService.deleteAccount();
      _currentUser = null;
      _isAuthenticated = false;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save user data for profile
  Future<void> _saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', name);
    await prefs.setString('email', email);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Backward compatibility methods (for existing code)
  Future<bool> registerOwner(String name, String email, String password) async {
    return await register(name, email, password);
  }

  Future<bool> loginOwner(String email, String password) async {
    return await login(email, password);
  }

  Future<bool> loginWithFacebook() async {
    // Facebook login not implemented with Firebase yet
    _error = 'Facebook login not available';
    notifyListeners();
    return false;
  }

  Future<void> tryAutoLogin() async {
    await initialize();
  }

  String? get token => _currentUser?.uid;
}
