
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      'https://my-users-api.onrender.com';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullName': name,
        'email': email,
        'pwd': password,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'pwd': password,
      }),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }


  Future<Map<String, dynamic>> checkToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/check-token'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getWelcome(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/welcome'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

}
