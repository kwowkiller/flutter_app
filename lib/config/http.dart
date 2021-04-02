import 'dart:convert';

import 'package:http/http.dart';

var _client = Client();

const _host = 'backend.drgxb.com';

dynamic _parseResponse(Response response) {
  if (response.statusCode > 200) {
    throw Exception('${response.statusCode}:${response.body}');
  }
  return jsonDecode(response.body);
}

Future<T> get<T>(
  String path, {
  Map<String, String>? headers,
  Map<String, String>? query,
}) async {
  var response = await _client.get(
    Uri(
      scheme: "https",
      host: _host,
      path: path,
      queryParameters: query,
    ),
    headers: headers,
  );
  return _parseResponse(response);
}

Future<T> post<T>(
  String path, {
  Map<String, String>? headers,
  Object? body,
}) async {
  var response = await _client.post(
    Uri(
      scheme: "https",
      host: _host,
      path: path,
    ),
    headers: headers,
    body: body,
  );
  return _parseResponse(response);
}
