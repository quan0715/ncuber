import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice_ex/places.dart' as ws;
import 'package:location/location.dart';

class MapAPIModel {
  static const String apiKey = "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk";

  String? startPointAddress;
  String? destinationAddress;

  LatLng? startPointLatLng;
  LatLng? destinationLatLng;
  
  Future startPoint(String address) async {
    startPointAddress = address;
    startPointLatLng = await getLatLngFromAddress(startPointAddress!);
  }

  Future destination(String address) async{
    destinationAddress = address;
    destinationLatLng = await getLatLngFromAddress(destinationAddress!);
  }

  Future<LatLng> getLatLngFromAddress(String searchText) async {
    final places = ws.GoogleMapsPlaces(apiKey: apiKey);
    ws.PlacesSearchResponse response = await places.searchByText(searchText);
    return LatLng(response.results.first.geometry!.location.lat,
        response.results.first.geometry!.location.lng);
  }

  Future getUserLocation() async {
    Location location = Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check if permission is granted
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // debugPrint("${_serviceEnabled} ${_permissionGranted}");
    return await location.getLocation();
  }
}
