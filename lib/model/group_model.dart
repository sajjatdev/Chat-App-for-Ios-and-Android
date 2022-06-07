class group_model {
  String groupName;
  List Mamber;
  List admin;
  String type;
  String roomID;
  String groupImage;

  group_model(
      {this.groupName,
      this.type,
      this.roomID,
      this.groupImage,
      this.Mamber,
      this.admin});

  group_model.fromJson(Map<String, dynamic> json) {
    admin = json['admin'];
    Mamber = json['mamber'];
    groupName = json['Group_name'];
    type = json['type'];
    roomID = json['Room_ID'];
    groupImage = json['group_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Group_name'] = this.groupName;
    data['type'] = this.type;
    data['Room_ID'] = this.roomID;
    data['group_image'] = this.groupImage;
    return data;
  }
}
