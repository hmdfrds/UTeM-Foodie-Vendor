import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:utem_foodir_vendor/screens/dashboard_screen.dart';
import 'package:utem_foodir_vendor/screens/login_screen.dart';
import 'package:utem_foodir_vendor/screens/register_screen.dart';
import 'package:utem_foodir_vendor/services/drawer_services.dart';
import 'package:utem_foodir_vendor/widgets/drawer_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const id = 'home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerServices _services = DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          appBarHeight: 80,
          key: _key,
          sliderMenuOpenSize: 200,
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState!.closeDrawer();
              setState(() {
                this.title = title;
              });
            },
          ),
          sliderMain: _services.drawerScreen(title,context)),
    );
  }
}
