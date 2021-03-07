import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_services.dart';
import '../models/custom_auth_result.dart';
import '../models/app_user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_exception_service.dart';

class AuthService {
  final _firebaseAuth  = FirebaseAuth.instance;
  final _dbService = DatabaseService();
  CustomAuthResult customAuthResult = CustomAuthResult();
  User user;
  bool isLogin = false;
  AppUser appUser = AppUser();

//  Customer customer;
//  final sharedPreferences = SharedPreferencesProvider();

  AuthService() {
    init();
  }

  init() async {
    user = _firebaseAuth.currentUser;

    if(user != null){
      print("User--------------" +user.uid);
      isLogin = true;
      appUser = await _dbService.getUser(user.uid);
    } else{
      isLogin = false;
    }
//    isLogin = FirebaseAuth.instance.currentUser != null;
  }

  ///
  /// This Function for to login With Facebook
  ///
  Future<CustomAuthResult> signInWithFacebook() async{
    print("@AuthService signInWithFacebook");
    try{
      final AccessToken accessToken = await FacebookAuth.instance.login();

      final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.token);

      if(accessToken != null){
        final userData = await FacebookAuth.instance.getUserData();
        appUser.email = userData["email"];
        appUser.fullName = userData["name"];
        appUser.imgUrl = userData["picture"]["data"]["url"];
      }



      final credentials = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

      if (credentials.user == null) {
        customAuthResult.status = false;
        customAuthResult.errorCode = "Undefined";
        customAuthResult.errorMessage = 'An undefined Error happened.';
        return customAuthResult;
      }
      print("User Credential Id" + credentials.user.uid);
      appUser.id = credentials.user.uid;

      ///
      /// Check is user is new one then add user data to firebase user Collection
      ///
      if(credentials.additionalUserInfo.isNewUser){
      await _dbService.registerUser(appUser); }

      print("After ---------------");
      print(credentials.user.uid);
      print(credentials.user.email);

    }on FacebookAuthException catch(e){
      customAuthResult.status = false;
      customAuthResult.errorCode =  e.errorCode;
      customAuthResult.errorMessage = AuthExceptionsService.generateExceptionMessage(e.errorCode);
      print(e.message);
    }
    return customAuthResult;
  }


  ///
  /// This Function is for Sign With Google
  ///
  Future<CustomAuthResult> signInWithGoogle() async{
    print("@signInWithGoogle");

    try{
      final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();

      if(googleSignInAccount != null){
        appUser.email = googleSignInAccount.email;
        appUser.fullName = googleSignInAccount.displayName;
        appUser.imgUrl = googleSignInAccount.photoUrl;
      }else{
        customAuthResult.status = false;
        customAuthResult.errorCode = "Canceled";
        customAuthResult.errorMessage = 'You have Cancelled Google Sign';
        return customAuthResult;
      }

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );



      final credentials = await _firebaseAuth.signInWithCredential(googleAuthCredential);

      if (credentials.user == null) {
        customAuthResult.status = false;
        customAuthResult.errorCode = "Undefined";
        customAuthResult.errorMessage = 'An undefined Error happened.';
        return customAuthResult;
      }

      print("User Credential Id" + credentials.user.uid);
      appUser.id = credentials.user.uid;


      ///
      /// Check is user is new one then add user data to firebase user Collection
      ///
      if(credentials.additionalUserInfo.isNewUser){
      await _dbService.registerUser(appUser);
      }

    }catch(e, s){
      customAuthResult.status = false;
      customAuthResult.errorCode =  e.code ?? "Undefined";
//      customAuthResult.errorMessage = e.message ?? "Failed";
      customAuthResult.errorMessage = AuthExceptionsService.generateExceptionMessage(e.code);
      print("GoogleSignAccount");
      print(e);
      print(s);
    }
    return customAuthResult;
  }

  //Sign out
  signOut() async {
    await FirebaseAuth.instance.signOut();
    this.isLogin = false;
    this.user = null;
  }
}
