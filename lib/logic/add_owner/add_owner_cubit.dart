import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_owner_state.dart';

class AddOwnerCubit extends Cubit<AddOwnerState> {
  AddOwnerCubit() : super(AddOwnerInitial());
}
