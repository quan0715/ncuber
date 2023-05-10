import 'package:flutter/material.dart';
import 'package:ncuber/view/create_car_pool_view.dart';
import 'package:ncuber/view/dashboard_view.dart';
import 'package:ncuber/view/outh_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCUBER',
      theme: ThemeData(
        colorSchemeSeed: const Color(0XFF00639B),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OuthView(),
        '/dashboard': (context) => const DashboardView(),
        '/create': (context) => CreateCarpoolView(),
      },
      // home: const OuthView()
    );
  }
}
