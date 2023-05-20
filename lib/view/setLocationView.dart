import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ncuber/ViewModel/location_picker_view_model.dart';
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
                        polylines: model.route.routes,
                      ),
                      // Positioned(
                      //     top: 10,
                      //     child: SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.9,
                      //       height: MediaQuery.of(context).size.height * 0.2,
                      //       child: Column(
                      //         children: [
                      //           SizedBox(
                      //             height: MediaQuery.of(context).size.height * 0.06,
                      //             child: TextField(

                      //               onSubmitted: model.updateStartPointAddress,
                      //               decoration: const InputDecoration(
                      //                 border: OutlineInputBorder(
                      //                   borderRadius:
                      //                       BorderRadius.all(Radius.circular(10)),
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true,
                      //                 labelText: '起點站',
                      //                 hintText: '起點站',
                      //               ),
                      //               // style: const TextStyle(fontSize: 20)
                      //             ),
                      //           ),
                      //           const Divider(
                      //             height: 3,
                      //           ),
                      //           SizedBox(
                      //             height: MediaQuery.of(context).size.height * 0.06,
                      //             child: TextField(
                      //               onSubmitted: model.updateDestinationAddress,
                      //               decoration: const InputDecoration(
                      //                 border: OutlineInputBorder(
                      //                   borderRadius:
                      //                       BorderRadius.all(Radius.circular(10)),
                      //                 ),
                      //                 fillColor: Colors.white,
                      //                 filled: true,
                      //                 labelText: '終點站',
                      //                 hintText: '終點站',
                      //               ),
                      //               // style: const TextStyle(fontSize: 20)
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}
