import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // Using 10.0.2.2 for Android emulator localhost access.
  // Change to your actual backend URL if running on a real device or hosted server.
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/users/login',
        ), // Adjusted to common nodejs pattern based on typical structures
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the response structure has user data directly or inside a 'user' key
        // and token might be at top level.
        // Adjusting based on typical node responses: { token: "...", user: { ... } } or just properties.

        final userMap = data;
        // If the backend returns { "token": "...", "user": { ... } }
        if (userMap.containsKey('user')) {
          final user = User.fromJson(userMap['user']);
          final token = userMap['token'];
          await _saveToken(token);
          return User(
            id: user.id,
            name: user.name,
            email: user.email,
            token: token,
          );
        } else {
          // Fallback if data is flat
          final user = User.fromJson(userMap);
          if (user.token != null) await _saveToken(user.token!);
          return user;
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to login');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/users',
        ), // Adjusted to strictly RESTful /users usually
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userMap = data;

        if (userMap.containsKey('user')) {
          final user = User.fromJson(userMap['user']);
          final token = userMap['token'];
          await _saveToken(token);
          return User(
            id: user.id,
            name: user.name,
            email: user.email,
            token: token,
          );
        } else {
          final user = User.fromJson(userMap);
          if (user.token != null) await _saveToken(user.token!);
          return user;
        }
      } else {
        final body = jsonDecode(response.body);
        throw Exception(body['message'] ?? 'Failed to register');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _saveToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
