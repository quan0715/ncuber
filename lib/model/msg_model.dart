class MsgModel {
  int? carpoolSsn;
  DateTime? releaseTime; // 傳訊時間 // server store as string
  String? text; // 訊息內容
  int? personUid; // 發言人uid

  MsgModel({this.carpoolSsn,
  this.releaseTime,
  this.te

  static fromJson(msgHist) {}xt,
  this.personUid});

  factory MsgModel.fromJson(Map<String, dynamic> json) => MsgModel(
    carpoolSsn: json['carpoolSsn'] as int,
    releaseTime: DateTime.tryParse(json['releaseTime'] as String) as DateTime,
    text: json['text'] as String,
    personUid: json['personUid'] as int,
  );
}
