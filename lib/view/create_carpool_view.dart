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
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(target: model.startPoint, zoom: 15),
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                markers: {
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
                                      points: model.mapRoute?.points ?? [],
                                      color: Colors.blue,
                                      width: 5)
                                },
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(elevation: 5.0),
                                  child: const Icon(Icons.arrow_back)
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
