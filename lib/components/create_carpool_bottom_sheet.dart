import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:ncuber/view_model/create_carpool_view_model.dart';
import 'package:ncuber/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class CreateCarpoolBottomSheet extends StatefulWidget {
  const CreateCarpoolBottomSheet({Key? key, required this.mapController}) : super(key: key);
  final Completer<GoogleMapController> mapController;

  @override
  State<CreateCarpoolBottomSheet> createState() => _CreateCarpoolBottomSheetState();
}

final formKey = GlobalKey<FormState>();

class _CreateCarpoolBottomSheetState extends State<CreateCarpoolBottomSheet> {
  Future moveCamera(LatLng target, CreateCarPoolViewModel model) async {
    // final point = CameraPosition(target: target, tilt: 0, zoom: 18);
    final GoogleMapController controller = await widget.mapController.future;
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
        // FIXME: Fail assert => 'southwest.latitude <= northeast.latitude' is not true
        bounds = LatLngBounds(southwest: point1, northeast: point2);
      } else {
        bounds = LatLngBounds(southwest: point2, northeast: point1);
      }
    }

    final GoogleMapController controller = await widget.mapController.future;
    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50.0));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateCarPoolViewModel>(
      builder: (context, model, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: Form(
            key: formKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                    initialValue: model.roomTitle,
                                    validator: model.roomTitleValidator,
                                    onChanged: model.updateRoomTitle,
                                    decoration: const InputDecoration(
                                      // label: Text("共乘名稱"),
                                      isDense: true,
                                      hintText: "輸入共乘名稱",
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              Consumer<UserViewModel>(
                                builder: (context, user, value) => Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          // TODO: implement create car pool
                                          if (model.canDrawRoute && model.mapRoute != null) {
                                            await user.createNewCarModel(model.carModel);
                                            if (mounted) {
                                              Navigator.pop(context);
                                            }
                                            debugPrint("create new carpool");
                                          }
                                        }
                                      },
                                      icon: const Icon(Icons.check),
                                    )),
                              )
                            ],
                          ),
                          TextFormField(
                              initialValue: model.roomRemark,
                              onChanged: model.updateRemark,
                              validator: model.remarkValidator,
                              decoration: const InputDecoration(
                                  // label: Text("共乘須知"),
                                  hintText: "輸入備註",
                                  border: InputBorder.none,
                                  isDense: true),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // time picker
                          ElevatedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                  context: context,
                                  initialDate: model.startTime,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 30)));
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
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary),
                            icon: const Icon(Icons.timer_sharp),
                            label: Text(model.startTimeString),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          // people limit number drop down
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
                          // gender filter drop down
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFormField(
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                onChanged: model.onStartPointChange,
                                onEditingComplete: () async {
                                  FocusScope.of(context).unfocus();
                                  await model.onStartPointInputComplete();
                                  await moveCamera(model.startPoint, model);
                                },
                                validator: model.startPointValidator,
                                decoration: InputDecoration(
                                    isDense: true,
                                    icon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    helperStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                    border: InputBorder.none,
                                    hintText: "集合地點",
                                    helperText: "預計出發時間: ${model.startTimeString}"),
                              ),
                              const Divider(
                                indent: 20,
                              ),
                              TextFormField(
                                onChanged: model.onDestinationChange,
                                onEditingComplete: () async {
                                  FocusScope.of(context).unfocus();
                                  await model.onDestinationInputComplete();
                                  await moveCamera(model.destination, model);
                                },
                                validator: model.destinationPointValidator,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    isDense: true,
                                    icon: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                    hintText: "目的地",
                                    helperText: "預計抵達時間: ${model.endTimeString}"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
