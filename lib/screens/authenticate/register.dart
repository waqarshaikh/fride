import 'package:flutter/material.dart';
import 'package:fride/services/auth.dart';
import 'package:fride/shared/constants.dart';
import 'package:fride/shared/loading.dart';

class Register extends StatefulWidget {
  final Function? toggleScreen;
  const Register({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              title: Text("Sign up to FRide"),
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () => widget.toggleScreen!(),
                    icon: Icon(Icons.person, color: Colors.white),
                    label:
                        Text("Sign In", style: TextStyle(color: Colors.white))),
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              inputDecoration.copyWith(hintText: "Email"),
                          validator: (value) =>
                              value!.isEmpty ? "Email is empty" : null,
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              inputDecoration.copyWith(hintText: "Password"),
                          validator: (value) => value!.length < 6
                              ? "Password should be at least 8 characters long"
                              : null,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          child: Text("Register"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _authService
                                  .registerWithEmailAndPassword(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = "Please enter a valid Email.";
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
                    ))));
  }
}
