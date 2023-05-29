import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/person_model.dart';
import 'package:ncuber/service/server_service.dart';

class UserViewModel extends ChangeNotifier {
  String? userName = "";
  String? studentId = "";
  bool get isJoinCarpoolRoom => currentCarModel != null;
  CarModel? currentCarModel;
  int? readyToGetCarId;

  void onNameChange(String value) {
    userName = value;
    notifyListeners();
  }

  void onStudentIdChange(String value) {
    studentId = value;
    notifyListeners();
  }

  String? nameValidator(String? value) => userName!.isEmpty ? "請輸入姓名" : null;
  String? studentIdValidator(String? value) => studentId!.length != 9 ? "請輸入正確學號" : null;

  Future<bool> login() async {
    PersonModel personModel =
        await sendPersonModel(PersonModel(stuId: studentId, name: userName));
    readyToGetCarId = personModel.nowCarId;

    try {
      await getCurrentCarModel();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future getCurrentCarModel() async {
    // check whether user have join carpool
    // if true then get carpool data
    // else set carpool data to null and
    if (studentId == null || userName == null) {
      throw Exception("Please input student_id & name.");
    }

    if (readyToGetCarId != null) {
      currentCarModel = await reqCarModelById(readyToGetCarId!);
      // currentCarModel = CarModel(
      //   roomTitle: "阿寬的共乘",
      //   remark: "不要放屁就好",
      //   personNumLimit: 4,
      //   startTime: DateTime.now().add(const Duration(hours: 1)),
      //   endTime: DateTime.now().add(const Duration(hours: 2)),
      //   personStuIds: ["109502563", "109502564", "109502565", "109502565"],
      //   startLoc: "國立中央大學校門口",
      //   endLoc: "桃園高鐵站",
      //   genderLimit: 2,
      // ); // fake data
      currentCarModel!.statusCheck();
    } else {
      currentCarModel = null;
    }
    notifyListeners();
  }

  Future createNewCarModel(CarModel model) async {
    // user creat a new carpool
    model.launchStuId = studentId!;
    // model.personStuIds.add(studentId!);
    model = await sendCarModel(model);
    assert(model.personStuIds.contains(studentId!) == true);

    currentCarModel = model;
    notifyListeners();
  }

  Future joinCarPool(CarModel model) async {
    // for user join carpool
    // int status = await addPersonToCar(studentId!, model.carId!);
    // switch (status) {
    //   case 1:
    //     {
    //       debugPrint("join car successfully.");
          model.personStuIds.add(studentId!);
          currentCarModel = model;
          notifyListeners();
    //       break;
    //     }
    //   case 2:
    //     {
    //       debugPrint("the car fulled.");
    //       break;
    //     }
    //   case 3:
    //     {
    //       debugPrint("the car has been destroyed.");
    //       break;
    //     }
    //   default:
    //     {
    //       throw Exception("Server join car other error.");
    //     }
    // }
  }

  Future leaveCarPool() async {
    // for user leave current car pool
    int status = await rmPersonFromCar(studentId!, currentCarModel!.carId!);
    switch (status) {
      case 1:
        {
          debugPrint("remove person from car success.");
          break;
        }
      case 2:
        {
          debugPrint("remove person from car fail.");
          break;
        }
      default:
        {
          throw Exception("Server disjoin car other error.");
        }
    }

    // set current car pool to null
    currentCarModel!.personStuIds.remove(studentId!);
    currentCarModel = null;
    notifyListeners();
  }
}
