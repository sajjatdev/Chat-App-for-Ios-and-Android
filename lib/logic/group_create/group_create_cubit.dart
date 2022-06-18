import 'package:bloc/bloc.dart';
import 'package:chatting/Services/message.dart';
import 'package:equatable/equatable.dart';

part 'group_create_state.dart';

class GroupCreateCubit extends Cubit<GroupCreateState> {
  final messageing crate_group;
  GroupCreateCubit(this.crate_group) : super(GroupCreateInitial());

  Future<void> create(
      {List admin,
      String group_name,
      String group_image,
      List mamber,
      String description,
      String group_username,
      String group_url}) async {
    await crate_group.create_Group(
        admin: admin,
        group_image: group_image,
        group_name: group_name,
        description: description,
        mamber: mamber,
        group_url: group_url,
        group_username: group_username);
  }
}
