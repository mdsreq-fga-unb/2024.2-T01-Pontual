import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class UsersHandler extends ApiHandler {
  Future<dynamic> register(String name, String email, String password) async {
    final bodyRegister = {'name': name, 'email': email, 'password': password};
    http.Response response;

    try {
      response = await client.post(Uri.parse('${url}users/register/'),
          headers: headers, body: json.encode(bodyRegister));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> login(String email, String password, bool? rememberMe) async {
    final body = {
      'email': email,
      'password': password,
      'remember_me': rememberMe
    };
    http.Response response;

    try {
      response = await client.post(Uri.parse('${url}users/login/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde! aqui");
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Verifique seu email ou senha!");
    }
  }

  Future<dynamic> refresh() async {
    http.Response response;

    try {
      response = await client.post(Uri.parse('${url}users/refresh/'),
          headers: headers);
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Error();
    }
  }
}
