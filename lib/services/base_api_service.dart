import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Base API Service for all HTTP requests
/// Provides centralized error handling and request management
class BaseApiService {
  final String? token;

  BaseApiService({this.token});

  /// GET Request
  Future<dynamic> get(String endpoint) async {
    if (ApiConfig.debugMode) {
      _logRequest('GET', endpoint, null);
    }

    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (ApiConfig.debugMode) {
        _logResponse(response.statusCode, response.body);
      }

      return _handleResponse(response);
    } catch (e) {
      if (ApiConfig.debugMode) {
        _logError(e);
      }
      throw _handleError(e);
    }
  }

  /// POST Request
  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    if (ApiConfig.debugMode) {
      _logRequest('POST', endpoint, body);
    }

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (ApiConfig.debugMode) {
        _logResponse(response.statusCode, response.body);
      }

      return _handleResponse(response);
    } catch (e) {
      if (ApiConfig.debugMode) {
        _logError(e);
      }
      throw _handleError(e);
    }
  }

  /// PUT Request
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    if (ApiConfig.debugMode) {
      _logRequest('PUT', endpoint, body);
    }

    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: _getHeaders(),
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (ApiConfig.debugMode) {
        _logResponse(response.statusCode, response.body);
      }

      return _handleResponse(response);
    } catch (e) {
      if (ApiConfig.debugMode) {
        _logError(e);
      }
      throw _handleError(e);
    }
  }

  /// DELETE Request
  Future<dynamic> delete(String endpoint) async {
    if (ApiConfig.debugMode) {
      _logRequest('DELETE', endpoint, null);
    }

    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}$endpoint'),
            headers: _getHeaders(),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (ApiConfig.debugMode) {
        _logResponse(response.statusCode, response.body);
      }

      return _handleResponse(response);
    } catch (e) {
      if (ApiConfig.debugMode) {
        _logError(e);
      }
      throw _handleError(e);
    }
  }

  /// Get headers with JWT token
  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    } else {
      throw _createException(response);
    }
  }

  /// Create exception from response
  Exception _createException(http.Response response) {
    try {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? error['error'] ?? 'Request failed';
      
      switch (response.statusCode) {
        case 400:
          return Exception('Bad Request: $message');
        case 401:
          return Exception('Unauthorized: Please login again');
        case 403:
          return Exception('Forbidden: $message');
        case 404:
          return Exception('Not Found: $message');
        case 500:
          return Exception('Server Error: $message');
        default:
          return Exception(message);
      }
    } catch (e) {
      return Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  /// Handle errors
  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Network error: $error');
  }

  /// Log request (debug only)
  void _logRequest(String method, String endpoint, dynamic body) {
    print('🔵 $method ${ApiConfig.baseUrl}$endpoint');
    if (body != null) {
      print('📤 Body: ${jsonEncode(body)}');
    }
    if (token != null) {
      print('🔑 Token: ${token!.substring(0, 20)}...');
    }
  }

  /// Log response (debug only)
  void _logResponse(int statusCode, String body) {
    print('🟢 Response: $statusCode');
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        print('📥 Body: $decoded');
      } catch (e) {
        print('📥 Body: $body');
      }
    }
  }

  /// Log error (debug only)
  void _logError(dynamic error) {
    print('🔴 Error: $error');
  }
}
