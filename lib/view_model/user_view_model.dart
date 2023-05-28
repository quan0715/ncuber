import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  String? name = "";
  String? studentId = "";
  bool get isJoinCarpoolRoom => false;
  
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
    // TODO: implement login api
  }
}
