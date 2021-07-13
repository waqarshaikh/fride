import 'package:flutter/material.dart';
import 'package:fride/models/custom_user.dart';
import 'package:fride/screens/home/custom_map.dart';
import 'package:fride/services/auth.dart';
import 'package:fride/services/location_service.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {

    return StreamProvider<UserLocation>.value(
      initialData: UserLocation(latitude: 70.0, longitude: 20.0),
      value: LocationService().locationStream,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Home")),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: CustomMap() 
      ),
    );
  }
}
