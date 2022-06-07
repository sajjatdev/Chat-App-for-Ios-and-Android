import 'package:azlistview/azlistview.dart';

class NameModel extends ISuspensionBean {
  final String name;
  final String tag;
  final String ID;

  NameModel({
    this.ID,
    this.name,
    this.tag,
  });

  @override
  String getSuspensionTag() => tag;
}