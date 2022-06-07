enum PhoneAuthState {
  verify,
  error,
}

class PhoneAuthModel {
  final String uid;

  final PhoneAuthState phoneAuthState;

  PhoneAuthModel({this.uid = '', this.phoneAuthState});
}
