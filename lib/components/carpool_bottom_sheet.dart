import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ncuber/components/status_chip.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:ncuber/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class CarPoolBottomSheetView extends StatelessWidget {
  const CarPoolBottomSheetView({super.key, this.mapController});
  final Completer<GoogleMapController>? mapController;

  Future moveCamera(LatLng target, CarpoolCardViewModel model) async {
    // final point = CameraPosition(target: target, tilt: 0, zoom: 18);
    final GoogleMapController controller = await mapController!.future;
    // await controller.animateCamera(CameraUpdate.newCameraPosition(point));
    await controller.animateCamera(CameraUpdate.newLatLng(target));
    // await Future.delayed(const Duration(seconds: 1));
    // controller.
  }

  Widget getTimeLocDisplay({required String time, required String loc}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, user, child) => Consumer<CarpoolCardViewModel>(
        builder: (context, model, child) => SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(model.getTitleString, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        StatusChip(status: model.catStatus)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(model.carModel.remark!,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: model.personStuIds
                            .map((String studentId) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Chip(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                    avatar: const Icon(Icons.emoji_people_rounded),
                                    label: Text(studentId),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (mapController != null) {
                                    moveCamera(model.startPointLatLng, model);
                                  }
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    getTimeLocDisplay(time: model.startTimeString, loc: model.carModel.startLoc!),
                                  ],
                                ),
                              ),
                              const Divider(
                                indent: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (mapController != null) {
                                    moveCamera(model.destinationLatLng, model);
                                  }
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primary,
                                        value: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    getTimeLocDisplay(time: model.expectedArrivedTimeString, loc: model.carModel.endLoc!),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RawChip(avatar: const Icon(Icons.people), label: Text("人數限制 ${model.carModel.personNumLimit}")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: RawChip(avatar: const Icon(Icons.person), label: Text("性別限制 ${model.carModel.genderLimit ?? '無'}")),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: user.isJoinCarpoolRoom
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    await user.leaveCarPool();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3.0,
                                    // visualDensity: VisualDensity.compact,
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                    foregroundColor: Theme.of(context).colorScheme.onError,
                                  ),
                                  label: const Text("離開房間"),
                                  icon: const Icon(Icons.exit_to_app),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    await user.joinCarPool(model.carModel);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    elevation: 3.0,
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                  label: const Text("加入共乘"),
                                  icon: const Icon(Icons.check),
                                ),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
