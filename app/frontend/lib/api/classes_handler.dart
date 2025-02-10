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

  Future<dynamic> getByStart(String start, String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(Uri.parse('${url}api/classes/$start/'),
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

  Future<dynamic> getAllDelayed(String start, String end, String access) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(
          Uri.parse(
              '${url}api/classes/${start}T00:00:00/${end}T23:59:59/?tp=delayed'),
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

  Future<dynamic> post(String access, Map<String, dynamic> data) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/classes/'),
          headers: headers, body: json.encode(data));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Verifique os dados de entrada!");
    }
  }

  Future<dynamic> delete(String access, int id) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.delete(Uri.parse('${url}api/classes/$id/'),
          headers: headers);
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.noContent) {
      return {};
    } else {
      throw ErrorDescription("Verifique os dados de entrada!");
    }
  }
}
