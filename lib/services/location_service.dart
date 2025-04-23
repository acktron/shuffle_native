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
    final allowed = await _checkPermissions();
    if (!allowed) return null;

    return await _location.getLocation();
  }
}
