import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';

class ShowAllCarPooViewModel extends ChangeNotifier {
  List<CarModel> allCarpoolData = [
<<<<<<< HEAD
    CarModel.create(1)
      ..roomTitle = "高鐵站缺一"
      ..remark ="拜託各位家家，我們人都很好！"
      ..status = CarStatus.notReady(),
    CarModel.create(2)
      ..roomTitle = "高鐵站缺一"
      ..remark = "拜託各位家家，我們人都很好！"
      ..status = CarStatus.inProgress(),
    CarModel.create(3)
      ..roomTitle = "高鐵站缺一"
      ..remark = "拜託各位家家，我們人都很好！"
      ..status = CarStatus.full(),
=======
    CarModel.create("1")..status = CarStatus.notReady(),
    CarModel.create("2")..status = CarStatus.inProgress(),
    CarModel.create("3")..status = CarStatus.full(),
>>>>>>> 8680f2fe50b9ce6c31dbb2780e90cfd9bf51e571
  ];

  get carpoolList => allCarpoolData;
  get carpoolListIsEmpty => allCarpoolData.isEmpty;

  get emptyListImageAssetPath => 'assets/images/empty_list.png';
  void fetchFromRepo() {
    // TODO: fetch data from repo
    // update allCarpoolData
  }
}
