import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  LocationData? _currentLocation;

  LocationData? get currentLocation => _currentLocation;

  Future<void> fetchLocation() async {
    // if (_currentLocation == null) {
      // Fetch location only if it hasn't been set yet
      _currentLocation = await _locationService.getLocation();
      notifyListeners();
    // }
  }

  void updateLocation(double latitude, double longitude) {
    if (_currentLocation == null ||
        _currentLocation!.latitude != latitude ||
        _currentLocation!.longitude != longitude) {
      // Update only if the location has changed
      _currentLocation = LocationData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
      });
      notifyListeners(); // Notify listeners about the location update
    }
  }
}
