import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class ClassesHandler extends ApiHandler {
  Future<dynamic> getByRange(String start, String end, String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(Uri.parse('${url}api/classes/$start/$end/'),
          headers: headers);
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Verifique as datas de entrada!");
    }
  }
}
