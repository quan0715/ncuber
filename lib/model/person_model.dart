class PersonModel {
  int? uid; // user id // 在得到uid之前可null
  List<int>? carpoolIdHists; // 併車紀錄
  int? nowCarpoolId;

  // from portal
  String? name; //名字
  String? phone; // 手機
  String? studentId; // 學號
  int? gender; // 性別
  String? department; // 就讀學位名
  String? grade; // 年級

  PersonModel({
    this.uid,
    this.carpoolIdHists = const [],
    this.nowCarpoolId,
    this.name,
    this.phone,
    this.studentId,
    this.gender,
    this.department,
    this.grade,
  });

  factory PersonModel.fromPortal() => PersonModel(); // TODO.

  factory PersonModel.fromJSON(Map<String, dynamic> json) => PersonModel(
        uid: json["uid"] as int,
        carpoolIdHists: json['carpoolIdHists'] as List<int>,
        nowCarpoolId: json['nowCarpoolId'] as int?,
        name: json['name'] as String,
        phone: json['phone'] as String,
        studentId: json['studentId'] as String,
        gender: json['gender'] as int,
        department: json['department'] as String,
        grade: json['grade'] as String,
      );
}
