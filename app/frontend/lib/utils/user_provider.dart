import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _accessToken = "";
  bool _isLoading = true;
  String _email = "";
  String _name = "";

  bool get isAuthenticated => _isAuthenticated;
  String get accessToken => _accessToken;
  bool get isLoading => _isLoading;
  String get email => _email;
  String get name => _name;

  set loading(bool value) {
    _isLoading = value;
  }

  void login(String email, String name, String token) {
    _isAuthenticated = true;
    _accessToken = token;
    _email = email;
    _name = name;

    loading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _accessToken = "";
    _email = "";
    _name = "";

    loading = false;
    notifyListeners();
  }
}
