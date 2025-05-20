import 'package:flutter/material.dart';

import '../main_screen.dart';
import '../new auth/login.dart';
import '../new auth/registar.dart';
import '../new auth/reset pass.dart';
import '../screens/upload_screen.dart';
import 'App_routesName.dart';

class AppRoutes {
  AppRoutes._();

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutesname.Registar: (_) => RegisterScreen(),
    AppRoutesname.Login2: (_) => LoginScreen2(),
    AppRoutesname.forgotPassword: (_) => ForgotPasswordScreen(),
    AppRoutesname.UploadScreen: (_) => UploadScreen(),
    AppRoutesname.MainScreen: (_) => MainScreen(),

  };
}
