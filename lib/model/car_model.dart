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
    if (statusName == '招募中') {
      return CarStatus.notReady();
    } else if (statusName == '已發車') {
      return CarStatus.inProgress();
    } else if (statusName == '已滿座') {
      return CarStatus.full();
    } else if (statusName == '已結束') {
      return CarStatus.end();
    } else {
      throw Exception("fail to read status $statusName");
    }
  }
}

class CarModel {
  int? carId;
  String? launchStuId; // 發起人uid
  DateTime? startTime; // 出發時間
  String? startLoc; // 集合地點
  DateTime? endTime; // 預期到達時間
  String? endLoc; // 目的地
  int? personNumLimit; // 人數上限
  int? genderLimit; // 性別限制
  String? roomTitle; // 標題
  CarStatus? status; // 現在狀態 // 自行判斷
  String? remark; // 備註
  List<String> personStuIds;

  CarModel(
      {this.carId,
      this.roomTitle,
      this.status,
      this.launchStuId,
      this.remark = "",
      this.startTime,
      this.startLoc,
      this.endTime,
      this.endLoc,
      this.personNumLimit,
      this.genderLimit,
      this.personStuIds = const []});

  factory CarModel.create(String launchStuId) => CarModel(
        carId: 1,
        roomTitle: 'NCUBER new',
        status: CarStatus.notReady(),
        launchStuId: launchStuId,
        remark: '',
        startTime: DateTime.now(),
        startLoc: '中央大學正門口',
        endTime: DateTime.now(),
        endLoc: '桃園高鐵站',
        personNumLimit: 5,
        genderLimit: 0,
        personStuIds: [launchStuId],  
      );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    var carModel = CarModel(
      carId: json['carId'] as int,
      roomTitle: json['roomTitle'] as String,
      launchStuId: json['launchStuId'].toString(),
      remark: json['remark'] as String,
      startTime: DateTime.tryParse(json['startTime'] as String) as DateTime,
      startLoc: json['startLoc'] as String,
      endTime: DateTime.tryParse(json['endTime'] as String) as DateTime,
      endLoc: json['endLoc'] as String,
      personNumLimit: json['personNumLimit'] as int,
      genderLimit: json['genderLimit'] as int,
      personStuIds: (json['stuIds'] as List).map((studentId)=>studentId.toString()).toList(),
    );

    carModel.statusCheck();

    return carModel;
  }

  void statusCheck() {
    var presentTime = DateTime.now();
    if (presentTime.compareTo(endTime!) > 0) {
      status = CarStatus.end();
    } else if (presentTime.compareTo(startTime!) > 0 &&
        presentTime.compareTo(endTime!) <= 0) {
      status = CarStatus.inProgress();
    } else if (personNumLimit! > personStuIds.length) {
      status = CarStatus.notReady();
    } else if (personNumLimit! <= personStuIds.length) {
      status = CarStatus.full();
    } else {
      throw Exception("CarModel status check fail.");
    }
  }
}
