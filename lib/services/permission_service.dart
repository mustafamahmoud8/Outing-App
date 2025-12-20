import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Check if notification permission is granted
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Request location permission
  static Future<PermissionStatus> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status;
  }

  // Request notification permission
  static Future<PermissionStatus> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status;
  }

  // Request both location and notification permissions
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    final statuses = await [
      Permission.location,
      Permission.notification,
    ].request();
    return statuses;
  }

  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  // Open app settings
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }

  // Show permission dialog
  static Future<bool?> showPermissionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String permissionType,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              permissionType == 'location' ? Icons.location_on : Icons.notifications,
              color: const Color(0xFFEF7A22),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF7A22),
              foregroundColor: Colors.white,
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  // Show settings dialog when permission is permanently denied
  static Future<bool?> showSettingsDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.settings, color: Color(0xFFEF7A22)),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF7A22),
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Request location with user-friendly flow
  static Future<bool> requestLocationWithDialog(BuildContext context) async {
    // Check if already granted
    if (await isLocationPermissionGranted()) {
      return true;
    }

    // Show explanation dialog
    final shouldRequest = await showPermissionDialog(
      context,
      title: 'Location Permission',
      message: 'We need access to your location to show nearby places and enable location sharing in chats.',
      permissionType: 'location',
    );

    if (shouldRequest != true) {
      return false;
    }

    // Request permission
    final status = await requestLocationPermission();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Show settings dialog
      await showSettingsDialog(
        context,
        title: 'Location Permission Required',
        message: 'Location permission is permanently denied. Please enable it in app settings to use location features.',
      );
      return false;
    }

    return false;
  }

  // Request notification with user-friendly flow
  static Future<bool> requestNotificationWithDialog(BuildContext context) async {
    // Check if already granted
    if (await isNotificationPermissionGranted()) {
      return true;
    }

    // Show explanation dialog
    final shouldRequest = await showPermissionDialog(
      context,
      title: 'Notification Permission',
      message: 'Enable notifications to receive updates about new offers, group messages, and plan reminders.',
      permissionType: 'notification',
    );

    if (shouldRequest != true) {
      return false;
    }

    // Request permission
    final status = await requestNotificationPermission();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Show settings dialog
      await showSettingsDialog(
        context,
        title: 'Notification Permission Required',
        message: 'Notification permission is permanently denied. Please enable it in app settings to receive notifications.',
      );
      return false;
    }

    return false;
  }

  // Check and request location service
  static Future<bool> ensureLocationServiceEnabled(BuildContext context) async {
    if (await isLocationServiceEnabled()) {
      return true;
    }

    final shouldEnable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Color(0xFFEF7A22)),
            SizedBox(width: 12),
            Expanded(child: Text('Location Services Disabled')),
          ],
        ),
        content: const Text('Please enable location services to use location features.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
              await Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF7A22),
              foregroundColor: Colors.white,
            ),
            child: const Text('Enable'),
          ),
        ],
      ),
    );

    return shouldEnable ?? false;
  }
}
