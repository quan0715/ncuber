import 'package:flutter/material.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:ncuber/model/location.dart';
import 'package:ncuber/model/route.dart';

class LocationPickerViewModel extends ChangeNotifier {
  MapAPIModel model = MapAPIModel();
  bool isLoading = false;
  bool isStartPointTextFieldFocused = false;
  bool isDestinationTextFieldFocused = false;
  LatLng get startPoint => model.startPointLatLng ?? LatLng(24.96720974492558, 121.18772026151419);
  LatLng get destination => model.destinationLatLng ?? LatLng(24.96720974492558, 121.18772026151419);
  String get startAddress => model.startPointAddress ?? "";
  String get destinationAddress => model.destinationAddress ?? "";
  LatLng currentLocation = const LatLng(24.96720974492558, 121.18772026151419);
  MapRoute? mapRoute = MapRoute(
      duration: const Duration(seconds: 0),
      distance: 0,
      points: [const LatLng(24.96720974492558, 121.18772026151419)]);

  Future<void> onStartPointInputComplete() async {
    await model.updateStartPointLatLng();
    notifyListeners();
  }

  Future<void> onDestinationInputComplete() async {
    await model.updateDestinationPointLatLng();
    notifyListeners();
  }

  void onStartPointChange(String address) {
    model.updateStartPoint(address);
    notifyListeners();
  }

  void onDestinationChange(String address) async {
    model.updateDestination(address);
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
    final currentLoc = await model.getUserLocation();
    final lat = currentLoc.latitude!;
    final lng = currentLoc.longitude!;
    currentLocation = LatLng(lat, lng);
    isLoading = false;
    notifyListeners();
  }

  Future routeApiTest() async {
    // isLoading = true;
    // notifyListeners();
    mapRoute = await model.fetchRouts();
    // debugPrint(mapRoute!.duration.toString());
    // isLoading = false;
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
