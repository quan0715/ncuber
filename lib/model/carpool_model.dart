import 'package:ncuber/model/car_model.dart';
import 'package:ncuber/model/msg_model.dart';

/// Type: model class
/// Descriptions: 併車屬性
/// Author: Staler2019(Github.com)
class CarpoolModel {
  late CarModel car; // 房間
  late List<int> personUids; // 併車的人們
  late List<MsgModel> msgHists; // 最後n則歷史訊息
}

// TODO. rate 採用post直接回傳
