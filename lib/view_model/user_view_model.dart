import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';

class UserViewModel extends ChangeNotifier {
  String? userName = "";
  String? studentId = "";
  bool get isJoinCarpoolRoom => currentCarModel != null;
  CarModel? currentCarModel;

  void onNameChange(String value) {
    userName = value;
    notifyListeners();
  }

  void onStudentIdChange(String value) {
    studentId = value;
    notifyListeners();
  }

  String? nameValidator(String? value) {
    return userName!.isEmpty ? "請輸入姓名" : null;
  }

  String? studentIdValidator(String? value) {
    return studentId!.length != 9 ? "請輸入正確學號" : null;
  }

  Future<bool> login() async {
    try {
      await getCurrentCarModel();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    // TODO: implement login api
  }

  Future getCurrentCarModel() async {
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
      personStuIds: ["109502563", "109502564", "109502565", "109502565"],
      startLoc: "國立中央大學校門口",
      endLoc: "桃園高鐵站",
      genderLimit: 2,
    ); // fake data
    currentCarModel!.statusCheck();
    notifyListeners();
  }
  

  Future createNewCarModel(CarModel model) async {
    // user creat a new carpool
    // TODO: implement create new carpool
    currentCarModel = model;
    notifyListeners();
  }

  Future joinCarPool(CarModel model) async{
    // for user join carpool
    // TODO: implement join carpool api method
    currentCarModel = model;
    notifyListeners();
  }

  Future leaveCarPool() async {
    // for user leave current car pool
    // TODO: implement user leave carpool api method
    // set current car pool to null
    currentCarModel = null;
    notifyListeners();
  }
}
