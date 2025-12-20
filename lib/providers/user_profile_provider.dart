import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class UserProfileProvider with ChangeNotifier {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String? _profilePicturePath;

  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String? get profilePicturePath => _profilePicturePath;

  UserProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _fullName = prefs.getString('fullName') ?? '';
    _email = prefs.getString('email') ?? '';
    _phone = prefs.getString('phone') ?? '';
    _profilePicturePath = prefs.getString('profilePicturePath');
    notifyListeners();
  }

  Future<void> updateProfile(String fullName, String email, String phone) async {
    _fullName = fullName;
    _email = email;
    _phone = phone;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    
    notifyListeners();
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      // Get app directory
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(directory.path, fileName);
      
      // Copy image to app directory
      final File savedImage = await imageFile.copy(filePath);
      
      // Delete old profile picture if exists
      if (_profilePicturePath != null) {
        try {
          final oldFile = File(_profilePicturePath!);
          if (await oldFile.exists()) {
            await oldFile.delete();
          }
        } catch (e) {
          print('Error deleting old profile picture: $e');
        }
      }
      
      _profilePicturePath = savedImage.path;
      
      // Save path to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profilePicturePath', savedImage.path);
      
      notifyListeners();
    } catch (e) {
      print('Error saving profile picture: $e');
      rethrow;
    }
  }

  Future<void> removeProfilePicture() async {
    if (_profilePicturePath != null) {
      try {
        final file = File(_profilePicturePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error deleting profile picture: $e');
      }
      
      _profilePicturePath = null;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profilePicturePath');
      
      notifyListeners();
    }
  }

  Future<void> clearProfile() async {
    await removeProfilePicture();
    
    _fullName = '';
    _email = '';
    _phone = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('phone');
    
    notifyListeners();
  }
}
