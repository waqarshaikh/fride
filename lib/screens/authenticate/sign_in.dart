import 'package:flutter/material.dart';
import 'package:fride/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          title: Text("Sign in to FRide"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 130.0),
          child: ElevatedButton(
            onPressed: () async {
              dynamic result = await _authService.signInAnonymous();

              if (result == null) {
                print("Error in signing in");
              } else {
                print("User is signed in!");
              }
            },
            child: Text("Sign In"),
          ),
        ));
  }
}
