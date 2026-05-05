import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // --dart-define=BACKEND_URL=http://192.168.X.X:3000/api  (dispositivo físico)
  // Emulador Android usa 10.0.2.2 automáticamente; Windows usa localhost
  static const String _envUrl = String.fromEnvironment('BACKEND_URL', defaultValue: '');
  static String get baseUrl {
    if (_envUrl.isNotEmpty) return _envUrl;
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/api';
    return 'http://localhost:3000/api';
  }

  static const String _tokenKey = 'jwt_token';

  final FlutterSecureStorage _secureStorage;

  ApiService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Auth endpoints
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'display_name': displayName,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return data;
      } else {
        throw _parseError(response);
      }
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException('Sin conexión al servidor. Comprueba tu red.');
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);
        return data;
      } else {
        throw _parseError(response);
      }
    } on ApiException {
      rethrow;
    } on SocketException {
      throw const ApiException('Sin conexión al servidor. Comprueba tu red.');
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _get('/auth/me');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // GET request
  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
    );
    return _handleResponse(response);
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, {required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, {required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
    );
    return _handleResponse(response);
  }

  // Sync endpoint
  Future<Map<String, dynamic>> sync({required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/sync'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // Helper methods
  Map<String, String> _getHeaders(String? token) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw _parseError(response);
  }

  ApiException _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = body['error'] as String? ?? '';

      // Mapear mensajes del backend a mensajes amigables en español
      if (response.statusCode == 409 ||
          raw.toLowerCase().contains('already exists') ||
          raw.toLowerCase().contains('duplicate') ||
          raw.toLowerCase().contains('ya existe')) {
        return ApiException('Este email ya está registrado.', statusCode: response.statusCode);
      }
      if (response.statusCode == 401 ||
          raw.toLowerCase().contains('invalid credentials') ||
          raw.toLowerCase().contains('incorrect') ||
          raw.toLowerCase().contains('unauthorized')) {
        return ApiException('Email o contraseña incorrectos.', statusCode: response.statusCode);
      }
      if (response.statusCode == 422 || raw.toLowerCase().contains('validation')) {
        return ApiException('Datos inválidos. Revisa los campos.', statusCode: response.statusCode);
      }
      if (response.statusCode == 429) {
        return ApiException('Demasiados intentos. Espera un momento.', statusCode: response.statusCode);
      }
      if (response.statusCode >= 500) {
        return ApiException('Error del servidor. Inténtalo más tarde.', statusCode: response.statusCode);
      }
      return ApiException(raw.isNotEmpty ? raw : 'Error desconocido.', statusCode: response.statusCode);
    } catch (_) {
      return ApiException('Error ${response.statusCode}.', statusCode: response.statusCode);
    }
  }
}
