import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:ncuber/constants/constants.dart';
import 'package:ncuber/view_model/server_encrypter_model_view.dart';

Future<Map<String, dynamic>> serverConnector(
    Map<String, dynamic> jsonBody) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'clientId': SERVER_CLIENT_ID,
  };

  final serverEncrypterModelView = ServerEncrypterModelView();

  String encryptedHeader = serverEncrypterModelView.encryptToSend(headers);
  String encryptedBody = serverEncrypterModelView.encryptToSend(jsonBody);

  final resp = await http.post(Uri.parse(SERVER_URL),
      headers: <String, String>{"Encrypted-Header": encryptedHeader},
      body: encryptedBody);

  if (resp.statusCode == 200) {
    String? unDecodedHeader = resp.headers['Encrypted-Header'];
    Map<String, dynamic> realHeader =
        serverEncrypterModelView.decryptFromReceiving(unDecodedHeader!);

    if (realHeader['clientId'] == SERVER_CLIENT_ID) {
      String unDecodedBody = resp.body;
      Map<String, dynamic> realBody =
          serverEncrypterModelView.decryptFromReceiving(unDecodedBody);

      return realBody;
    } else {
      throw Exception('Server give wrong clientId');
    }
  } else {
    throw Exception('Failed to post to server.');
  }
}
