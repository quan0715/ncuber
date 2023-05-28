import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/model/car_model.dart';

class CarpoolCardViewModel extends ChangeNotifier {
  CarpoolCardViewModel({required this.carModel});
  CarModel carModel = CarModel();

  String getTimeString(DateTime time) {
    final checkFormatter = DateFormat('yyyy-MM-dd');
    final formatter = DateFormat('MM-dd HH:mm');
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? "Today ${DateFormat("HH:mm").format(time)}" : formatter.format(time);
  }

  String get getTitleString => "${carModel.roomTitle} (${carModel.personStuIds.length} / ${carModel.personNumLimit})";
  String get startTimeString => getTimeString(carModel.startTime ?? DateTime.now());
  String get endTimeString => getTimeString(carModel.endTime ?? DateTime.now());

  CarStatus get carStatus => carModel.status!;

  void joinCarPool() {
    // for user join carpool
    // TODO: implement join carpool api method
  }
}
