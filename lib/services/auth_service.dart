import 'dart:convert';
import 'package:dream_pos/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  Future<User> login(String email, String password) async {
    try {
      debugPrint(email);
      debugPrint(password);
      final response = await http.post(
        Uri.parse(
          ApiConstants.login,
        ), // Adjusted to common nodejs pattern based on typical structures
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
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
          ApiConstants.register,
        ), // Adjusted to strictly RESTful /users usually
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      debugPrint(response.body);
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = User.fromJson(data);
        if (user.token != null) await _saveToken(user.token!);
        return user;
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
