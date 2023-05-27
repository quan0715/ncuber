import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/components/carpool_button_sheet.dart';
import 'package:ncuber/model/car_model.dart';

class CarPoolCard extends StatefulWidget {
  const CarPoolCard({super.key, required this.carPoolData});
  final CarModel carPoolData;
  @override
  State<CarPoolCard> createState() => _CarPoolCardState();
}

class _CarPoolCardState extends State<CarPoolCard> {
  String getTimeString(DateTime time) {
    final checkFormatter = DateFormat('yyyy-MM-dd');
    final formatter = DateFormat('MM-dd HH:mm');
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? "Today ${DateFormat("HH:mm").format(time)}" : formatter.format(time);
  }

  Widget getTimeLocDisplay({required DateTime time, required String loc}) {
    // final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc, style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        Text(getTimeString(time),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
      ],
    );
  }

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
        ),
      ),
    );
  }
}
