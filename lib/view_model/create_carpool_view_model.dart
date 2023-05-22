import 'package:flutter/material.dart';
import 'package:ncuber/model/car_model.dart';

class CreateCarPoolViewModel extends ChangeNotifier {
  CarModel model = CarModel();

  get roomTitle => model.roomTitle;
  get startTime => model.startTime ?? DateTime.now();
  get startLoc => model.startLoc;
  get endLoc => model.endLoc;
  get endTime => model.endTime ?? DateTime.now();

  void updateRoomTitle(String title) {
    model.roomTitle = title;
    notifyListeners();
  }

  void updateStartLoc(String address) {
    model.startLoc = address;
    notifyListeners();
  }
  void updateEndLoc(String address) {
    model.endLoc = address;
    notifyListeners();
  }

  // void update
}
