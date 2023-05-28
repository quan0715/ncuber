import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/components/status_chip.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:provider/provider.dart';

class CarPoolButtomSheetView extends StatelessWidget {
  const CarPoolButtomSheetView({super.key});
  Widget getTimeLocDisplay({required String time, required String loc}) {
    // final formatter = DateFormat('yyyy-MM-dd HH:mm');
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
    return Consumer<CarpoolCardViewModel>(
      builder: (context, model, child) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model.getTitleString, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      StatusChip(status: model.carStatus)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(model.carModel.remark!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            Row(
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
                            const Divider(
                              indent: 20,
                            ),
                            Row(
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
                                getTimeLocDisplay(time: model.endTimeString, loc: model.carModel.endLoc!),
                              ],
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
                        child: RawChip(avatar: Icon(Icons.person), label: Text("性別限制 ${model.carModel.genderLimit}")),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO 加入共乘
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
    );
  }
}
