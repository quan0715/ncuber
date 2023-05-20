import 'dart:ffi';

class PersonModel {
  int? uid; // user id
  List<int>? carpoolSsnHists; // 併車紀錄
  double? rating; // 併車評分 from carpoolSsnHists // 可null // 預設5

  // from portal
  String? name; //名字
  String? phone; // 手機
  String? studentId; // 學號
  String? gender; // 性別
  String? department; // 就讀學位名
  String? grade; // 年級

  PersonModel({
    this.uid,
    this.carpoolSsnHists = const [],
    this.rating = 5.0,
    this.name,
    this.phone,
    this.studentId,
    this.gender,
    this.department,
    this.grade,
  });

  factory PersonModel.fromJSON(Map<String, dynamic> json) => PersonModel(
    uid: json["uid"] as int,
    carpoolSsnHists: json['carpoolSsnHists'] as List<int>,
    rating: (json['total_rating'] ?? 5.0) as double, // if null then return 5
    name: json['name'] as String,
    phone: json['phone'] as String,
    studentId: json['studentId'] as String,
    gender: json['gender'] as String,
    department: json['department'] as String,
    grade: json['grade'] as String,
  );
}
