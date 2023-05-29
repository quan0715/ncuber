import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/google_map.dart';
import 'package:ncuber/model/route.dart';

class CarpoolCardViewModel extends ChangeNotifier {
  CarpoolCardViewModel({required this.carModel});
  final checkFormatter = DateFormat('yyyy-MM-dd');
  final formatter = DateFormat('MM-dd HH:mm');
  MapAPIModel mapApi = MapAPIModel();
  bool isLoading = false;
  CarModel carModel = CarModel();
  LatLng get startPointLatLng => mapApi.startPointLatLng!;
  LatLng get destinationLatLng => mapApi.destinationLatLng!;
  String get startPointAddress => mapApi.startPointAddress!;
  String get destinatioAddress => mapApi.destinationAddress!;
  CarStatus get catStatus => carModel.status!;
  List<String> get personStuIds => carModel.personStuIds;

  MapRoute? mapRoute = MapRoute(duration: const Duration(seconds: 0), distance: 0, points: []);

  String getTimeString(DateTime time) {
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? "Today ${DateFormat("HH:mm").format(time)}" : formatter.format(time);
  }

  String get getTitleString => "${carModel.roomTitle} (${carModel.personStuIds.length} / ${carModel.personNumLimit})";
  String get startTimeString => getTimeString(carModel.startTime ?? DateTime.now());
  String get endTimeString => getTimeString(carModel.endTime ?? DateTime.now());

  Future loadDate() async {
    isLoading = true;
    notifyListeners();
    mapApi.updateStartPoint(carModel.startLoc!);
    await mapApi.updateStartPointLatLng();
    mapApi.updateDestination(carModel.endLoc!);
    await mapApi.updateDestinationPointLatLng();
    mapRoute = await mapApi.fetchRouts();
    isLoading = false;
    notifyListeners();
  }
}
