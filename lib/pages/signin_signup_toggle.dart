import 'package:flutter/material.dart';
import 'package:flutter_add_friends/pages/login_page.dart';
import 'package:flutter_add_friends/pages/signup_page.dart';

class SigninSignupToggle extends StatefulWidget {
  const SigninSignupToggle({super.key});

  @override
  State<SigninSignupToggle> createState() => _SigninSignupToggleState();
}

class _SigninSignupToggleState extends State<SigninSignupToggle> {
  // show login page
  bool showLoginPage = true;

  void toggleScreen() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        showSignUpPage: toggleScreen,
      );
    } else {
      return SignUpPage(
        showLoginPage: toggleScreen,
      );
    }
  }
}
