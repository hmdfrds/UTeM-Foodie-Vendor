import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utem_foodir_vendor/screens/banner_screen.dart';
import 'package:utem_foodir_vendor/screens/dashboard_screen.dart';
import 'package:utem_foodir_vendor/screens/order_screen.dart';
import 'package:utem_foodir_vendor/screens/product_screen.dart';
import 'package:utem_foodir_vendor/screens/reports_screen.dart';
import 'package:utem_foodir_vendor/screens/splash_screen.dart';

class DrawerServices {
  Widget drawerScreen(tittle, context) {
    if (tittle == 'Dashboard') {
      return MainScreen();
    }
    if (tittle == 'Product') {
      return ProductScreen();
    }
    if (tittle == 'Banner') {
      return BannerScreen();
    }
    if (tittle == 'Orders') {
      return OrderScreen();
    }
    if (tittle == 'LogOut') {
      
    }
    if (tittle == 'Reports') {
      return ReportScreen();
    }

    return MainScreen();
  }


}
