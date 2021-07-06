import 'package:flutter/material.dart';
import 'package:fride/screens/authenticate/authenticate.dart';
import 'package:fride/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Authenticate();
  }
}
