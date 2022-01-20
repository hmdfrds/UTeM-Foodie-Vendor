import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:utem_foodir_vendor/providers/auth_provider.dart';
import 'package:utem_foodir_vendor/providers/order_provider.dart';
import 'package:utem_foodir_vendor/providers/product_provider.dart';
import 'package:utem_foodir_vendor/screens/add_new_product_screen.dart';
import 'package:utem_foodir_vendor/screens/banner_screen.dart';
import 'package:utem_foodir_vendor/screens/home_screen.dart';
import 'package:utem_foodir_vendor/screens/login_screen.dart';
import 'package:utem_foodir_vendor/screens/order_screen.dart';
import 'package:utem_foodir_vendor/screens/product_screen.dart';
import 'package:utem_foodir_vendor/screens/register_screen.dart';
import 'package:utem_foodir_vendor/screens/reports_screen.dart';
import 'package:utem_foodir_vendor/screens/reset_password_screen.dart';
import 'package:utem_foodir_vendor/screens/splash_screen.dart';

Future<void> main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProductProvider()),
       ChangeNotifierProvider(create: (_) => OrderProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          ProductScreen.id: (context) => ProductScreen(),
          AddNewProduct.id: (context) => AddNewProduct(),
           BannerScreen.id: (context) => BannerScreen(),
           OrderScreen.id: (context) => OrderScreen(),
           ReportScreen.id: (context) => ReportScreen(),
        });
  }
}
