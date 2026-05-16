import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;
  const ApiException(this.message, {this.statusCode, this.code});

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
  static const String _deviceIdKey = 'device_id';

  static const _kTimeout = Duration(seconds: 10);

  final FlutterSecureStorage _secureStorage;

  ApiService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Devuelve un UUID estable por instalación — persiste entre reinicios
  Future<String> getDeviceId() async {
    final stored = await _secureStorage.read(key: _deviceIdKey);
    if (stored != null) return stored;
    final newId = const Uuid().v4();
    await _secureStorage.write(key: _deviceIdKey, value: newId);
    return newId;
  }

  // Auth endpoints
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final deviceId = await getDeviceId();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'display_name': displayName,
          'device_id': deviceId,
        }),
      ).timeout(_kTimeout);

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
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado. Comprueba tu red.');
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool forceLogin = false,
  }) async {
    try {
      final deviceId = await getDeviceId();
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_id': deviceId,
          if (forceLogin) 'force_login': true,
        }),
      ).timeout(_kTimeout);

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
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado. Comprueba tu red.');
    } catch (e) {
      throw ApiException('Error inesperado: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _get('/auth/me');
  }

  // Billing endpoints
  Future<Map<String, dynamic>> getSubscription() async {
    return await _get('/billing/subscription');
  }

  Future<String> createCheckoutSession({
    required String plan,
    required String billingPeriod,
  }) async {
    final data = await post('/billing/create-checkout-session', body: {
      'plan': plan,
      'billing_period': billingPeriod,
    });
    return data['checkout_url'] as String;
  }

  Future<String> getBillingPortalUrl() async {
    final data = await post('/billing/portal', body: {});
    return data['portal_url'] as String;
  }

  // Notifica al backend que esta sesión se cierra y borra el token local
  Future<void> logoutDevice() async {
    try {
      final deviceId = await getDeviceId();
      await post('/auth/logout', body: {'device_id': deviceId});
    } catch (_) {
      // Si el backend no está disponible, igual cerramos sesión localmente
    }
    await _secureStorage.delete(key: _tokenKey);
  }

  // GET request
  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
    ).timeout(_kTimeout);
    return _handleResponse(response);
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, {required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    ).timeout(_kTimeout);
    return _handleResponse(response);
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, {required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    ).timeout(_kTimeout);
    return _handleResponse(response);
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _getHeaders(token),
    ).timeout(_kTimeout);
    return _handleResponse(response);
  }

  // Sync endpoint
  Future<Map<String, dynamic>> sync({required Map<String, dynamic> body}) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/sync'),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    ).timeout(_kTimeout);
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

      // SESSION_CONFLICT: Basic plan con otra sesión activa
      if (response.statusCode == 409 && raw == 'SESSION_CONFLICT') {
        return ApiException(
          body['message'] as String? ?? 'Ya tienes la sesión iniciada en otro dispositivo.',
          statusCode: 409,
          code: 'SESSION_CONFLICT',
        );
      }

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
      if (response.statusCode == 403 && raw == 'PLAN_REQUIRED') {
        return ApiException(
          body['message'] as String? ?? 'Esta función no está disponible en tu plan actual.',
          statusCode: 403,
          code: 'PLAN_REQUIRED',
        );
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
