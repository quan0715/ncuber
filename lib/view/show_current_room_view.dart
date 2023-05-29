import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ncuber/components/carpool_buttom_sheet.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:ncuber/view_model/create_carpool_view_model.dart';
import 'package:provider/provider.dart';

class ShowCurrentCarpoolView extends StatefulWidget {
  const ShowCurrentCarpoolView({super.key});

  @override
  State<ShowCurrentCarpoolView> createState() => ShowCurrentCarpoolViewState();
}

class ShowCurrentCarpoolViewState extends State<ShowCurrentCarpoolView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future moveCamera(LatLng target, CreateCarPoolViewModel model) async {
    // final point = CameraPosition(target: target, tilt: 0, zoom: 18);
    final GoogleMapController controller = await _controller.future;
    // await controller.animateCamera(CameraUpdate.newCameraPosition(point));
    await controller.animateCamera(CameraUpdate.newLatLng(target));
    await Future.delayed(const Duration(seconds: 1));
    if (model.canDrawRoute) {
      await moveBoundBox(model);
    }
    // controller.
  }

  Future moveBoundBox(CreateCarPoolViewModel model) async {
    LatLng point1 = model.startPoint;
    LatLng point2 = model.destination;
    LatLngBounds? bounds;
    if (point1.latitude <= point2.latitude) {
      bounds = LatLngBounds(southwest: point1, northeast: point2);
    } else {
      if (point1.longitude <= point2.longitude) {
        bounds = LatLngBounds(southwest: point1, northeast: point2);
      } else {
        bounds = LatLngBounds(southwest: point2, northeast: point1);
      }
    }
    final GoogleMapController controller = await _controller.future;
    await controller.moveCamera(CameraUpdate.newLatLngBounds(bounds, 30.0));
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<CarpoolCardViewModel>(
      builder: (context, model, child) => 
          model.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
            floatingActionButton: null,
              body: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: model.startPointLatLng, zoom: 19.151926040649414),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: {
                        Marker(
                            markerId: const MarkerId("start"),
                            position: model.startPointLatLng,
                            infoWindow: const InfoWindow(title: "起點站"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
                        Marker(
                            markerId: const MarkerId("end"),
                            position: model.destinationLatLng,
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
                  ),
                  Expanded(
                    flex:1, child: ChangeNotifierProvider<CarpoolCardViewModel>.value(
                      value: model, child: BottomSheet(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        clipBehavior: Clip.hardEdge,
                        onClosing: (){},
                        builder: (context) => const CarPoolBottomSheetView()))
                  ),
                ],
              ),
            ),
    );
  }
}
