import 'dart:ffi';

/// Type: model Class
/// Descriptions: 併車的(房間)屬性
/// Author: Staler2019(Github.com)

class CarStatus {
  /// 併車房間狀態
  // static String notReady = "招募中";
  // static String inProgress = "已發車";
  // static String full = "已滿座";
  // static String end = "已結束";
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
      this.ratingStandard});
  factory CarModel.create(int launchPersonUid) => CarModel(
        roomTitle: 'NCUBER new',
        status: CarStatus.notReady(),
        launchPersonUid: launchPersonUid,
        remark: '',
        startTime: DateTime.now(),
        startLoc: '中央大學正門口',
        endTime: DateTime.now(),
        endLoc: '桃園高鐵站',
        personsNumLimit: 4,
        totalExceptCost: 0,
        ratingStandard: const Float(),
        genderLimit: '',
      );
}
