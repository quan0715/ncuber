class PersonModel {
  List<int>? carIdHists; // 併車紀錄
  int? nowCarId;

  // from portal
  String? name; //名字
  String? phone; // 手機
  String? stuId; // 學號
  int? gender; // 性別 // 1:男 2:女
  String? department; // 就讀學位名
  String? grade; // 年級

  PersonModel({
    this.carIdHists = const [],
    this.nowCarId,
    this.name,
    this.phone,
    this.stuId,
    this.gender,
    this.department,
    this.grade,
  });

  factory PersonModel.fromJSON(Map<String, dynamic> json) => PersonModel(
        carIdHists: json['carIdHists'] as List<int>,
        nowCarId: json['nowCarId'] as int?,
        name: json['name'] as String,
        phone: json['phone'] as String,
        stuId: json['stuId'] as String,
        gender: json['gender'] as int,
        department: json['department'] as String,
        grade: json['grade'] as String,
      );
}
