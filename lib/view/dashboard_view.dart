import 'package:flutter/material.dart';
import 'package:ncuber/view/dashboard_ncuber.dart';
import 'package:ncuber/view/dashboard_user_log.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int selectedIndex = 0;
  final pages = <Widget>[
    const DashboardNcUber(),
    const UserLog(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NCUBER'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          debugPrint(index.toString());
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.car_crash),
            label: 'NCUber',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '歷程紀錄',
          ),
        ],
      ),
      body: pages[selectedIndex],
    );
  }
}
