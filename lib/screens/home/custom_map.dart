import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fride/models/custom_user.dart';
import 'package:fride/services/auth.dart';
import 'package:fride/services/database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatefulWidget {
  CustomMap({Key? key}) : super(key: key);

  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final AuthService _auth = AuthService();
  Position? currentPosition;
  var geoLocator = Geolocator();
  List<Marker> markers = <Marker>[];
  GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();
  UserLocation? userLocation;
  StreamSubscription? subscription;
  final databaseServeice =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

  late BitmapDescriptor carIcon;

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/car-icon.png');
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.best);
    currentPosition = position;

    LatLng latlan = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latlan, zoom: 16);

    mapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    DatabaseService(uid: _auth.customUser!.uid)
        .setUserLocationData(lat: position.latitude, lng: position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    userLocation = Provider.of<UserLocation>(context);
    addToFirebase(userLocation);
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(userLocation!.latitude ?? 12.0,
                  userLocation!.longitude ?? -110.32),
              zoom: 10),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            _addMarker();
            locatePosition();
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          markers: Set<Marker>.of(markers),
        ),
      ],
    );
  }

  _addMarker() async {
    var snapshot = FirebaseFirestore.instance.collection('users').snapshots();

    subscription = snapshot.listen((QuerySnapshot querySnapshot) {
      markers.clear();
      querySnapshot.docs.forEach((doc) {
        if (doc['role'] == 'Rider') {
          markers.add(Marker(
              icon: carIcon,
              markerId: MarkerId(doc["name"]),
              position: LatLng(doc['lat'], doc['lng']),
              infoWindow: InfoWindow(title: doc["name"])));
        }
      });
    });
  }

  Future<void> addToFirebase(userLocation) async {
    print('User UID: ${_auth.customUser!.uid}');
    await DatabaseService(uid: _auth.customUser!.uid).setUserLocationData(
        lat: userLocation.latitude, lng: userLocation.longitude);
  }

  @override
  dispose() {
    subscription!.cancel();
    super.dispose();
  }
}
