class group_profile_model {
  String groupName;
  String groupImage;
  String groupUrl;
  String description;
  List admin;
  List mamber;

  group_profile_model(
      {this.groupName,
      this.groupImage,
      this.groupUrl,
      this.description,
      this.admin,
      this.mamber});
}
