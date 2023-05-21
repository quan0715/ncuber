import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice_ex/places.dart' as ws;
import 'package:location/location.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:ncuber/model/route.dart';

class MapAPIModel {
  static const String apiKey = "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk";
  static const String baseURL = "https://routes.googleapis.com/directions/v2:computeRoutes";

  String? startPointAddress;
  String? destinationAddress;

  LatLng? startPointLatLng;
  LatLng? destinationLatLng;

  List<LatLng> routes = [];
  String duration = "";
  int distances = 0;

  Future startPoint(String address) async {
    startPointAddress = address;
    startPointLatLng = await getLatLngFromAddress(startPointAddress!);
  }

  Future destination(String address) async {
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

  Future<MapRoute?> fetchRouts() async {
    // get routes points, duration, distance
    debugPrint("$startPointAddress $destinationAddress");
    final headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask':
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
    };
    final body = jsonEncode({
      "origin": {
        "address": startPointAddress
      },
      "destination": {
        "address": destinationAddress
      },
      "travelMode": "DRIVE",
      "computeAlternativeRoutes": false,
    });
    try {
      final result = await http.post(
        Uri.parse(baseURL),
        body: body,
        headers: headers,
      );
      Map<String, dynamic> data = jsonDecode(result.body);
      debugPrint(data.toString());
      return MapRoute.fromJson(data);
      // debugPrint(result.toString());
      // decodePolyline(encodedPolyline);
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}


