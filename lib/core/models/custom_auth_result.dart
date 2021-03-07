import 'package:firebase_auth/firebase_auth.dart';

class CustomAuthResult {
  bool status;
  String errorMessage;
  String errorCode;
  User user;

  CustomAuthResult({this.status = true, this.errorMessage, this.errorCode,this.user});
}
