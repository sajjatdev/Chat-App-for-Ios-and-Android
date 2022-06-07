import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'cunrrent_user_event.dart';
part 'cunrrent_user_state.dart';

class CunrrentUserBloc extends Bloc<CunrrentUserEvent, CunrrentUserState> {
  final AuthProvider authProvider;
  CunrrentUserBloc(this.authProvider) : super(CunrrentUserInitial()) {
    on<calluserdata>((event, emit) async {
      // TODO: implement event handler
      User uid = await authProvider.currentuser();

      if (uid != null) {
        emit(hasdata(user: uid));
      }
    });
  }
}
