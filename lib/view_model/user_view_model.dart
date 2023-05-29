import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';

class UserViewModel extends ChangeNotifier {
  String? name = "";
  String? studentId = "";
  bool get isJoinCarpoolRoom => currentCarModel != null;
  CarModel? currentCarModel;

  void onNameChange(String value) {
    name = value;
    notifyListeners();
  }

  void onStudentIdChange(String value) {
    studentId = value;
    notifyListeners();
  }

  String? nameValidator(String? value) {
    return name!.isEmpty ? "請輸入姓名" : null;
  }

  String? studentIdValidator(String? value) {
    return studentId!.length != 9 ? "請輸入正確學號" : null;
  }

  void login() {
    getCurrentCarModel();
    // TODO: implement login api
  }

  void getCurrentCarModel() {
    // TODO: implement getCurrentCarModel
    // check whether user have join carpool
    // if true then get carpool data
    // else set carpool data to null and
    currentCarModel = CarModel(
      roomTitle: "阿寬的共乘",
      remark: "不要放屁就好",
      personNumLimit: 4,
      startTime: DateTime.now().add(const Duration(hours: 1)),
      endTime: DateTime.now().add(const Duration(hours: 2)),
      personStuIds: ["109502563", "109502564", "109502565","109502565"],
      startLoc: "國立中央大學校門口",
      endLoc: "桃園高鐵站",
    );
    currentCarModel!.statusCheck();
    // notifyListeners();
  }
}
