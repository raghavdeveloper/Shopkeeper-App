import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vendor_app/providers/auth_provider.dart';
import 'package:flutter_vendor_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _fromKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _fromKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/logo.png',
                  height: 250,
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(text: '', children: [
                    TextSpan(
                        text: 'Forgot Password  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text:
                            'Dont worry, provide us your registered Email, we will send you an email to reset your password',
                        style: TextStyle(color: Colors.red, fontSize: 20)),
                  ]),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter Email';
                    }
                    final bool _isValid =
                        EmailValidator.validate(_emailTextController.text);
                    if (!_isValid) {
                      return 'Invalid Email Format';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () {
                            if (_fromKey.currentState.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Check your Email ${_emailTextController.text} to reset your password')));
                            }
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                          color: Theme.of(context).primaryColor,
                          child: _loading
                              ? LinearProgressIndicator()
                              : Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
