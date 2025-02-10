import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class NotificationHandler extends ApiHandler {
  Future<dynamic> subscribe(String access, dynamic data) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/notification/'),
          headers: headers, body: json.encode(data));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> delete(String access, dynamic data) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.delete(Uri.parse('${url}api/notification/'),
          headers: headers, body: json.encode(data));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.noContent) {
      return {};
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> notify(String access, dynamic data) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/notification/send/'),
          headers: headers, body: json.encode(data));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      return {};
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }
}
