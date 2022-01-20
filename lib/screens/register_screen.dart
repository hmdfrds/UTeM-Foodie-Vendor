import 'package:flutter/material.dart';
import 'package:utem_foodir_vendor/screens/login_screen.dart';
import 'package:utem_foodir_vendor/widgets/image_picker.dart';
import 'package:utem_foodir_vendor/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text('Register'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ShopPicCard(),
                  RegisterForm(),
                  Row(
                    children: [
                      FlatButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Already have an account ? ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
