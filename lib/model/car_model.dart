import 'dart:ffi';

/// Type: model Class
/// Descriptions: 併車的(房間)屬性
/// Author: Staler2019(Github.com)
class CarModel {
  late String roomTitle; // 標題
  late String status; // 現在狀態
  late int launchPersonUid; // 發起人uid
  late String remark; // 備註
  late DateTime startTime; // 出發時間
  late String startLoc; // 集合地點
  late DateTime endTime; // 預期到達時間
  late String endLoc; // 目的地
  late int personsNumLimit; // 人數上限
  late int totalExceptCost; // 搭乘總花費
  late String genderLimit; // 性別限制
  late Float ratingStandard; // 乘客最低分數
}
