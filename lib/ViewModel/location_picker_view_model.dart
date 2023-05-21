import 'package:flutter/material.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:location/location.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:ncuber/model/location.dart';
import 'package:ncuber/model/route.dart';

class LocationPickerViewModel extends ChangeNotifier {
  MapAPIModel model = MapAPIModel();
  bool isLoading = false;
  get startPoint => model.startPointLatLng ?? currentLocation;
  get destination => model.destinationLatLng ?? currentLocation;
  LatLng currentLocation = const LatLng(24.96720974492558, 121.18772026151419);
  MapRoute? mapRoute = MapRoute(
      duration: const Duration(seconds: 0),
      distance: 0,
      points: [const LatLng(24.96720974492558, 121.18772026151419)]);
  // DistanceCalculator distanceCalculator = DistanceCalculator();

  void updateMap(String startAddress, String destinationAddress) async {
    isLoading = true;
    notifyListeners();
    await model.startPoint(startAddress);
    await model.destination(destinationAddress);
    // route.routes.clear();
    // await route.drawRoute(
    //     [startPoint, destination], "路徑圖", Colors.blue, MapAPIModel.apiKey);
    // debugPrint("${model.startPointAddress} ${model.destinationAddress}");
    isLoading = false;
    notifyListeners();
  }

  void updateStartPointAddress(String address) async {
    isLoading = true;
    notifyListeners();
    await model.startPoint(address);

    // await route.drawRoute(
    //     [startPoint, destination], "路徑圖", Colors.blue, MapAPIModel.apiKey);
    // debugPrint("${model.startPointAddress} ${model.destinationAddress}");
    isLoading = false;
    notifyListeners();
    // getRoute();
  }

  void updateDestinationAddress(String address) async {
    isLoading = true;
    notifyListeners();
    await model.destination(address);
    // await route.drawRoute(
    //     [startPoint, destination], "路徑圖", Colors.blue, MapAPIModel.apiKey);
    isLoading = false;
    notifyListeners();
    // getRoute();
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
    isLoading = true;
    notifyListeners();
    mapRoute = await model.fetchRouts();
    debugPrint(mapRoute!.duration.toString());
    // debugPrint(mapRoute!.distance.toString());
    // debugPrint(mapRoute!.points.toString());
    isLoading = false;
    notifyListeners();
  }
}
