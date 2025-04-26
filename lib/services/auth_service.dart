import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shuffle_native/constants.dart';
import 'token_storage.dart';

class AuthService {
  // final String baseUrl = ''; // replace with your server URL

  Future<int> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login/'), // adjust this path as needed
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final access = data['access'];
      final refresh = data['refresh'];

      if (access != null && refresh != null) {
        await TokenStorage().saveTokens(access, refresh);
        return data['user_id']; // Assuming user_id is returned in the response
      }
    }
    return 0; 
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register/'), // adjust this path as needed
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

  Future<int> getUserId() async {
    final accessToken = await TokenStorage().getAccessToken();
    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/get_user_id/'), // adjust this path as needed
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user_id']; // Assuming user_id is returned in the response
      }
    }
    return 0; 
  }
}
