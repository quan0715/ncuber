import 'package:flutter/material.dart';
import 'package:ncuber/components/status_chip.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:provider/provider.dart';

class CarPoolCard extends StatelessWidget {
  const CarPoolCard({super.key});
  Widget getTimeLocDisplay({required String time, required String loc}) {
    // final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarpoolCardViewModel>(
      builder: (context, model, child) => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(model.getTitleString,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  StatusChip(status: model.catStatus)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 2,
                      child: Image.asset(
                        "assets/images/b_car.png",
                        width: 100,
                      )),
                  // const SizedBox(width: 20,),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 6,
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
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.primary,
                                      value: model.isLoading ? null : 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  getTimeLocDisplay(time: model.expectedArrivedTimeString, loc: model.carModel.endLoc!)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
