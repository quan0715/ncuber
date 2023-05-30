import 'package:flutter/material.dart';
import 'package:ncuber/view/dashboard_ncuber.dart';
import 'package:ncuber/view/show_current_room_view.dart';
import 'package:ncuber/view_model/carpool_card_view_model.dart';
import 'package:ncuber/view_model/user_view_model.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final pages = <Widget>[
    const DashboardNcUber(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, model, child) =>
      model.isJoinCarpoolRoom ? ChangeNotifierProvider<CarpoolCardViewModel>(
          create: (context) => CarpoolCardViewModel(carModel: model.currentCarModel!)..loadDate(),
          child: const ShowCurrentCarpoolView()
      ):
      Scaffold(
        appBar: AppBar(
          title: const Text('NCUBER'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: model.isJoinCarpoolRoom ? null :
        FloatingActionButton.extended(
          label: const Text('發起共乘'),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/map');
          },
        ),
        // TODO: check if person have join cardpool show carpool otherwise show dashboard
        body: const DashboardNcUber()
      ),
    );
  }
}
