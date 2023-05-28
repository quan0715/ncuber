import 'package:flutter/material.dart';
import 'package:ncuber/view/dashboard_ncuber.dart';
import 'package:ncuber/view/dashboard_user_log.dart';
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
    return ChangeNotifierProvider<UserViewModel>.value(
      value: ModalRoute.of(context)!.settings.arguments as UserViewModel,
      child: Consumer<UserViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: const Text('NCUBER'),
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('發起共乘'),
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/map');
            },
          ),
          // TODO: check if person have join cardpool show carpool otherwise show dashboard
          body: model.isJoinCarpoolRoom ? const DashboardNcUber() : const DashboardNcUber(),
        ),
      ),
    );
  }
}
