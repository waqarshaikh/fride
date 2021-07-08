import 'package:flutter/material.dart';
import 'package:fride/models/custom_user.dart';
import 'package:fride/screens/authenticate/authenticate.dart';
import 'package:fride/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    return user != null ? Home() : Authenticate();
  }
}
