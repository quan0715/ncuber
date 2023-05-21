import 'package:flutter/material.dart';

class TestPortalAuthView extends StatefulWidget {
  const TestPortalAuthView({super.key});

  @override
  State<TestPortalAuthView> createState() => _TestPortalAuthViewState();
}

class _TestPortalAuthViewState extends State<TestPortalAuthView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('測試portal登入')),
    body: Column(children: <Widget>[Text(),Text(), Text(), Text()]),)
  }
}
