import 'package:chatting/Services/Auth.dart';
import 'package:chatting/model/PhoneAuthmodel.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phoneauth_event.dart';
part 'phoneauth_state.dart';

class PhoneauthBloc extends Bloc<PhoneauthEvent, PhoneauthState> {
  final AuthProvider authProvider;
  String verificationIds;
  PhoneauthBloc(this.authProvider) : super(PhoneauthInitial()) {
    on<PhoneNumberVerify>((event, emit) async {
      print("Bloc call");
      try {
        await authProvider.PhoneNumberVerify(
            phoneNumber: event.phoneNumber,
            verificationFailed: (FirebaseException e) {
              if (e.code == 'invalid-phone-number') {
                print(e.toString());
                emit(PhoneAuthFailure(message: e.toString()));
              }
            },
            verificationCompleted: (AuthCredential authCredential) async {
              // UserCredential userCredential = await FirebaseAuth.instance
              //     .signInWithCredential(authCredential);
            },
            codeSent: (String verificationId, int resendToken) {
              verificationIds = verificationId;
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              verificationIds = verificationId;
            });
      } on FirebaseAuthException catch (e) {
        emit(PhoneAuthFailure(message: e.toString()));
      }
    });

    on<VerifySMSCode>((event, emit) async {
      print("SMS Bloc call");
      try {
        PhoneAuthModel modeldata = await authProvider.verifySMS(
            smscode: event.smscode, VerificationId: verificationIds);
        if (modeldata.phoneAuthState == PhoneAuthState.verify) {
          print("OTP send");
          emit(PhoneAuthSuccess(uid: modeldata.uid));
        } else {
          print("'Code Invalid'");
          emit(PhoneAuthFailure(message: 'Code Invalid'));
        }
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
