import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/components/status_chip.dart';
import 'package:ncuber/model/car_model.dart';
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

<<<<<<< HEAD
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
                  StatusChip(status: model.carStatus)
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
                                      value: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  getTimeLocDisplay(time: model.endTimeString, loc: model.carModel.endLoc!)
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
=======
  Widget getChip() {
    Color color = Color(widget.carPoolData.status!.statusColor);
    return Chip(
        visualDensity: VisualDensity.compact,
        backgroundColor: color.withOpacity(0.15),
        avatar: CircleAvatar(
          backgroundColor: color,
          radius: 5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        side: BorderSide(color: color.withOpacity(0.2), width: 0),
        labelStyle: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold, color: color),
        label: Text(widget.carPoolData.status!.statusName));
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getChip(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // car pool title display
                Text(widget.carPoolData.roomTitle ?? '', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                // car pool persons num display
                Text('${widget.carPoolData.personStuIds.length} / ${widget.carPoolData.personNumLimit}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            // Time display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // car pool start time display
                getTimeLocDisplay(time: widget.carPoolData.startTime!, loc: widget.carPoolData.startLoc!),
                const Icon(Icons.arrow_forward),
                // car pool end time display
                getTimeLocDisplay(time: widget.carPoolData.endTime!, loc: widget.carPoolData.endLoc!),
              ],
            ),
          ],
>>>>>>> 8680f2fe50b9ce6c31dbb2780e90cfd9bf51e571
        ),
      ),
    );
  }
}
