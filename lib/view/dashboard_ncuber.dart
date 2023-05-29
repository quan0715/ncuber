import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ncuber/components/carpool_buttom_sheet.dart';
import 'package:ncuber/components/carpool_dashboard_card.dart';
import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:ncuber/view_model/show_all_carpool_view_model.dart';
import 'package:ncuber/view_model/user_view_model.dart';
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
        builder: (context) => ChangeNotifierProvider<CarpoolCardViewModel>(
            create: (context) => CarpoolCardViewModel(carModel: data), child: const CarPoolBottomSheetView()));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShowAllCarPooViewModel>(
      create: (context) => ShowAllCarPooViewModel(),
      child: Consumer<ShowAllCarPooViewModel>(
          builder: (context, viewModel, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "歡迎回來",
                          style: TextStyle(fontSize: 22),
                        ),
                        Consumer<UserViewModel>(
                            builder: (context, model, child) =>
                                Text("${model.name}, ${model.studentId}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      ],
                    ),
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
                                    child: ChangeNotifierProvider<CarpoolCardViewModel>(
                                        create: (context) => CarpoolCardViewModel(carModel: carPool), child: const CarPoolCard())),
                              );
                            },
                          ),
                        ),
                ],
              )),
    );
  }
}
