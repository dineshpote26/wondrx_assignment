import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseApi {

  static const int TIMEOUT_SECONDS = 30;

  BaseApi();

  Future<dynamic> getHttp(String url) async {
    final response = await http.get(url).timeout(
        const Duration(seconds: TIMEOUT_SECONDS),
        onTimeout: _onTimeout);

    final String res = response.body;
    final int statusCode = response.statusCode;

    if (res == null || statusCode != 200)
      throw new Exception(
          "Error fetching data from server statusCode: $statusCode");

    final responseJson = json.decode(res);

    return responseJson;
  }

  Future<dynamic> postHttp(String url, {Map body, Map header}) async {
    String newBody = json.encode(body);
    final response = await http
        .post(url, body: newBody, headers: header)
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout);
    debugPrint(response.body);
    final responseJson = response.body;
    return responseJson;
  }

  Future<http.Response> _onTimeout() {
    throw new SocketException("Timeout during request");
  }
}
