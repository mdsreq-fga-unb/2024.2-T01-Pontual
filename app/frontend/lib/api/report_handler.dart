import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class ReportHandler extends ApiHandler {
  Future<dynamic> get(String access,
      {int? id, String? start, String? end}) async {
    http.Response response;

    if (start != null && end == null) {
      throw ErrorDescription("Informe a data final!");
    }

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(
        Uri.parse(
            '${url}api/report/${id == null ? "" : "$id/"}?${start == null ? "" : "start=$start&end=$end"}'),
        headers: headers,
      );
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      String decodedBody = utf8.decode(response.bodyBytes);
      return json.decode(decodedBody);
    } else {
      throw ErrorDescription("Verifique as datas de entrada!");
    }
  }

  Future<dynamic> post(String access, String start, String end) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/report/$start/$end/'),
          headers: headers);
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Verifique as datas de entrada!");
    }
  }

  Future<dynamic> requestReview(
      String access, DateTime start, DateTime end) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(
          Uri.parse(
              '${url}api/report/${start.toIso8601String().substring(0, 10)}/${end.toIso8601String().substring(0, 10)}/?r=t'),
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

  Future<dynamic> reviewUnique(String access, int id) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/report/$id/'),
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

  Future<dynamic> toggle(String access, int id, List<bool> toToggle) async {
    final body = {
      "toggle": toToggle,
    };
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.patch(Uri.parse('${url}api/report/$id/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Verifique as datas de entrada!");
    }
  }

  Future<dynamic> review(String access, int id) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.patch(Uri.parse('${url}api/report/review/$id/'),
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
