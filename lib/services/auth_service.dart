
import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'base_api_service.dart';

class AuthService {
  final BaseApiService _api = BaseApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<Map<String, dynamic>> registerOwner(String name, String email, String password) async {
    try {
      return await _api.post('/auth/owner/register', {
        'name': name,
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Registration failed: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>> loginOwner(String email, String password) async {
    try {
      return await _api.post('/auth/owner/login', {
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Login failed: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        return await _api.post('/auth/facebook', {
          'accessToken': accessToken.token,
        });
      } else {
        throw Exception('Facebook login cancelled or failed');
      }
    } catch (e) {
      throw Exception('Facebook login failed: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        return await _api.post('/auth/google', {
          'accessToken': idToken,
        });
      } else {
        throw Exception('Failed to get Google ID token');
      }
    } catch (e) {
      throw Exception('Google login failed: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      await _api.post('/auth/send-otp', {
        'email': email,
      });
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    try {
      return await _api.post('/auth/verify-otp', {
        'email': email,
        'otp': otp,
      });
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  // Test backend connection
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/health'),
      ).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
