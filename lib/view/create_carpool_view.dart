import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/components/carpool_button_sheet.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view_model/creat_carpool_view_model.dart';
import 'package:provider/provider.dart';

class CreateCarPoolView extends StatefulWidget {
  const CreateCarPoolView({super.key});

  @override
  State<CreateCarPoolView> createState() => CreateCarPoolViewState();
}

class CreateCarPoolViewState extends State<CreateCarPoolView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Future moveCamera(LatLng target) async {
    final point = CameraPosition(target: target, tilt: 0, zoom: 18);
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(point));
  }

  Widget statusProvider(bool focus) {
    Color iconColor = focus ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary;
    return Icon(Icons.location_pin, color: iconColor);
  }

  Future _showCheckSheet(CarModel model) async {
    final result = await showModalBottomSheet(
        context: context,
        isDismissible: false,
        // useRootNavigator: true,
        builder: (context) => CarPoolButtonSheetView(
              carPoolData: model,
              buttomBar: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3.0,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text("修改資訊"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO : create new car pool
                      debugPrint("create new car pool");
                      // add user to the car pool
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3.0,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("建立共乘"),
                  )
                ],
              ),
            ));
    if (result) {
      // TODO : create new car pool
      debugPrint("create new car pool");
      // add user to the car pool
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  String getTimeString(DateTime time) {
    final checkFormatter = DateFormat('yyyy-MM-dd');
    final formatter = DateFormat('MM-dd HH:mm');
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? DateFormat("HH:mm").format(time) : formatter.format(time);
  }

  Widget toolBox(CreateCarPoolViewModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                  context: context, initialDate: model.startTime, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)));
              if (mounted) {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(model.startTime),
                );
                if (time != null && date != null) {
                  model.updateStartTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(Icons.timer_sharp),
            label: Text(getTimeString(model.startTime)),
          ),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              visualDensity: VisualDensity.compact,
            ),
            child: DropdownButton(
              isDense: true,
              elevation: 10,
              icon: const Icon(Icons.people),
              value: model.numberOfPeopleDropdownMenuIndex,
              underline: Container(
                height: 0,
              ),
              items: model.numberOfPeopleLabel
                  .map((label) => DropdownMenuItem(value: model.numberOfPeopleLabel.indexOf(label), child: Text(label)))
                  .toList(),
              onChanged: (value) {
                model.updateNumberOfPeople(value!);
              },
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 5),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: DropdownButton(
              elevation: 10,
              icon: const Icon(Icons.people),
              isDense: true,
              value: model.genderConstrainDropdownMenuIndex,
              underline: Container(
                height: 0,
              ),
              items: model.genderConstrainLabel
                  .map((label) => DropdownMenuItem(value: model.genderConstrainLabel.indexOf(label), child: Text(label)))
                  .toList(),
              onChanged: (value) {
                model.updateGenderConstrainLabel(value!);
              },
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateCarPoolViewModel>(
      create: (context) => CreateCarPoolViewModel()..getUserLocation(),
      child: Consumer<CreateCarPoolViewModel>(
        builder: (context, model, child) => model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(model.roomTitle),
                  actions: [
                    MaterialButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: const Text('輸入房間名稱與備註'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                            child: TextFormField(
                                              initialValue: model.roomTitle,
                                              onChanged: model.updateRoomTitle,
                                              decoration: const InputDecoration(
                                                // icon: Icon(Icons.home),
                                                labelText: '共乘房間名稱',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                                            child: TextFormField(
                                              initialValue: model.roomRemark,
                                              maxLines: null,
                                              onChanged: model.updateRemark,
                                              // expands: true,
                                              decoration: const InputDecoration(
                                                labelText: '備註',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.check),
                                          label: const Text('輸入完成'),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Close the dialog
                                            // Process the input values
                                          },
                                        ),
                                      ]));
                        },
                        child: const Icon(Icons.edit, size: 20)),
                  ],
                ),
                body: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(target: model.startPoint, zoom: 19.151926040649414),
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
                        polylines: {Polyline(polylineId: const PolylineId("route"), points: model.mapRoute!.points, color: Colors.blue, width: 5)},
                      ),
                      Positioned(
                          top: 10,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Card(
                              elevation: 3.5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            toolBox(model),
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
                                                textAlignVertical: TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    isDense: true, icon: statusProvider(model.isStartPointTextFieldFocused), label: const Text('起點')),
                                                initialValue: model.startAddress,
                                              ),
                                            ),
                                            // const SizedBox(height: 10),
                                            SizedBox(
                                              height: 50,
                                              child: TextFormField(
                                                onChanged: model.onDestinationChange,
                                                onTap: model.onDestinationTextFieldFocused,
                                                validator: model.destinationPointValidator,
                                                onEditingComplete: () async {
                                                  FocusScope.of(context).unfocus();
                                                  await model.onDestinationInputComplete();
                                                  await moveCamera(model.destination);
                                                },
                                                textAlignVertical: TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    icon: statusProvider(model.isDestinationTextFieldFocused),
                                                    label: const Text('終點')),
                                                initialValue: model.destinationAddress,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        if (_formKey.currentState!.validate()) {
                                                          await _showCheckSheet(model.carModel);
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        visualDensity: VisualDensity.compact,
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                                      ),
                                                      child: Row(
                                                        children: const [
                                                          Text('拼車預覽'),
                                                          Icon(Icons.arrow_forward),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            )
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
