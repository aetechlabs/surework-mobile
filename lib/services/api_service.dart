import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../config/app_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = AppConfig.apiBaseUrl;
  String? _token;

  Future<String?> getToken() async {
    if (_token != null) return _token;
    
    final box = await Hive.openBox('auth');
    _token = box.get('token');
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final box = await Hive.openBox('auth');
    await box.put('token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final box = await Hive.openBox('auth');
    await box.delete('token');
  }

  Map<String, String> _headers([String? token]) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    final authToken = token ?? _token;
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _headers(),
      body: jsonEncode(data),
    ).timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      url,
      headers: _headers(),
    ).timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      url,
      headers: _headers(),
      body: jsonEncode(data),
    ).timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(
      url,
      headers: _headers(),
    ).timeout(AppConfig.apiTimeout);

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw ApiException(
        message: body['message'] ?? 'An error occurred',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
