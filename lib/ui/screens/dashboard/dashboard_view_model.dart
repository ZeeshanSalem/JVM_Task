import 'package:flutter_ecommerce_whitelabel/core/enums/view_state.dart';
import 'package:flutter_ecommerce_whitelabel/core/models/app_user.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/auth_service.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/database_services.dart';
import 'package:flutter_ecommerce_whitelabel/core/services/shared_preference.dart';
import 'package:flutter_ecommerce_whitelabel/core/view_models/base_view_model.dart';

import '../../../locator.dart';

class DashboardViewModel extends BaseViewModel{
  List<AppUser> allUser =[];
  final dbService = DatabaseService();
  final authServices = locator<AuthService>();
  final sharedPreference = locator<SharedPreferencesProvider>();
  bool isFingerLoginEnable = false;

  DashboardViewModel(){
    getAllUser();
    getFingerLoginStatus();
  }
  
  getFingerLoginStatus() async{
    isFingerLoginEnable  = await sharedPreference.getFingerLoginStatus();
    notifyListeners();
  }
  

  getAllUser() async{
    setState(ViewState.busy);
    try{
      allUser = await dbService.getAllUser(authServices.appUser.id);

    }catch(e){
      print("@DashboardViewModel getAllUser Exception $e");
    }
    setState(ViewState.idle);
  }

  fingerLock(val) async{
    isFingerLoginEnable = val;
    await sharedPreference.saveFingerLoginStatus(val);
    notifyListeners();
  }


}