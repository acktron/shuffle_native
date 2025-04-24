import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> _checkPermissions() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) return false;
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<LocationData?> getLocation() async {
    print("LocationService: Getting location...");
    final allowed = await _checkPermissions();
    if (!allowed) {
      print("LocationService: Permissions denied or service not enabled.");
      return null;
    };

    print("LocationService: Permissions granted, fetching location...");
    return await _location.getLocation();
  }
}
