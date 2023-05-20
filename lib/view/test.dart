import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:google_maps_webservice_ex/places.dart' as ws;
import 'package:location/location.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LocationData? _userLocation;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  CameraPosition currentLoacation = const CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void getUserLocation() async {
    Location location = Location();
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // debugPrint("${_serviceEnabled} ${_permissionGranted}");
    _userLocation = await location.getLocation();
    setState(() {
      currentLoacation = CameraPosition(
          target: LatLng(_userLocation!.latitude!, _userLocation!.longitude!),
          zoom: 14.4746);
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLoacation));
  }

  String inputText = "";
  MapsRoutes route = MapsRoutes();
  DistanceCalculator distanceCalculator = DistanceCalculator();
  String googleApiKey = 'AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk';
  String totalDistance = 'No route';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(alignment: Alignment.center, children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: currentLoacation,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  const Marker(
                    markerId: MarkerId('NCU'),
                    position: LatLng(24.968, 121.194),
                    infoWindow: InfoWindow(title: 'NCU'),
                  ),
                  Marker(
                    markerId: const MarkerId('Current'),
                    position: currentLoacation.target,
                    infoWindow: const InfoWindow(title: 'currentLoacation'),
                  ),
                },
                polylines: route.routes
            ),
            Positioned(
                top: 50,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                      // controller: textEditController,
                      onChanged: (text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                      onSubmitted: (text) {
                        _NCUPicker(inputText);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Where to go',
                        hintText: '搜尋出發地',
                        suffixIcon: Icon(Icons.search),
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                      )),
                )),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => getUserLocation(),
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _NCUPicker(String searchText) async {
    final places =
        ws.GoogleMapsPlaces(apiKey: "AIzaSyC4vGfQQlBs3BLelaaghVkaIccn6xS-GTk");
    ws.PlacesSearchResponse response = await places.searchByText(searchText);
    final lat = response.results.first.geometry!.location.lat;
    final lng = response.results.first.geometry!.location.lng;
    final GoogleMapController controller = await _controller.future;
    final point = CameraPosition(target: LatLng(lat, lng), tilt: 0, zoom: 18);
    controller.animateCamera(CameraUpdate.newCameraPosition(point));
    List<LatLng> points = [
      LatLng(lat, lng),
      currentLoacation.target,
    ];
    await route.drawRoute(
      points, 'Test routes',
      const Color.fromRGBO(130, 78, 210, 1.0), googleApiKey,
      travelMode: TravelModes.driving);
    setState(() {
    totalDistance =
        distanceCalculator.calculateRouteDistance(points, decimals: 1);
    });
  }
}
