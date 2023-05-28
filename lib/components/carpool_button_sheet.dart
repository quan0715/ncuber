import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/model/car_model.dart';

class CarPoolButtonSheetView extends StatefulWidget {
  const CarPoolButtonSheetView({super.key, required this.carPoolData, required this.buttomBar});
  final CarModel carPoolData;
  final Widget buttomBar;
  @override
  State<CarPoolButtonSheetView> createState() => _CarPoolButtonSheetViewState();
}

class _CarPoolButtonSheetViewState extends State<CarPoolButtonSheetView> {
  Widget informationDisplay(String title, String info) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary, fontStyle: FontStyle.italic)),
              const SizedBox(
                width: 10,
              ),
              Text(info,
                  style:
                      Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary)),
            ],
          ),
        ),
        const Divider(
          height: 10,
          thickness: 2,
        )
      ],
    );
  }

  String getTimeString(DateTime time) {
    final checkFormatter = DateFormat('yyyy-MM-dd');
    final formatter = DateFormat('MM-dd HH:mm');
    final nowDate = checkFormatter.format(DateTime.now());
    return nowDate == checkFormatter.format(time) ? "Today ${DateFormat("HH:mm").format(time)}" : formatter.format(time);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                informationDisplay("房間名稱", widget.carPoolData.roomTitle ?? '暫無房間名稱'),
                informationDisplay("備註", widget.carPoolData.remark ?? '無備註'),
                informationDisplay("出發點", "${widget.carPoolData.startLoc}"),
                informationDisplay("目的地", "${widget.carPoolData.endLoc}"),
                informationDisplay("預計出發時間", getTimeString(widget.carPoolData.startTime!)),
                informationDisplay("預計到達時間", getTimeString(widget.carPoolData.endTime!)),
                informationDisplay("人數限制", "${widget.carPoolData.personNumLimit}"),
                informationDisplay("性別限制", "${widget.carPoolData.genderLimit}"),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: widget.buttomBar,
                )
              ],
            )),
      ),
    );
  }
}
