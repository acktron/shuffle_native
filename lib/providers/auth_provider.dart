import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final token = await TokenStorage().getAccessToken();
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await AuthService().login(email, password);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> register(String name, String email, String password) async {
    final success = await AuthService().register(name, email, password);
    if (success) {
      _isLoggedIn = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> logout() async {
    await TokenStorage().clearTokens();
    _isLoggedIn = false;
    notifyListeners();
    return true;
  }
}
