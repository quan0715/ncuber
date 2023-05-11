import 'dart:ffi';

/// Type: model class
/// Descriptions: 乘客屬性
/// Author: Staler2019(Github.com)
class PersonModel {
  late int uid; // user id
  late List<int> carpoolSsnHists; // 併車紀錄
  late Float rating; // 併車評分 from carpoolSsnHists

  // from portal
  late String name; //名字
  late String phone; // 手機
  late String studentId; // 學號
  late String gender; // 性別
  late String department; // 就讀學位名
  late String grade; // 年級
}
