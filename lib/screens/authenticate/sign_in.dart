import 'package:flutter/material.dart';
import 'package:fride/services/auth.dart';
import 'package:fride/shared/constants.dart';
import 'package:fride/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function? toggleScreen;
  const SignIn({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.blue[50],
            appBar: AppBar(
              backgroundColor: Colors.blue[400],
              elevation: 0.0,
              title: Text("Sign in to FRide"),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () => widget.toggleScreen!(),
                    icon: Icon(Icons.person_add, color: Colors.white),
                    label: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration:
                                inputDecoration.copyWith(hintText: "Email"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration:
                                inputDecoration.copyWith(hintText: "Password"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                            obscureText: true,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            child: Text("Sign in"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService
                                    .signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error =
                                        "Please enter a valid Email or Password.";
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15.00,
                            ),
                          ),
                        ],
                      ))),
            ));
  }
}
