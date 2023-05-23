import 'package:flutter/material.dart';
import 'package:ncuber/model/msg_model.dart';

class MsgViewModel extends ChangeNotifier {
  late MsgModel _msgModel;

  setMsg(MsgModel msgModel) {
    _msgModel = msgModel;
    notifyListeners();
  }

  MsgModel get msgModel => _msgModel;
}
