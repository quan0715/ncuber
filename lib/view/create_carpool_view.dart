import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ncuber/components/create_carpool_bottom_sheet.dart';
import 'package:ncuber/view_model/create_carpool_view_model.dart';
import 'package:provider/provider.dart';

class CreateCarPoolView extends StatefulWidget {
  const CreateCarPoolView({super.key});

  @override
  State<CreateCarPoolView> createState() => CreateCarPoolViewState();
}

class CreateCarPoolViewState extends State<CreateCarPoolView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  // Future moveCamera(LatLng target, CreateCarPoolViewModel model) async {
  //   // final point = CameraPosition(target: target, tilt: 0, zoom: 18);
  //   final GoogleMapController controller = await _controller.future;
  //   // await controller.animateCamera(CameraUpdate.newCameraPosition(point));
  //   await controller.animateCamera(CameraUpdate.newLatLng(target));
  //   await Future.delayed(const Duration(seconds: 1));
  //   if (model.canDrawRoute) {
  //     await moveBoundBox(model);
  //   }
  //   // controller.
  // }

  // Future moveBoundBox(CreateCarPoolViewModel model) async {
  //   LatLng point1 = model.startPoint;
  //   LatLng point2 = model.destination;
  //   LatLngBounds? bounds;
  //   if (point1.latitude <= point2.latitude) {
  //     bounds = LatLngBounds(southwest: point1, northeast: point2);
  //   } else {
  //     if (point1.longitude <= point2.longitude) {
  //       bounds = LatLngBounds(southwest: point1, northeast: point2);
  //     } else {
  //       bounds = LatLngBounds(southwest: point2, northeast: point1);
  //     }
  //   }

  //   final GoogleMapController controller = await _controller.future;
  //   await controller.moveCamera(CameraUpdate.newLatLngBounds(bounds, 30.0));
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateCarPoolViewModel>(
      create: (context) => CreateCarPoolViewModel(),
      child: Consumer<CreateCarPoolViewModel>(
        builder: (context, model, child) => model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              GoogleMap(
                                // padding: const EdgeInsets.only(bottom: 100),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                trafficEnabled: true,
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(target: model.startPoint),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                markers: {
                                  Marker(
                                      markerId: const MarkerId("current"),
                                      position: model.currentLocation,
                                      infoWindow: const InfoWindow(title: "目前位置"),
                                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
                                  Marker(
                                      markerId: const MarkerId("start"),
                                      position: model.startPoint,
                                      infoWindow: const InfoWindow(title: "起點站"),
                                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
                                  Marker(
                                      markerId: const MarkerId("end"),
                                      position: model.destination,
                                      infoWindow: const InfoWindow(title: "終點"),
                                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange))
                                },
                                polylines: {
                                  Polyline(
                                      startCap: Cap.roundCap,
                                      endCap: Cap.squareCap,
                                      polylineId: const PolylineId("route"),
                                      points: model.mapRoute!.points,
                                      color: Colors.blue,
                                      width: 5)
                                },
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: CircleAvatar(
                                  radius: 25,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CreateCarpoolBottomSheet(mapController: _controller)
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
