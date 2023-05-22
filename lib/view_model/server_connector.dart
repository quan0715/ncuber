import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:ncuber/constants/constants.dart';
import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8(")J@NcRfUjXn2r5u8");
const clientId = 'iBTFJjVUJQ7uZa4MVLXRcM2WLN6S1P';
// final body_key = Key.fromUtf8("UjXn2r5u8x/A?D(G");
// final iv = IV.fromLength(16);

Future<Map<String, dynamic>> serverConnector(
    Map<String, dynamic> jsonBody) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'clientId': clientId,
  };

  final encrypter = Encrypter(AES(key));

  String jsonEncodedHeader = jsonEncode(headers);
  String encryptedHeader = encrypter.encrypt(jsonEncodedHeader).base64;

  String jsonEncodedBody = jsonEncode(jsonBody);
  String encryptedBody = encrypter.encrypt(jsonEncodedBody).base64;

  final resp = await http.post(Uri.parse(SERVER_URL),
      headers: <String, String>{"Encrypted-Header": encryptedHeader},
      body: encryptedBody);

  if (resp.statusCode == 200) {
    String? unDecodedHeader = resp.headers['Encrypted-Header'];
    String decodedHeader =
        encrypter.decrypt(Encrypted.fromBase64(unDecodedHeader!));
    Map<String, dynamic> realHeader = jsonDecode(decodedHeader);

    if (realHeader['clientId'] == clientId) {
      String unDecodedBody = resp.body;
      String decodedBody =
          encrypter.decrypt(Encrypted.fromBase64(unDecodedBody));
      Map<String, dynamic> realBody = jsonDecode(decodedBody);

      return realBody;
    } else {
      throw Exception('Server give wrong clientId');
    }
  } else {
    throw Exception('Failed to post to server.');
  }
}
