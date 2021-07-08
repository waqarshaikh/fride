import 'package:flutter/material.dart';
import 'package:fride/screens/authenticate/register.dart';
import 'package:fride/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleScreen() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn == true ? SignIn(toggleScreen: toggleScreen) : Register(toggleScreen: toggleScreen),
    );
  }
}
