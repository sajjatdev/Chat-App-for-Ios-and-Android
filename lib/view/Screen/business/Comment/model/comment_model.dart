class Comment_model {
  String messageType;
  String message;

  Comment_model({this.messageType, this.message});

  Comment_model.fromJson(Map<String, dynamic> json) {
    messageType = json['message_type'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_type'] = this.messageType;
    data['message'] = this.message;
    return data;
  }
}

class CommentModel {
  String message;
  int time;
  String messageType;
  String sender;
  bool read;
  String id;
  String type;
  List like;

  CommentModel(
      {this.message,
      this.time,
      this.messageType,
      this.sender,
      this.read,
      this.id,
      this.like,
      this.type});

  CommentModel.fromJson(Map<String, dynamic> json, {String id}) {
    message = json['message'];
    time = json['time'];
    messageType = json['message_type'];
    sender = json['sender'];
    read = json['read'];
    type = json['type'];
    like = json["like"] ?? [""];
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
