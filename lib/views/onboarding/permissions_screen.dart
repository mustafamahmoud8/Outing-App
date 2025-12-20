import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:outing/theme/app_colors.dart';
import 'package:outing/views/auth/login_screen.dart';
import 'package:outing/services/notification_service.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _notificationGranted = false;
  bool _locationGranted = false;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final notificationStatus = await Permission.notification.status;
    final locationStatus = await Permission.location.status;
    
    setState(() {
      _notificationGranted = notificationStatus.isGranted;
      _locationGranted = locationStatus.isGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (_isRequesting) return;
    
    setState(() {
      _isRequesting = true;
    });

    try {
      // Request notification permission
      final status = await Permission.notification.request();
      
      // Also initialize notification service
      if (status.isGranted) {
        await NotificationService.initialize();
        await NotificationService.requestPermission();
      }
      
      setState(() {
        _notificationGranted = status.isGranted;
      });

      if (!status.isGranted) {
        _showPermissionDialog(
          'Notification Permission Required',
          'Please enable notifications in your device settings to receive important updates.',
        );
      }
    } finally {
      setState(() {
        _isRequesting = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    if (_isRequesting) return;
    
    setState(() {
      _isRequesting = true;
    });

    try {
      final status = await Permission.location.request();
      
      setState(() {
        _locationGranted = status.isGranted || status.isLimited;
      });

      if (status.isGranted || status.isLimited) {
        // Check if Location Services are enabled
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        
        if (!serviceEnabled) {
          // Show dialog to enable location services
          final shouldEnable = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.location_off, color: AppColors.error),
                  SizedBox(width: 12),
                  Expanded(child: Text('Enable Location Services')),
                ],
              ),
              content: const Text(
                'Location services are turned off. Please enable them in your device settings to use location features.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Later'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context, true);
                    await Geolocator.openLocationSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
      } else if (!status.isGranted && !status.isLimited) {
        _showPermissionDialog(
          'Location Permission Required',
          'Please enable location access in your device settings to find places near you.',
        );
      }
    } finally {
      setState(() {
        _isRequesting = false;
      });
    }
  }

  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestAllPermissions() async {
    if (!_notificationGranted) {
      await _requestNotificationPermission();
    }
    
    if (!_locationGranted) {
      await _requestLocationPermission();
    }
  }

  Future<void> _completeSetup() async {
    // Check if both permissions are granted
    if (!_notificationGranted || !_locationGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grant all required permissions to continue'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('permissionsRequested', true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  bool get _canContinue => _notificationGranted && _locationGranted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.security,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Required Permissions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Description
              const Text(
                'These permissions are required to use the app',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Notifications Permission
              _buildPermissionCard(
                icon: Icons.notifications_active,
                title: 'Notifications',
                description: 'Required for updates and recommendations',
                isGranted: _notificationGranted,
                isRequired: true,
                onTap: _requestNotificationPermission,
              ),
              const SizedBox(height: 16),
              
              // Location Permission
              _buildPermissionCard(
                icon: Icons.location_on,
                title: 'Location',
                description: 'Required to find places near you',
                isGranted: _locationGranted,
                isRequired: true,
                onTap: _requestLocationPermission,
              ),
              
              const Spacer(),
              
              // Request All Button (if not all granted)
              if (!_canContinue)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isRequesting ? null : _requestAllPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isRequesting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Grant Permissions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              
              if (!_canContinue) const SizedBox(height: 16),
              
              // Continue Button (only enabled when all granted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canContinue ? _completeSetup : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue ? AppColors.success : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_canContinue)
                        const Icon(Icons.check_circle, color: Colors.white),
                      if (_canContinue) const SizedBox(width: 8),
                      Text(
                        _canContinue ? 'Continue' : 'Permissions Required',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required bool isRequired,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isGranted ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isGranted ? AppColors.success : (isRequired ? Colors.red.shade300 : Colors.grey.shade300),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isGranted ? AppColors.success : (isRequired ? Colors.red : AppColors.primary))
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isGranted ? AppColors.success : (isRequired ? Colors.red : AppColors.primary),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isRequired) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'REQUIRED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isGranted ? Icons.check_circle : Icons.warning_amber_rounded,
              color: isGranted ? AppColors.success : Colors.red,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
