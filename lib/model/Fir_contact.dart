import 'package:azlistview/azlistview.dart';

class GetFireContactList extends ISuspensionBean {
  String phoneNumber;
  String firstName;
  String imageUrl;
  String lastName;
  String tag;
  String username;
  String userStatus;

  GetFireContactList(
      {this.phoneNumber,
      this.firstName,
      this.imageUrl,
      this.tag,
      this.username,
      this.lastName,
      this.userStatus});

  @override
  String getSuspensionTag() => tag;
}
