import 'package:flutter/material.dart';
import 'package:fride/services/auth.dart';
import 'package:fride/services/database.dart';
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
  String name = "";
  String? role = "Customer";
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
                                inputDecoration.copyWith(hintText: "Name"),
                            validator: (value) =>
                                value!.isEmpty ? "Name is empty" : null,
                            onChanged: (value) {
                              setState(() => name = value);
                            },
                          ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(10.0),
                                    backgroundColor: role == "Customer"
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      role = "Customer";
                                    });
                                  },
                                  child: Text(
                                    "Customer",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: role == "Customer"
                                          ? Colors.white
                                          : Colors.green,
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("OR"),
                              SizedBox(
                                width: 10.0,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.all(10.0),
                                    backgroundColor: role == "Rider"
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      role = "Rider";
                                    });
                                  },
                                  child: Text(
                                    "Rider",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: role == "Rider"
                                          ? Colors.white
                                          : Colors.green,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(
                                  bottom: 10.0,
                                  top: 10.0,
                                  right: 30.0,
                                  left: 30.0),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService
                                    .registerWithEmailAndPassword(
                                        email, password);
                                await DatabaseService(
                                        uid: _authService.customUser!.uid)
                                    .setUserData(name: name, role: role);
                                await DatabaseService(
                                        uid: _authService.customUser!.uid)
                                    .setUserLocationData(lat: 12.0, lng: 12.0);
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
                      ))),
            ));
  }
}
