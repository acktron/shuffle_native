import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shuffle_native/constants.dart';
import 'token_storage.dart';

class AuthService {
  // final String baseUrl = ''; // replace with your server URL

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'), // adjust this path as needed
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final access = data['access'];
      final refresh = data['refresh'];

      if (access != null && refresh != null) {
        await TokenStorage().saveTokens(access, refresh);
        return true;
      }
    }
    return false; 
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'), // adjust this path as needed
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final access = data['access'];
      final refresh = data['refresh'];

      if (access != null && refresh != null) {
        await TokenStorage().saveTokens(access, refresh);
        return true;
      }
    }
    return false;
  }
}
