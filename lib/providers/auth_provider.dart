import 'package:flutter/material.dart';
import '../services/token_storage.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  int _userId = 0;
  int get userId => _userId;

  Future<void> checkLoginStatus() async {
    final token = await TokenStorage().getAccessToken();
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await AuthService().login(email, password);
    if (success > 0) {
      _userId = success;
      _isLoggedIn = true;
      notifyListeners();
    }
    return success > 0;
  }

  Future<bool> googleLogin(String idToken) async {
    final success = await AuthService().googleLogin(idToken);
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
