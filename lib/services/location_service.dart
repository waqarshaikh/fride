import 'dart:async';

import 'package:fride/models/custom_user.dart';
import 'package:fride/services/auth.dart';
import 'package:location/location.dart';

class LocationService {
  // Keep track of current Location
  UserLocation _currentLocation = UserLocation();
  Location location = Location();
  // Continuously emit location updates
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) async {
          _locationController.add(UserLocation(
            latitude: locationData.latitude,
            longitude: locationData.longitude,
          ));
        });
      }
    });
  }

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } catch (e) {
      print('Could not get the location: $e');
    }

    return _currentLocation;
  }
}
