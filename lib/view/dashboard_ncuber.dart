import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view/dashboard_view.dart';
import 'package:provider/provider.dart';

class DashboardViewModel extends ChangeNotifier {
  List<CarModel> allCarPool = [
    CarModel.create(1)..status = CarStatus.notReady(),
    CarModel.create(2)..status = CarStatus.inProgress(),
    CarModel.create(3)..status = CarStatus.full(),
  ];
}

class DashboardNcUber extends StatelessWidget {
  const DashboardNcUber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (context) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
          builder: (context, viewModel, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('所有拼車',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary
                          )),
                    ),
                    viewModel.allCarPool.isEmpty
                        ? Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                const Text('目前沒有任何拼車'),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/create');
                                  },
                                  child: const Text('發起拼車'),
                                ),
                              ],
                            ))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.allCarPool.length,
                              itemBuilder: (context, index) {
                                final carPool = viewModel.allCarPool[index];
                                return CarPoolCard(carPoolData: carPool);
                              },
                            ),
                          ),
                  ],
                ),
              )),
    );
  }
}

class CarPoolCard extends StatefulWidget {
  const CarPoolCard({super.key, required this.carPoolData});
  final CarModel carPoolData;
  @override
  State<CarPoolCard> createState() => _CarPoolCardState();
}

class _CarPoolCardState extends State<CarPoolCard> {
  Widget getTimeLocDisplay({required DateTime time, required String loc}) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(formatter.format(time),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary)),
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
        ),
        side: BorderSide(color: color.withOpacity(0.2), width: 0),
        labelStyle: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(fontWeight: FontWeight.bold, color: color),
        label: Text(widget.carPoolData.status!.statusName));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Card(
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
                  Text(widget.carPoolData.roomTitle ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  // car pool persons num display
                  Text('${widget.carPoolData.personUids.length} / ${widget.carPoolData.personsNumLimit}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(),
              // Time display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // car pool start time display
                  getTimeLocDisplay(
                      time: widget.carPoolData.startTime!,
                      loc: widget.carPoolData.startLoc!),
                  const Icon(Icons.arrow_forward),
                  // car pool end time display
                  getTimeLocDisplay(
                      time: widget.carPoolData.endTime!,
                      loc: widget.carPoolData.endLoc!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
