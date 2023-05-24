import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class UserLog extends StatefulWidget {
  const UserLog({Key? key}) : super(key: key);

  @override
  State<UserLog> createState() => _UserLogState();
}

class _UserLogState extends State<UserLog>{

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('UserLog'),
    );
  }
}
