import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> _checkPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<LocationData?> getLocation() async {
    print("LocationService: Getting location...");
    final allowed = await _checkPermissions();
    if (!allowed) {
      print("LocationService: Permissions denied or service not enabled.");
      return null;
    }

    print("LocationService: Permissions granted, fetching location...");
    return await _location.getLocation();
  }
}
