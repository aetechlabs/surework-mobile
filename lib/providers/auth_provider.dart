import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _api.getToken();
      
      if (token != null) {
        // Verify token by fetching user profile
        final response = await _api.get('/users/me');
        _user = User.fromJson(response['data']['user']);
        _isAuthenticated = true;
      }
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      await _api.clearToken();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      final response = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final token = response['data']['token'];
      final userData = response['data']['user'];

      await _api.setToken(token);
      _user = User.fromJson(userData);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      _errorMessage = null;
      _isLoading = true;
      notifyListeners();

      final response = await _api.post('/auth/register', {
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role,
      });

      final token = response['data']['token'];
      final userData = response['data']['user'];

      await _api.setToken(token);
      _user = User.fromJson(userData);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _api.patch('/users/me', data);
      _user = User.fromJson(response['data']['user']);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
