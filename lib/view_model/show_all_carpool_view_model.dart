import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/service/server_service.dart';

class ShowAllCarPooViewModel extends ChangeNotifier {
  List<CarModel>? allCarpoolData;
  bool isLoading = false;
  get carpoolList => allCarpoolData ?? [];
  get carpoolListIsEmpty => allCarpoolData?.isEmpty ?? true;

  get emptyListImageAssetPath => 'assets/images/empty_list.png';
  Future fetchAllCarpoolDataFromRepo() async {
    // update allCarpoolData
    isLoading = true;
    notifyListeners();
    // fetch data from repo
    allCarpoolData = await reqLastNumsOfCarModel(3);
    // if no data use fake data to demo
    // if (allCarpoolData!.isEmpty) {
    //   // implement code here
    //   allCarpoolData = [
    //     CarModel(
    //       roomTitle: "阿寬的共乘",
    //       remark: "不要放屁就好",
    //       personNumLimit: 4,
    //       startTime: DateTime.now().add(const Duration(hours: 1)),
    //       endTime: DateTime.now().add(const Duration(hours: 2)),
    //       personStuIds: ["109502563", "109502564", "109502565", "109502565"],
    //       startLoc: "國立中央大學校門口",
    //       endLoc: "桃園高鐵站",
    //       genderLimit: 2,
    //     )..statusCheck(),
    //     CarModel(
    //       roomTitle: "小波的共乘",
    //       remark: "拜託各位小波自己開車，歡迎命硬的小夥伴上車！",
    //       personNumLimit: 4,
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now().add(const Duration(hours: 2)),
    //       personStuIds: ["109502563", "109502564", "109502565", "109502565"],
    //       startLoc: "國立中央大學校門口",
    //       endLoc: "東港夜市",
    //       genderLimit: 2,
    //     )..statusCheck(),
    //     CarModel(
    //       roomTitle: "給我測試用的",
    //       remark: "python 課程列車",
    //       personNumLimit: 4,
    //       startTime: DateTime.now().add(const Duration(hours: 2)),
    //       endTime: DateTime.now().add(const Duration(hours: 3)),
    //       personStuIds: ["109502563", "109502564", "109502565"],
    //       startLoc: "國立中央大學小木屋",
    //       endLoc: "桃園高鐵站",
    //       genderLimit: 2,
    //     )..statusCheck(), // fake data
    //   ];
    isLoading = false;
    notifyListeners();
  }
}
