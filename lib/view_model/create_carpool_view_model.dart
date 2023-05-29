import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:map_location_picker/map_location_picker.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/google_map.dart';
import 'package:ncuber/model/route.dart';

class CreateCarPoolViewModel extends ChangeNotifier {
  // google api model
  MapAPIModel mapApi = MapAPIModel();
  bool isLoading = false;
  bool isStartPointTextFieldFocused = false;
  bool isDestinationTextFieldFocused = false;
  final checkFormatter = DateFormat('yyyy-MM-dd');
  final formatter = DateFormat('MM-dd HH:mm');
  LatLng get startPoint => mapApi.startPointLatLng ?? currentLocation;
  LatLng get destination => mapApi.destinationLatLng ?? currentLocation;
  bool get canDrawRoute => mapApi.startPointLatLng != null && mapApi.destinationLatLng!=null;
  String get startAddress => mapApi.startPointAddress ?? "";
  String get destinationAddress => mapApi.destinationAddress ?? "";
  LatLng currentLocation = const LatLng(24.96720974492558, 121.18772026151419);
  MapRoute? mapRoute = MapRoute(duration: const Duration(seconds: 0), distance: 0, points: []);
  bool showButtomSheet = false;

  // car model
  DateTime get startTime => carModel.startTime ?? DateTime.now();
  DateTime get endTime => startTime.add(mapRoute?.duration ?? const Duration(seconds: 0));

  String? get roomTitle => carModel.roomTitle;
  String? get roomRemark => carModel.remark;
  List<String> numberOfPeopleLabel = const ["2", "3", "4", "5", "6", "7", "8"];
  List<String> genderConstrainLabel = const ["限男性", "限女性", "性別不拘"];
  CarModel carModel = CarModel(
    startTime: DateTime.now(),
    endTime: DateTime.now(),
    startLoc: "",
    endLoc: "",
    personNumLimit: 4,
    genderLimit: 1,
    status: CarStatus.notReady(),
  );
  // for view magic number
  int numberOfPeopleDropdownMenuIndex = 2;
  int genderConstrainDropdownMenuIndex = 2;
  String getTimeString(DateTime time) {
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? "Today ${DateFormat("HH:mm").format(time)}" : formatter.format(time);
  }

  String get startTimeString => getTimeString(startTime);
  String get endTimeString => getTimeString(endTime);

  void updateRoomTitle(String title) {
    carModel.roomTitle = title;
    notifyListeners();
  }

  void updateRemark(String remark) {
    carModel.remark = remark;
    notifyListeners();
  }

  String? roomTitleValidator(String? value) => (roomTitle!.isEmpty || roomTitle!.length > 10) ? "名稱不得為空或超過10個字元" : null;
  String? remarkValidator(String? value) => null;

  void updateNumberOfPeople(int index) {
    numberOfPeopleDropdownMenuIndex = index;
    carModel.personNumLimit = int.parse(numberOfPeopleLabel[index]);
    notifyListeners();
  }

  void updateGenderConstrainLabel(int index) {
    genderConstrainDropdownMenuIndex = index;
    carModel.genderLimit = genderConstrainDropdownMenuIndex;
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

  void onDestinationChange(String address) async {
    mapApi.updateDestination(address);
    carModel.endLoc = address;
    notifyListeners();
  }

  String? startPointValidator(String? value) => startAddress.isEmpty ? "輸入不可為空" : null;
  String? destinationPointValidator(String? value) => destinationAddress.isEmpty ? "輸入不可為空" : null;

  Future getUserLocation() async {
    isLoading = true;
    notifyListeners();
    loc.Location location = loc.Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        isLoading = false;
        notifyListeners();
        return;
      }
    }
    // Check if permission is granted
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        isLoading = false;
        notifyListeners();
        return;
      }
    }
    final currentLoc = await location.getLocation();
    final lat = currentLoc.latitude!;
    final lng = currentLoc.longitude!;
    currentLocation = LatLng(lat, lng);
    isLoading = false;
    notifyListeners();
  }

  // void onStartTextFieldFocused() {
  //   isStartPointTextFieldFocused = true;
  //   isDestinationTextFieldFocused = false;
  //   notifyListeners();
  // }

  // void onDestinationTextFieldFocused() {
  //   isDestinationTextFieldFocused = true;
  //   isStartPointTextFieldFocused = false;
  //   notifyListeners();
  // }

  // void checkSchdule() {
  //   showButtomSheet = true;
  //   notifyListeners();
  // }

  // void closeButtomSheet() {
  //   showButtomSheet = false;
  //   notifyListeners();
  // }
}
