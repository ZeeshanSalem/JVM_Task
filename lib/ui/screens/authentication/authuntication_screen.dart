import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/colors.dart';
import 'package:flutter_ecommerce_whitelabel/core/constants/text_style.dart';
import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/ui/custom_widgets/socail_auth_button.dart';
import 'package:flutter_ecommerce_whitelabel/ui/screens/dashboard/dashboard_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import 'authentication_view_model.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool isAvailable;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isBiometricAvailable();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthViewModel(),
      child: Consumer<AuthViewModel>(
        builder: (context, model, child) =>
            ModalProgressHUD(
              inAsyncCall: model.state == ViewState.busy,
              child: SafeArea(
                  child: Scaffold(
                    backgroundColor: backgroundColor,

                    body: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(25, 65, 25, 28),
                      child: Column(
                        children: [

                          Text("Welcome Back 👋️‍", style: headingTextStyle,),

                          SizedBox(height: 9,),

                          Text("We are happy to see you again.\nLogin to proceed.",
                            style: subHeadingTextStyle.copyWith(
                              height: 1.2,
                              fontSize: 16,
                            ),),

                          SizedBox(height: 45,),

                          SocialAuthButton(
                            onPressed: () async{
                              await model.signInWithGoogle();
                              if(model.authResult.status){
                                Get.to(DashboardScreen());
                              } else{
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Login Error'),
                                    content: Text(
                                        model?.authResult?.errorMessage ??
                                            'Login Failed'),
                                  ),
                                );
                              }
                            },
                            buttonName: "Login with Google",
                          ),

                          SizedBox(height: 45,),

                          SocialAuthButton(
                            onPressed: () async{
                              await model.signInWithFacebook();
                              if(model.authResult.status){
                                Get.to(DashboardScreen());
                              } else{
                                showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Login Error'),
                                    content: Text(
                                        model?.authResult?.errorMessage ??
                                            'Login Failed'),
                                  ),
                                );
                              }
                            },
                            buttonName: "Login with facebook",
                          ),

                          SizedBox(height: 20,),

                          ///
                          /// This Check if For Finger Print Login
                          ///
                          model.isFingerLoginEnable && isAvailable ?
                          OutlineButton(
                              onPressed: () async {
                                if (isAvailable) {
                                  await _getListOfBiometricTypes();
                                  await _authenticateUser();
                                }
                              },
                            child: Text("Finger Print Login"),

                              ) : Container(),

                        ],
                      ),
                    ),
                  )),
            ),
      ),
        );
  }


  Future<void> _isBiometricAvailable() async {
    isAvailable = false;
    try {
      isAvailable = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return ;

    isAvailable
        ? print('Biometric is available!')
        : print('Biometric is unavailable.');

  }

  Future<void> _getListOfBiometricTypes() async {
    List<BiometricType> listOfBiometrics;
    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    print(listOfBiometrics);
  }

  Future<void> _authenticateUser() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason:
        "Please authenticate for Home Screem",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    isAuthenticated
        ? print('User is authenticated!')
        : print('User is not authenticated.');

    if (isAuthenticated) {
      Get.to(DashboardScreen());
    }
  }
}
