import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/app_user.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/custom_auth_result.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/auth_service.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/database_services.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/shared_preference.dart';
import 'package:flutter_ecommerce_whitelabel/core/view_models/base_view_model.dart';

import '../../../locator.dart';

class AuthViewModel extends BaseViewModel {
  final authService = locator<AuthService>();
  AppUser appUser = AppUser();
  CustomAuthResult authResult;
  final sharedPreference = locator<SharedPreferencesProvider>();
  bool isFingerLoginEnable = false;
  AuthViewModel(){
    getFingerLoginStatus();
  }

  getFingerLoginStatus() async{
    isFingerLoginEnable  = await sharedPreference.getFingerLoginStatus();
    notifyListeners();
  }

  ///
  /// This method is For SignInWithFacebook
  ///
  signInWithFacebook() async{
    setState(ViewState.busy);
    try{
      authResult = await authService.signInWithFacebook();
      if(authResult.status){
        print("Login");
      }
    }catch(e, s){
      print("@AuthViewModel signWithFacebook Exception: $e");
      print(s);
    }
    setState(ViewState.idle);
  }


  ///
  /// This method is For SignInWithGoogle
  ///
  signInWithGoogle() async{
    setState(ViewState.busy);
    try{
      authResult = await authService.signInWithGoogle();
      if(authResult.status){
        print("Login");
      }
    }catch(e, s){
      print("@AuthViewModel signInWithGoogle Exception: $e");
      print(s);
    }
    setState(ViewState.idle);
  }


}

