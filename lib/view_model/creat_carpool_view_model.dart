// TODO. multiple car actions
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/google_map.dart';
import 'package:ncuber/model/route.dart';

class CreateCarPoolViewModel extends ChangeNotifier {
  MapAPIModel mapApi = MapAPIModel();
  CarModel carModel =
      CarModel(roomTitle: "你的房間", remark: "", startLoc: "", endLoc: "", startTime: DateTime.now(), endTime: DateTime.now(), status: CarStatus.notReady());
  bool isLoading = false;
  bool isStartPointTextFieldFocused = false;
  bool isDestinationTextFieldFocused = false;
  LatLng get startPoint => mapApi.startPointLatLng ?? currentLocation;
  LatLng get destination => mapApi.destinationLatLng ?? currentLocation;
  String get startAddress => mapApi.startPointAddress ?? "";
  String get destinationAddress => mapApi.destinationAddress ?? "";
  LatLng currentLocation = const LatLng(24.96720974492558, 121.18772026151419);
  MapRoute? mapRoute = MapRoute(duration: const Duration(seconds: 0), distance: 0, points: []);
  // DateTime expectedEndTime = DateTime.now();
  DateTime get startTime => carModel.startTime!;
  DateTime get endTime => startTime.add(mapRoute!.duration);

  String get roomTitle => carModel.roomTitle ?? "";
  String get roomRemark => carModel.remark ?? "";

  void updateRoomTitle(String title) {
    carModel.roomTitle = title;
    notifyListeners();
  }

  void updateRemark(String remark) {
    carModel.remark = remark;
    notifyListeners();
  }

  Future<void> onStartPointInputComplete() async {
    await mapApi.updateStartPointLatLng();
    if (mapApi.startPointLatLng != null && mapApi.destinationLatLng != null) {
      mapRoute = await mapApi.fetchRouts();
      carModel.endTime = carModel.startTime!.add(mapRoute!.duration);
    }
    notifyListeners();
  }

  Future<void> onDestinationInputComplete() async {
    await mapApi.updateDestinationPointLatLng();
    if (mapApi.startPointLatLng != null && mapApi.destinationLatLng != null) {
     mapRoute = await mapApi.fetchRouts();
      carModel.endTime = carModel.startTime!.add(mapRoute!.duration);
    }
    notifyListeners();
  }

  void updateStartTime(DateTime newTime) {
    // model.updateStartTime(startTime);
    carModel.startTime = newTime;
    carModel.endTime = newTime.add(mapRoute!.duration);
    notifyListeners();
  }

  void onStartPointChange(String address) {
    mapApi.updateStartPoint(address);
    carModel.startLoc = address;
    notifyListeners();
  }

  // void updateGenderLimit(String ) {

  // }

  void onDestinationChange(String address) async {
    mapApi.updateDestination(address);
    carModel.endLoc = address;
    notifyListeners();
  }

  String? startPointValidator(String? value) {
    return startAddress.isEmpty ? "輸入不可為空" : null;
  }

  String? destinationPointValidator(String? value) {
    return destinationAddress.isEmpty ? "輸入不可為空" : null;
  }

  void getUserLocation() async {
    isLoading = true;
    notifyListeners();
    final currentLoc = await mapApi.getUserLocation();
    final lat = currentLoc.latitude!;
    final lng = currentLoc.longitude!;
    currentLocation = LatLng(lat, lng);
    isLoading = false;
    notifyListeners();
  }


  void onStartTextFieldFocused() {
    isStartPointTextFieldFocused = true;
    isDestinationTextFieldFocused = false;
    notifyListeners();
  }

  void onDestinationTextFieldFocused() {
    isDestinationTextFieldFocused = true;
    isStartPointTextFieldFocused = false;
    notifyListeners();
  }
}
