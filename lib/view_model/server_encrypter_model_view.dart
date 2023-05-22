import 'dart:convert';

import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8(")J@NcRfUjXn2r5u8");
// final body_key = Key.fromUtf8("UjXn2r5u8x/A?D(G");
// final iv = IV.fromLength(16);

class ServerEncrypterModelView {
  final encrypter = Encrypter(AES(key));

  /// string -> aes encrypted -> base64 encrypted
  String encryptToSend(Map<String, dynamic> json) {
    return encrypter.encrypt(jsonEncode(json)).base64;
  }

  /// string -> base64 decrypted -> aes decrypted
  Map<String, dynamic> decryptFromReceiving(String msg) {
    return jsonDecode(encrypter.decrypt(Encrypted.fromBase64(msg)));
  }
}
