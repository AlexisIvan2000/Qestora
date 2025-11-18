import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_end/models/register_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api {
  static const String baseUrl = "http://10.0.2.2:8000";
}

class AuthService {
  static Future<String?> register(RegisterRequest data) async {
    final url = Uri.parse("${Api.baseUrl}/auth/register");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return json["msg"] ?? "Registration successful";
      } else {
        final json = jsonDecode(response.body);
        return "Error: ${json["detail"]}";
      }
    } catch (e) {
      return "Network Error: $e";
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("${Api.baseUrl}/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final storage = FlutterSecureStorage();

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        await storage.write(key: 'token', value: json['access_token']);

        return {'success': true, 'data': json};
      } else {
        final json = jsonDecode(response.body);
        return {'success': false, 'message': json['detail'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network Error: $e'};
    }
  }

  static Future<Map<String, dynamic>?> loginWithGoogle(String idToken) async {
    final url = Uri.parse("${Api.baseUrl}/auth/google");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        const storage = FlutterSecureStorage();
        await storage.write(key: 'token', value: json["access_token"]);

        return json;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  static Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  static Future<Map<String, String>> getAuthHeader() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<String> forgotPassword(String email) async {
    final url = Uri.parse("${Api.baseUrl}/auth/forgot-password?email=$email");

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["msg"] ?? "Password reset link sent.";
      } else {
        final json = jsonDecode(response.body);
        return json["detail"] ?? "Error sending reset link.";
      }
    } catch (e) {
      return "Network Error: $e";
    }
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    final token = await getToken();
    if (token == null) return null;

    final url = Uri.parse("${Api.baseUrl}/auth/me?token=$token");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
