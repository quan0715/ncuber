import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:ncuber/constants/constants.dart';

Future<Map<String, dynamic>> ngrokServerConnector(
    Map<String, dynamic> jsonBody) async {
  String serverUrl = NGROK_SERVER_URL;

  final resp = await http.post(Uri.parse(serverUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(jsonBody));

  if (resp.statusCode == 201) {
    return jsonDecode(resp.body);
  } else {
    throw Exception('Failed to post to Ngrok Server.');
  }
}
