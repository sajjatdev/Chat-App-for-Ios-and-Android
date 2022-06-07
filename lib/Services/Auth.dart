import 'package:chatting/model/PhoneAuthmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  final FirebaseAuth firebaseAuth;

  AuthProvider(FirebaseAuth auth)
      : firebaseAuth = auth ?? FirebaseAuth.instance;

  Future<void> PhoneNumberVerify(
      {String phoneNumber,
      verificationCompleted,
      verificationFailed,
      codeSent,
      codeAutoRetrievalTimeout}) async {
    await firebaseAuth
        .verifyPhoneNumber(
            phoneNumber: phoneNumber,
            verificationCompleted: (verificationCompleted) {},
            verificationFailed: (verificationFailed) {},
            codeSent: codeSent,
            timeout: const Duration(seconds: 60),
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      print("Send code this number $phoneNumber");
    });
  }

  Future<PhoneAuthModel> verifySMS(
      {String smscode, String VerificationId}) async {
    try {
      PhoneAuthCredential phoneAuthCredential =
          await PhoneAuthProvider.credential(
              verificationId: VerificationId, smsCode: smscode);
      print(phoneAuthCredential.token);
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
      if (userCredential.user != null) {
        return PhoneAuthModel(
          phoneAuthState: PhoneAuthState.verify,
          uid: userCredential.user.uid,
        );
      } else {
        return PhoneAuthModel(phoneAuthState: PhoneAuthState.error);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<User> authstatus() {
    return firebaseAuth.authStateChanges();
  }

  Future<User> currentuser() async {
    final user = await firebaseAuth.currentUser;

    return user;
  }
}
