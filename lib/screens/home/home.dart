import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fride/services/auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  Position? currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlan = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latlan, zoom: 16);

    newController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newController = controller;

              locatePosition();
            },
          ),
        ],
      ),
    );
  }
}
