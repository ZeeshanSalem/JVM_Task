
import 'package:flutter_ecommerce_whitelabel/core/services/database_services.dart';
import 'package:get_it/get_it.dart';

import 'core/services/auth_service.dart';
import 'core/services/shared_preference.dart';

GetIt locator = GetIt.instance;

setupLocator(){
  locator.registerSingleton(AuthService());
  locator.registerSingleton(DatabaseService());
  locator.registerSingleton(SharedPreferencesProvider());
}