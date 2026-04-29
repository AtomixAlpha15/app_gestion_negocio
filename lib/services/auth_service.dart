import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

const _kCurrentUserIdKey = 'current_user_id';

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final data = await apiService.register(
      email: email,
      password: password,
      displayName: displayName,
    );
    await _saveUserId(data['user']['id'] as String);
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final data = await apiService.login(email: email, password: password);
    await _saveUserId(data['user']['id'] as String);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await apiService.getCurrentUser();
  }

  Future<void> logout() async {
    await apiService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrentUserIdKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await const FlutterSecureStorage().read(key: 'jwt_token');
    return token != null;
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrentUserIdKey, userId);
  }
}
