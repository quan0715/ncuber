import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice_ex/places.dart' as ws;

import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:ncuber/model/route.dart';

class MapAPIModel {
  static const String apiKey = "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk";
  static const String baseURL ="https://routes.googleapis.com/directions/v2:computeRoutes";

  String? startPointAddress;
  String? destinationAddress;

  LatLng? startPointLatLng;
  LatLng? destinationLatLng;

  List<LatLng> routes = [];
  String duration = "";
  int distances = 0;

  void updateStartPoint(String address) async {
    startPointAddress = address;
  }

  void updateDestination(String address) async {
    destinationAddress = address;
  }

  Future updateStartPointLatLng() async {
    try {
      startPointLatLng = await getLatLngFromAddress(startPointAddress!);
    } catch (e) {
      debugPrint(e.toString());
      startPointLatLng = null;
    }
  }

  Future updateDestinationPointLatLng() async {
    try {
      destinationLatLng = await getLatLngFromAddress(destinationAddress!);
    } catch (e) {
      debugPrint(e.toString());
      destinationLatLng = null;
    }
  }

  Future<LatLng> getLatLngFromAddress(String searchText) async {
    final places = ws.GoogleMapsPlaces(apiKey: apiKey);
    ws.PlacesSearchResponse response = await places.searchByText(searchText);
    return LatLng(response.results.first.geometry!.location.lat,
        response.results.first.geometry!.location.lng);
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
        "location": {
          "latLng": {
            "latitude": startPointLatLng!.latitude,
            "longitude": startPointLatLng!.longitude
          }
        }
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destinationLatLng!.latitude,
            "longitude": destinationLatLng!.longitude
          }
        }
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
    } on SocketException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
