import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api/api_handler.dart';
import 'package:http/http.dart' as http;

class StatusHandler extends ApiHandler {
  Future<dynamic> entry(int classy, DateTime startTime, DateTime endTime,
      DateTime register, String access) async {
    final body = {
      "kind": "std",
      "classy": classy,
      "expected": [startTime.toIso8601String(), endTime.toIso8601String()],
      "register": [register.toIso8601String()]
    };
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/status/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> patch(int id, DateTime? registerStart, DateTime? registerEnd,
      String? notes, String access) async {
    dynamic body;

    if (registerStart == null && registerEnd == null) {
      body = {"notes": notes == null ? "" : notes.toLowerCase()};
    } else if (registerStart != null && registerEnd == null) {
      body = {
        "notes": notes == null ? "" : notes.toLowerCase(),
        "register": [registerStart.toIso8601String()]
      };
    } else if (registerStart != null && registerEnd != null) {
      body = {
        "notes": notes == null ? "" : notes.toLowerCase(),
        "register": [
          registerStart.toIso8601String(),
          registerEnd.toIso8601String()
        ]
      };
    }

    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.patch(Uri.parse('${url}api/status/$id/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> close(int classy, String notes, DateTime startTime,
      DateTime endTime, String access) async {
    final body = {
      "kind": "std",
      "classy": classy,
      "notes": notes.toLowerCase(),
      "expected": [startTime.toIso8601String(), endTime.toIso8601String()],
    };
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/status/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> post(String? uuid, int? classy, String kind, DateTime start,
      DateTime end, String access) async {
    final body = {
      "kind": kind,
      "user": uuid,
      "classy": classy,
      "expected": [start.toIso8601String(), end.toIso8601String()]
    };
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.post(Uri.parse('${url}api/status/'),
          headers: headers, body: json.encode(body));
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.created) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }

  Future<dynamic> getByRange(String start, String end, String access,
      {String? tp, int? at}) async {
    http.Response response;

    headers["Authorization"] = "Bearer $access";
    try {
      response = await client.get(
          Uri.parse('${url}api/status/$start/$end/?${tp != null ? (at != null ? "tp=$tp&" : "tp=$tp") : ""}${at != null ? "at=$at" : ""}'),
          headers: headers);
    } catch (e) {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }

    if (response.statusCode == HttpStatus.ok) {
      return json.decode(response.body);
    } else {
      throw ErrorDescription("Houve um erro, tente novamente mais tarde!");
    }
  }
}
