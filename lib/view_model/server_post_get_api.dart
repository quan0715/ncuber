import 'package:ncuber/constants/constants.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/msg_model.dart';
import 'package:ncuber/model/person_model.dart';
import 'package:ncuber/view_model/ngrok_server_connector.dart';

Future<List<CarModel>> reqLastNumsOfCarModel(int numsOfCar,
    {int numsOfMsg = MSG_SHOWING_NUMBERS}) async {
  Map<String, dynamic> body = {
    "type": "req_nums_of_carpool",
    "return_numbers_of_carpools": numsOfCar,
    "return_numbers_of_msgs": numsOfMsg,
  };

  var json = await ngrokServerConnector(body);

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

Future<int> sendCarModel(CarModel model) async {
  Map<String, dynamic> body = {
    "type": "send_car",
  };
  if (model.roomTitle != null) {
    body["roomTitle"] = model.roomTitle;
  } else if (model.status != null) {
    body['status'] = model.status;
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
  } else if (model.personsNumLimit != null) {
    body['personsNumLimit'] = model.personsNumLimit;
  } else if (model.totalExpectCost != null) {
    body['totalExpectCost'] = model.totalExpectCost;
  } else if (model.genderLimit != null) {
    body['genderLimit'] = model.genderLimit;
  } else if (model.ratingStandard != null) {
    body['ratingStandard'] = model.genderLimit;
  } else {
    throw Exception("null content before sending car model");
  }

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return json["carpoolSsn"] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

void sendMsgModel(MsgModel model) async {
  Map<String, dynamic> body = {
    "type": "send_msg",
  };
  if (model.releaseTime != null) {
    body['releaseTime'] = model.releaseTime?.toUtc().toString();
  } else if (model.text != null) {
    body['text'] = model.text;
  } else if (model.personUid != null) {
    body['personUid'] = model.personUid;
  } else if (model.carpoolSsn != null) {
    body['carpoolSsn'] = model.carpoolSsn;
  } else {
    throw Exception("null content before sending msg model");
  }

  var json = await ngrokServerConnector(body);

  if (json["type"] != body["type"]) {
    throw Exception('server return wrong type of model.');
  }
}

Future<PersonModel> reqPersonModelByUid(int uid) async {
  Map<String, dynamic> body = {
    "type": "req_person_by_uid",
    "uid": uid,
  };

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return PersonModel.fromJSON(json);
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<CarModel> reqCarModelBySsn(int carpoolSsn,
    {int numOfMsg = MSG_SHOWING_NUMBERS}) async {
  Map<String, dynamic> body = {
    "type": "req_carpool_by_ssn",
    "carpoolSsn": carpoolSsn,
    "return_numbers_of_msgs": numOfMsg,
  };

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return CarModel.fromJson(json);
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<int> sendPersonModel(PersonModel model) async {
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

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return json["personUid"] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<int> addPersonToCarpool(int personUid, int carSsn) async {
  Map<String, dynamic> body = {
    "type": "add_person_to_carpool",
    "uid": personUid,
    "carpoolSsn": carSsn,
  };

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return json["status"] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<int> rmPersonFromCarpool(int personUid, int carSsn) async {
  Map<String, dynamic> body = {
    "type": "rm_person_from_carpool",
    "uid": personUid,
    "carpoolSsn": carSsn,
  };

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return json["status"] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}

Future<int> sendCarRating(int personUid, int carSsn, double rating) async {
  Map<String, dynamic> body = {
    "type": "send_carpool_rating",
    "uid": personUid,
    "rating": rating,
    "carpoolSsn": carSsn,
  };

  var json = await ngrokServerConnector(body);

  if (json["type"] == body["type"]) {
    return json["status"] as int;
  } else {
    throw Exception('server return wrong type of model.');
  }
}
