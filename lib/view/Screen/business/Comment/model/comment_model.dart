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
