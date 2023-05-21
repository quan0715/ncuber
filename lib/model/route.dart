import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapRoute {
  final Duration duration;
  final int distance;
  final List<LatLng> points;

  MapRoute(
      {required this.duration, required this.distance, required this.points});
  factory MapRoute.fromJson(Map<String, dynamic> data) {
    var points = PolylinePoints()
        .decodePolyline(data['routes'][0]['polyline']['encodedPolyline']);
    var pointsLatLng = points
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList(growable: false);
    // String durationText = data['routes'][0]['duration'];
    // debugPrint(durationText.replaceFirst('s', ''));
    return MapRoute(
        duration: Duration(seconds: int.parse(data['routes'][0]['duration'].replaceFirst('s', ''))),
        distance: data['routes'][0]['distanceMeters'],
        points: pointsLatLng);
  }
}
