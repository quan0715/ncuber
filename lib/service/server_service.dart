import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:ncuber/constants/constants.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/person_model.dart';

/// Reference: https://www.liujunmin.com/flutter/provider/provider_mvvm.html
class ServerService {
  static var key = Key.fromUtf8(")J@NcRfUjXn2r5u8");
  static var encrypter = Encrypter(AES(key));

  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'clientId': SERVER_CLIENT_ID,
  };
  static String encryptedHeader = encrypt(headers);


  static Future<Map<String, dynamic>> postGet(
      Map<String, dynamic> jsonBody) async {
    final resp = await http.post(Uri.parse(SERVER_URL),
        headers: <String, String>{"Encrypted-Header": encryptedHeader},
        body: encrypt(jsonBody));

    if (resp.statusCode == 200) {
      String? unDecodedHeader = resp.headers['Encrypted-Header'];
      Map<String, dynamic> realHeader = decrypt(unDecodedHeader!);

      if (realHeader['clientId'] == SERVER_CLIENT_ID) {
        String unDecodedBody = resp.body;
        Map<String, dynamic> realBody = decrypt(unDecodedBody);
        return realBody;
      } else {
        throw Exception('Server give wrong clientId');
      }
    } else {
      throw Exception('Failed to post to server.');
    }
  }

  static String encrypt(Map<String, dynamic> json) {
    return encrypter.encrypt(jsonEncode(json)).base64;
  }

  static Map<String, dynamic> decrypt(String msg) {
    return jsonDecode(encrypter.decrypt(Encrypted.fromBase64(msg)));
  }

  /// --- server apis ---

  static Future<List<CarModel>> reqLastNumsOfCarModel(int numsOfCars) async {
    Map<String, dynamic> body = {
      "type": "req_nums_of_carpool",
      "numbers": numsOfCars,
    };

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      List<CarModel> carLists = [];

      for (final car in json["carpools"]) {
        carLists.add(CarModel.fromJson(car));
      }

      return carLists;
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  static Future<CarModel> reqCarModelById(int carpoolId) async {
    Map<String, dynamic> body = {
      "type": "req_carpool_by_id",
      "carpoolId": carpoolId,
    };

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      return CarModel.fromJson(json);
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  static Future<PersonModel> sendPersonModel(PersonModel model) async {
    Map<String, dynamic> body = {
      "type": "send_person",
    };
    if (model.name != null) {
      body["name"] = model.name;
    } else if (model.phone != null) {
      body["phone"] = model.phone;
    } else if (model.studentId != null) {
      body["studentId"] = model.studentId;
    } else if (model.gender != null) {
      body["gender"] = model.gender;
    } else if (model.department != null) {
      body['department'] = model.department;
    } else if (model.grade != null) {
      body['grade'] = model.grade;
    } else {
      throw Exception("null content before sending person model");
    }

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      model.uid = json["personUid"] as int;
      return model;
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  static Future<CarModel> sendCarModel(CarModel model) async {
    Map<String, dynamic> body = {
      "type": "send_carpool",
    };
    if (model.roomTitle != null) {
      body["roomTitle"] = model.roomTitle;
    } else if (model.launchPersonUid != null) {
      body['launchPersonUid'] = model.launchPersonUid;
    } else if (model.remark != null) {
      body['remark'] = model.remark;
    } else if (model.startTime != null) {
      body['startTime'] = model.startTime?.toUtc().toString();
    } else if (model.startLoc != null) {
      body['startLoc'] = model.startLoc;
    } else if (model.endTime != null) {
      body['endTime'] = model.endTime?.toUtc().toString();
    } else if (model.endLoc != null) {
      body['endLoc'] = model.endLoc;
    } else if (model.personNumLimit != null) {
      body['personNumLimit'] = model.personNumLimit;
    } else if (model.genderLimit != null) {
      body['genderLimit'] = model.genderLimit;
    } else {
      throw Exception("null content before sending car model");
    }

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      model.carpoolId = json["carpoolId"] as int;
      return model;
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  /// status: success/carFull/otherFail: 1/2/3
  static Future<int> addPersonToCar(
      int personUid, int carpoolId) async {
    Map<String, dynamic> body = {
      "type": "add_person_to_carpool",
      "uid": personUid,
      "carpoolId": carpoolId,
    };

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      return json['status'] as int;
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  /// status: success/fail: 1/2
  static Future<int> rmPersonFromCar(
      int personUid, int carpoolId) async {
    Map<String, dynamic> body = {
      "type": "rm_person_from_carpool",
      "uid": personUid,
      "carpoolSsn": carpoolId,
    };

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      return json['status'] as int;
    } else {
      throw Exception('server return wrong type of model.');
    }
  }

  static Future<PersonModel> reqPersonModelByUid(int uid) async {
    Map<String, dynamic> body = {
      "type": "req_person_by_uid",
      "uid": uid,
    };

    var json = await postGet(body);

    if (json["type"] == body["type"]) {
      return PersonModel.fromJSON(json);
    } else {
      throw Exception('server return wrong type of model.');
    }
  }
}
