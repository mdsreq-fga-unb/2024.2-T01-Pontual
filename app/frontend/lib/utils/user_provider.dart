import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isAdmin = false;

  String _accessToken = "";
  String _uuid = "";
  String _email = "";
  String _name = "";

  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;

  String get accessToken => _accessToken;
  String get email => _email;
  String get name => _name;
  String get uuid => _uuid;

  void login(
      String email, String name, String token, String uuid, bool isAdmin) {
    _isAuthenticated = true;
    _accessToken = token;
    _email = email;
    _name = name;
    _uuid = uuid;
    _isAdmin = isAdmin;

    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isAdmin = false;

    _accessToken = "";
    _email = "";
    _name = "";
    _uuid = "";

    notifyListeners();
  }
}
