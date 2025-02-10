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

  Future<dynamic> get(String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(Uri.parse('${url}users/'), headers: headers);
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Error();
    }
  }

  Future<dynamic> activate(String access, String email) async {
    final body = {'email': email};
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}users/manage/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Error();
    }
  }

  Future<dynamic> info(String access, String uuid) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response =
          await client.get(Uri.parse('${url}users/$uuid/'), headers: headers);
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Error();
    }
  }

  Future<dynamic> password(String access, String password) async {
    final body = {'password': password};
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.patch(Uri.parse('${url}users/password/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw Error();
    }
  }

  Future<dynamic> logout(String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(
        Uri.parse('${url}users/logout/'),
        headers: headers,
      );
    } catch (e) {
      throw Error();
    }

    if (response.statusCode == HttpStatus.ok) {
      return {};
    } else {
      throw Error();
    }
  }
}
