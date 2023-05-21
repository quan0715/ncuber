import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/ViewModel/location_picker_view_model.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view/dashboard_ncuber.dart';
import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  void getToCurrentPosition(LocationPickerViewModel model) async {
    model.getUserLocation();
    final point =
        CameraPosition(target: model.currentLocation, tilt: 0, zoom: 18);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(point));
  }

  // LocationPickerViewModel model = LocationPickerViewModel();
  @override
  Widget build(BuildContext context) {
    String startLoc =
        (ModalRoute.of(context)!.settings.arguments as List).first;
    String endLoc = (ModalRoute.of(context)!.settings.arguments as List).last;
    debugPrint("$startLoc $endLoc");
    return ChangeNotifierProvider<LocationPickerViewModel>(
      create: ((context) =>
          LocationPickerViewModel()..updateMap(startLoc, endLoc)),
      child: Consumer<LocationPickerViewModel>(
        builder: (context, model, child) => model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text('地圖'),
                  actions: [
                    IconButton(
                        onPressed: () => getToCurrentPosition(model),
                        icon: const Icon(Icons.location_on))
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    await model.routeApiTest();
                  },
                  child: const Icon(Icons.check),
                ),
                body: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: model.startPoint, zoom: 19.151926040649414),
                        onMapCreated: (GoogleMapController controller) async {
                          _controller.complete(controller);
                        },
                        onTap: (LatLng latLng) {
                          debugPrint(latLng.toString());
                        },
                        markers: {
                          Marker(
                              markerId: const MarkerId("start"),
                              position: model.startPoint,
                              infoWindow: const InfoWindow(title: "起點")),
                          Marker(
                              markerId: const MarkerId("end"),
                              position: model.destination,
                              infoWindow: const InfoWindow(title: "終點"))
                        },
                        polylines: {
                          Polyline(
                              polylineId: const PolylineId("route"),
                              points: model.mapRoute!.points,
                              color: Colors.blue,
                              width: 5)
                        },
                        // polylines: model.route.routes,
                      ),
                      Positioned(
                        top: 10,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.15,
                          child: CarPoolCardWithMap(
                              carPoolData: CarModel.create(1)
                                ..roomTitle = "測試"
                                ..startLoc = startLoc
                                ..endLoc = endLoc
                                ..startTime = DateTime.now()
                                ..endTime = DateTime.now().add(model.mapRoute!.duration)
                                ..status = CarStatus.notReady()
                          ),
                        )
                      )
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}

class CarPoolCardWithMap extends StatefulWidget {
  const CarPoolCardWithMap({super.key, required this.carPoolData});
  final CarModel carPoolData;
  @override
  State<CarPoolCardWithMap> createState() => _CarPoolCardWithMapState();
}

class _CarPoolCardWithMapState extends State<CarPoolCardWithMap> {
  Widget getTimeLocDisplay({required DateTime time, required String loc}) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(formatter.format(time),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // car pool title display
                Text(widget.carPoolData.roomTitle ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            // Time display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // car pool start time display
                getTimeLocDisplay(
                    time: widget.carPoolData.startTime!,
                    loc: widget.carPoolData.startLoc!),
                const Icon(Icons.arrow_forward),
                // car pool end time display
                getTimeLocDisplay(
                    time: widget.carPoolData.endTime!,
                    loc: widget.carPoolData.endLoc!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
