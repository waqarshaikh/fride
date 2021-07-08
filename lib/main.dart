import 'package:flutter/material.dart';
import 'package:fride/models/custom_user.dart';
import 'package:fride/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fride/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
