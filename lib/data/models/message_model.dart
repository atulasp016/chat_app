class MessageModel {
  String? msgId;
  String? msg;
  String? sentAt;
  String? readAt;
  String? fromId;
  String? toId;
  int? msgType; //0-> text , 1-> image
  String? imgUrl; //0-> public , 1-> private, 3-> onlyFriends

  MessageModel({
    required this.msgId,
    required this.msg,
    required this.sentAt,
    this.readAt = '',
    required this.fromId,
    required this.toId,
    this.msgType = 0,
    this.imgUrl = '',
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      msgId: json['msgId'],
      msg: json['msg'],
      sentAt: json['sentAt'],
      readAt: json['readAt'],
      fromId: json['fromId'],
      toId: json['toId'],
      msgType: json['msgType'],
      imgUrl: json['imgUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'msg': msg,
      'sentAt': sentAt,
      'readAt': readAt,
      'fromId': fromId,
      'toId': toId,
      'msgType': msgType,
      'imgUrl': imgUrl,
    };
  }
}
