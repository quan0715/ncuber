import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart' hide Key;
// import 'package:encrypt/encrypt.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/person_model.dart';

/// Reference: https://www.liujunmin.com/flutter/provider/provider_mvvm.html
/// Reference: https://stackoverflow.com/questions/57369129/flutter-http-post-request-error-invalid-media-type-expected
class ServerService {
  // static var key = Key.fromUtf8(")J@NcRfUjXn2r5u8");
  // static var iv = IV.fromUtf8(input)
  // static var encrypter = Encrypter(AES(key));

  // static String encryptedHeader = encrypt(headers);
  static const serverClientId = "iBTFJjVUJQ7uZa4MVLXRcM2WLN6S1P";
  static const serverBaseUrl = 'https://ncuber.pythonanywhere.com';
  // static const serverBaseUrl = 'https://ncuber-backend.fly.dev/';

  static Future<Map<String, dynamic>> postGet(Map<String, dynamic> jsonBody, Uri apiUri) async {
    // final resp = await http.post(Uri.parse(SERVER_URL),
    //     headers: <String, String>{"Encrypted-Header": encryptedHeader},
    //     body: encrypt(jsonBody));
    debugPrint(jsonBody.toString());

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.postUrl(apiUri);
    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.headers.set('clientId', serverClientId);
    request.add(utf8.encode(jsonEncode(jsonBody)));
    HttpClientResponse response = await request.close();

    String reply = await response.transform(utf8.decoder).join();
    debugPrint(reply.toString());
    return jsonDecode(reply);
    // debugPrint(reply);
    // if (response.headers.value('clientId') == serverClientId) {
    //   debugPrint(response.headers.toString());
    //   debugPrint(reply);
    //   httpClient.close();
    //   return jsonDecode(reply);
    // } else {
    //   debugPrint(response.headers.toString());
    //   debugPrint(reply);
    //   httpClient.close();
    //   throw Exception('Failed to post to server.');
    // }

    // String? unDecodedHeader = resp.headers['Encrypted-Header'];
    // Map<String, dynamic> realHeader = decrypt(unDecodedHeader!);

    // if (realHeader['clientId'] == SERVER_CLIENT_ID) {
    //   String unDecodedBody = resp.body;
    //   Map<String, dynamic> realBody = decrypt(unDecodedBody);
    //   return realBody;
    // } else {
    //   throw Exception('Server give wrong clientId');
    // }
    // } else {
    //   throw Exception('Failed to post to server.');
    // }
  }

  // static String encrypt(Map<String, dynamic> json) {
  //   debugPrint("Ready to encrypt");
  //   debugPrint(json.toString());
  //   return encrypter.encrypt(jsonEncode(json)).base64;
  // }

  // static Map<String, dynamic> decrypt(String msg) {
  //   debugPrint("Before decrypt");
  //   debugPrint(msg);
  //   Map<String, dynamic> decrypted =
  //       jsonDecode(encrypter.decrypt(Encrypted.fromBase64(msg)));
  //   debugPrint("Ready to decrypt");
  //   debugPrint(decrypted.toString());
  //   return decrypted;
  // }
}

/// --- server apis ---

Future<List<CarModel>> reqLastNumsOfCarModel() async {
  Map<String, dynamic> body = {
    "type": "req_nums_of_cars",
    // "numbers": numsOfCars,
  };

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/req_latest_nums_of_carModel");

  var json = await ServerService.postGet(body, apiUri);
  debugPrint(json.toString());

  // if (json["type"] == body["type"]) {
  List<CarModel> carLists = [];

  for (final car in json["cars"]) {
    carLists.add(CarModel.fromJson(car)..statusCheck());
  }

  return carLists;
  // } else {
  // throw Exception('server return wrong type of model.');
  // }
}

Future<CarModel> reqCarModelById(int carId) async {
  Map<String, dynamic> body = {
    "type": "req_car_by_id",
    "carId": carId,
  };

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/req_car_model_byid");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return CarModel.fromJson(json)..statusCheck();
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<PersonModel> sendPersonModel(PersonModel model) async {
  Map<String, dynamic> body = {
    "type": "send_person",
  };
  // if (model.name != null) {
  body["name"] = model.name;
  // } else if (model.phone != null) {
  body["phone"] = model.phone;
  // } else if (model.stuId != null) {
  body["stuId"] = model.stuId;
  // } else if (model.gender != null) {
  body["gender"] = model.gender;
  // } else if (model.department != null) {
  body['department'] = model.department;
  // } else if (model.grade != null) {
  body['grade'] = model.grade;
  // } else {
  //   throw Exception("null content before sending person model");
  // }

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/send_person_model");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return PersonModel.fromJSON(json);
  } else {
    throw Exception('server return wrong type of model.');
  }
}

/// server need to add carId to  launchPerson.nowCarId
Future<CarModel> sendCarModel(CarModel model) async {
  Map<String, dynamic> body = {
    "type": "send_car",
  };
  // if (model.roomTitle != null) {
  body["roomTitle"] = model.roomTitle;
  // } else if (model.launchStuId != null) {
  body['launchStuId'] = model.launchStuId;
  // } else if (model.remark != null) {
  body['remark'] = model.remark;
  // } else if (model.startTime != null) {
  body['startTime'] = model.startTime?.toUtc().toString();
  // } else if (model.startLoc != null) {
  body['startLoc'] = model.startLoc;
  // } else if (model.endTime != null) {
  body['endTime'] = model.endTime?.toUtc().toString();
  // } else if (model.endLoc != null) {
  body['endLoc'] = model.endLoc;
  // } else if (model.personNumLimit != null) {
  body['personNumLimit'] = model.personNumLimit;
  // } else if (model.genderLimit != null) {
  body['genderLimit'] = model.genderLimit;
  // } else {
  //   throw Exception("null content before sending car model");
  // }

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/send_car_model");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return CarModel.fromJson(json)..statusCheck();
  } else {
    throw Exception('server return wrong type of model.');
  }
}

/// status: success/carFull/otherFail: 1/2/3
Future<int> addPersonToCar(String stuId, int carId) async {
  Map<String, dynamic> body = {
    "type": "add_person_to_car",
    "stuId": stuId,
    "carId": carId,
  };

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/addPersonToCar");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return json['status'] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

/// status: success/fail: 1/2
Future<int> rmPersonFromCar(String stuId, int carId) async {
  Map<String, dynamic> body = {
    "type": "rm_person_from_car",
    "stuId": stuId,
    "carId": carId,
  };

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/rmPersonFromCar");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return json['status'] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<PersonModel> reqPersonModelByStuIdAndName(String stuId, String name) async {
  Map<String, dynamic> body = {
    "type": "req_person_by_stuId_name",
    "stuId": stuId,
    "name": name,
  };

  Uri apiUri = Uri.parse("${ServerService.serverBaseUrl}/reqPersonModelByStuIdName");

  var json = await ServerService.postGet(body, apiUri);

  if (json["type"] == body["type"]) {
    return PersonModel.fromJSON(json);
  } else {
    throw Exception('server return wrong type of model.');
  }
}

// Future loginInOrSignUp(String stuId, String name) {
//   Uri apiUri = Uri
// }
