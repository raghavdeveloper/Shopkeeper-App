//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_vendor_app/widgets/image_picker.dart';
import 'package:flutter_vendor_app/widgets/register_form.dart';

import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      // ignore: deprecated_member_use
                      FlatButton(
                          padding: EdgeInsets.zero,
                          child: RichText(
                            text: TextSpan(text: '', children: [
                              TextSpan(
                                  text: 'Already have an account ? ',
                                  style: TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ]),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          }),
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
