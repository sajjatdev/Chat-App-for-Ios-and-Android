import 'package:bloc/bloc.dart';
import 'package:chatting/Services/Auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'phoneupdate_state.dart';

class PhoneupdateCubit extends Cubit<PhoneupdateState> {
  final AuthProvider authProvider;
  String verificationIds;
  PhoneupdateCubit(this.authProvider) : super(PhoneupdateInitial());

  Future<void> Phone_number_Change({String number}) async {
    try {
      emit(Loading());
      await authProvider.PhoneNumberVerify(
          phoneNumber: number,
          verificationFailed: (FirebaseException e) {
            if (e.code == 'invalid-phone-number') {
              emit(phone_invalid(phone_invalidmessage: "Phone Number invalid"));
            }
          },
          verificationCompleted: (AuthCredential authCredential) async {
            // UserCredential userCredential = await FirebaseAuth.instance
            //     .signInWithCredential(authCredential);
          },
          codeSent: (String verificationId, int resendToken) {
            print("Done");
            verificationIds = verificationId;
            emit(otpSend(otpSendmessage: "Otp Send"));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            verificationIds = verificationId;
            emit(otpSend(otpSendmessage: "Otp Send"));
          });
    } on FirebaseAuthException catch (e) {
      emit(Errorphone(Errorphonemessage: "Inetrnet error"));
    }
  }

  Future<void> OTP_Verify({String code}) async {
    emit(Loading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIds, smsCode: code);
      await FirebaseAuth.instance.currentUser.updatePhoneNumber(credential);
      if (credential.token != null) {
        emit(VerifyDone());
      }
    } on FirebaseAuthException catch (e) {
      if (e.message.contains(
          "e.message.contains('The sms verification code used to create the phone auth credential is invalid')")) {
        emit(Otpinvalid(Otpinvalidmessage: "Invalid Otp"));
      } else if (e.message.contains('The sms code has expired')) {
        emit(OtpEx(OtpExmessage: "OtpEx"));
      } else {
        emit(Errorphone(Errorphonemessage: "Inetrnet error"));
      }
    }
  }
}
