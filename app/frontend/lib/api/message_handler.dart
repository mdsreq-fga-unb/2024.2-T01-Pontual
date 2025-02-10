import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class MessageHandler extends ApiHandler {
  Future<dynamic> get(String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response =
          await client.get(Uri.parse('${url}api/message/'), headers: headers);
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      String decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<void> post(String access, int id) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(
        Uri.parse('${url}api/message/'),
        headers: headers,
        body: json.encode({"pk": id}),
      );
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }
}
