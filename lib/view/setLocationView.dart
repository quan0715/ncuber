// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/view_model/location_picker_view_model.dart';
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

  Future moveCamera(LatLng target) async {
    final point = CameraPosition(target: target, tilt: 0, zoom: 18);
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(point));
  }

  Widget statusProvider(bool focus) {
    Color iconColor = focus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
    return Icon(Icons.location_pin, color: iconColor);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocationPickerViewModel>(
      create: (context) => LocationPickerViewModel(),
      child: Consumer<LocationPickerViewModel>(
        builder: (context, model, child) => model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: const Text("New NCUber"),
                ),
                body: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                            target: model.startPoint, zoom: 19.151926040649414),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
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
                            // height: MediaQuery.of(context).size.height * 0.15,
                            child: Card(
                              elevation: 3.5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await showDatePicker(
                                                      context: context, 
                                                      initialDate: DateTime.now(), 
                                                      firstDate: DateTime.now(), 
                                                      lastDate: DateTime.now().add(const Duration(days: 30))
                                                    );
                                                    await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay.now(),
                                                    );
                                                  }, 
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: const [
                                                      Icon(Icons.calendar_today),
                                                      SizedBox(width: 10,),
                                                      Text('Now'),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!.validate()) {
                                                        await model
                                                            .routeApiTest();
                                                      }
                                                    },
                                                    child: Row(
                                                      children: const [
                                                        // Text('路線計算'),
                                                        Icon(Icons.rocket),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: TextFormField(
                                                onTap: model.onStartTextFieldFocused,
                                                onChanged: model.onStartPointChange,
                                                validator: model.startPointValidator,
                                                onEditingComplete: () async {
                                                  FocusScope.of(context).unfocus();
                                                  await model.onStartPointInputComplete();
                                                  await moveCamera(model.startPoint);
                                                },
                                                textAlignVertical:TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                    icon: statusProvider(model
                                                        .isStartPointTextFieldFocused),
                                                    label: const Text('起點')),
                                                initialValue: model.startAddress,
                                              ),
                                            ),
                                            // const SizedBox(height: 10),
                                            SizedBox(
                                              height: 50,
                                              child: TextFormField(
                                                onChanged:
                                                    model.onDestinationChange,
                                                onTap: model
                                                    .onDestinationTextFieldFocused,
                                                validator: model
                                                    .destinationPointValidator,
                                                onEditingComplete: () async {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  await model
                                                      .onDestinationInputComplete();
                                                  await moveCamera(
                                                      model.destination);
                                                },
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    icon: statusProvider(model
                                                        .isDestinationTextFieldFocused),
                                                    label: const Text('終點')),
                                                initialValue:
                                                    model.destinationAddress,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                              
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        await model
                                                            .routeApiTest();
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      foregroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                    ),
                                                    child: Row(
                                                      children: const [
                                                        Text('下一步'),
                                                        Icon(Icons
                                                            .navigate_next),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}

// class CarPoolCardWithMap extends StatefulWidget {
//   const CarPoolCardWithMap({super.key, required this.carPoolData});
//   final CarModel carPoolData;
//   @override
//   State<CarPoolCardWithMap> createState() => _CarPoolCardWithMapState();
// }

// class _CarPoolCardWithMapState extends State<CarPoolCardWithMap> {
//   Widget getTimeLocDisplay({required DateTime time, required String loc}) {
//     final formatter = DateFormat('yyyy-MM-dd HH:mm');
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(loc,
//             style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.primary)),
//         Text(formatter.format(time),
//             style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.secondary)),
//       ],
//     );
//   }

//   Widget statusProvider(bool focus) {
//     Color iconColor = focus
//         ? Theme.of(context).colorScheme.primary
//         : Theme.of(context).colorScheme.secondary;
//     return Icon(Icons.location_pin, color: iconColor);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LocationPickerViewModel>(
//       builder: (context, model, child) => 
//     );
//   }
// }
