import 'dart:ffi';

import 'package:ncuber/model/msg_model.dart';


/// 併車房間狀態:
///   .notReady = "招募中";
///   .inProgress = "已發車";
///   .full = "已滿座";
///   .end = "已結束";
class CarStatus {
  final String statusName;
  final int statusColor;

  const CarStatus({required this.statusName, required this.statusColor});

  factory CarStatus.notReady() => const CarStatus(
    statusName: '招募中',
    statusColor: 0XFF0066FF,
  );
  factory CarStatus.inProgress() => const CarStatus(
    statusName: '已發車',
    statusColor: 0XFF0FC100,
  );
  factory CarStatus.full() => const CarStatus(
    statusName: '已滿座',
    statusColor: 0XFFFF9F0F,
  );
  factory CarStatus.end() => const CarStatus(
    statusName: '已結束',
    statusColor: 0XFFFF2C0F,
  );
  factory CarStatus.fromStr(String statusName) {
    if(statusName == '招募中'){
      return CarStatus.notReady();
    }
    else if(statusName == '已發車'){
      return CarStatus.inProgress();
    }
    else if(statusName == '已滿座') {
      return CarStatus.full();
    }
    else if(statusName == '已結束') {
      return CarStatus.end();
    }
    else {
      throw Exception("fail to read status $statusName");
    }
  }
}

class CarModel {
  String? roomTitle; // 標題
  CarStatus? status; // 現在狀態
  int? launchPersonUid; // 發起人uid
  String? remark; // 備註
  DateTime? startTime; // 出發時間
  String? startLoc; // 集合地點
  DateTime? endTime; // 預期到達時間
  String? endLoc; // 目的地
  int? personsNumLimit; // 人數上限
  int? totalExceptCost; // 搭乘總花費
  String? genderLimit; // 性別限制
  Float? ratingStandard; // 乘客最低分數
  List<int> personUids; // 併車的人
  List<MsgModel> msgHists; // 最後n則歷史訊息

  CarModel(
      {this.roomTitle,
      this.status,
      this.launchPersonUid,
      this.remark,
      this.startTime,
      this.startLoc,
      this.endTime,
      this.endLoc,
      this.personsNumLimit,
      this.totalExceptCost,
      this.genderLimit,
      this.ratingStandard,
      this.personUids = const [],
      this.msgHists = const []
    });

  factory CarModel.create(int launchPersonUid) => CarModel(
        roomTitle: 'NCUBER new',
        status: CarStatus.notReady(),
        launchPersonUid: launchPersonUid,
        remark: '',
        startTime: DateTime.now(),
        startLoc: '中央大學正門口',
        endTime: DateTime.now(),
        endLoc: '桃園高鐵站',
        personsNumLimit: 5,
        totalExceptCost: 0,
        ratingStandard: const Float(),
        genderLimit: '',
        personUids: [launchPersonUid],
        msgHists: const []
      );

  // CarStatus cardStatusRule(){

  // }

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    roomTitle: json['roomTitle'] as String,
    status: CarStatus.fromStr(json['status'] as String),
    launchPersonUid: json['launchPersonUid'] as int,
    remark: json['remark'] as String,
    startTime: DateTime.tryParse(json['startTime'] as String) as DateTime,
    startLoc: json['startLoc'] as String,
    endTime: DateTime.tryParse(json['endTime'] as String) as DateTime,
    personsNumLimit: json['personsNumLimit'] as int,
    totalExceptCost: json['totalExceptCost'] as int,
    ratingStandard: json['ratingStandard'] as Float,
    genderLimit: json['genderLimit'] as String,
    personUids: json['personUids'] as List<int>,
    msgHists: json['msgHists'] as List<MsgModel>,
  );
}
