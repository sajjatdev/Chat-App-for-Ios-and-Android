import 'dart:ffi';

class MessageModel {
  String message;
  int time;
  String messageType;
  String sender;
  bool read;
  String id;
  String type;
  List like;

  MessageModel(
      {this.message,
      this.time,
      this.messageType,
      this.sender,
      this.read,
      this.id,
      this.like,
      this.type});

  MessageModel.fromJson(Map<String, dynamic> json, {String id}) {
    message = json['message'];
    time = json['time'];
    messageType = json['message_type'];
    sender = json['sender'];
    read = json['read'];
    type = json['type'];
    like = json["Like"] ?? [""];
    // ignore: prefer_initializing_formals
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['time'] = this.time;
    data['message_type'] = this.messageType;
    data['sender'] = this.sender;
    data['read'] = this.read;
    data['type'] = this.type;
    return data;
  }
}
