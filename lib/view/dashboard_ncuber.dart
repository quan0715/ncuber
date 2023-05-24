import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncuber/components/carpool_button_sheet.dart';
import 'package:ncuber/components/carpool_dashboard_card.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view/create_carpool_view.dart';
import 'package:ncuber/view_model/show_all_carpool_view_model.dart';
import 'package:provider/provider.dart';

class DashboardNcUber extends StatefulWidget {
  const DashboardNcUber({Key? key}) : super(key: key);

  @override
  State<DashboardNcUber> createState() => _DashboardNcUberState();
}

class _DashboardNcUberState extends State<DashboardNcUber> {
  Widget emptyListView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/empty_list.png'),
        const SizedBox(
          height: 20,
        ),
        Text(
          '目前沒有任何拼車',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
  void onCarClicked(CarModel data) async {
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CarPoolButtonSheetView(
          carPoolData: data,
          buttomBar: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // TODO : create new car pool
                  debugPrint("加入新的共乘");
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
                label: const Text("加入共乘"),
              )
            ],
          )));
}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowAllCarPooViewModel>(
      create: (context) => ShowAllCarPooViewModel(),
      child: Consumer<ShowAllCarPooViewModel>(
          builder: (context, viewModel, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('所有拼車',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    ),
                    viewModel.carpoolListIsEmpty
                        ? Expanded(child: emptyListView())
                        : Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.allCarpoolData.length,
                              itemBuilder: (context, index) {
                                final carPool = viewModel.allCarpoolData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                                  child: MaterialButton(
                                    // clipBehavior: Clip.none,
                                    onPressed: () => onCarClicked(carPool),
                                    child: CarPoolCard(carPoolData: carPool)
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              )),
    );
  }
}

