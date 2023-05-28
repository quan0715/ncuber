import 'package:flutter/material.dart';
import 'package:ncuber/view/create_carpool_view.dart';
import 'package:ncuber/view/dashboard_view.dart';
import 'package:ncuber/view/outh_page_view.dart';
import 'package:ncuber/view/test_person_view.dart';
import 'package:ncuber/view_model/permission_requester_view_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    grantLocationPermission();
    return MaterialApp(
      title: 'NCUBER',
      theme: ThemeData(
        colorSchemeSeed: const Color(0XFF00639B),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OuthView(),
        '/map': (context) => const CreateCarPoolView(),
        '/dashboard': (context) => const DashboardView(),
        '/test': (context) => TestPersonView(),
      },
    );
  }
}
