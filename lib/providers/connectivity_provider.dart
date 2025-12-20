import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider with ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  bool _wasOffline = false;
  bool get isOnline => _connectionStatus != ConnectivityResult.none;
  bool get wasOffline => _wasOffline;

  ConnectivityProvider() {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      _connectionStatus = ConnectivityResult.none;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasOnline = isOnline;
    _connectionStatus = result;
    
    if (!wasOnline && isOnline) {
      _wasOffline = true;
      Future.delayed(const Duration(seconds: 3), () {
        _wasOffline = false;
        notifyListeners();
      });
    }
    
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
