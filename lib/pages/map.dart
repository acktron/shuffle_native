import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/providers/location_provider.dart';
import 'package:shuffle_native/services/location_service.dart';
import 'package:geocoding/geocoding.dart'; // Import geocoding package
import 'package:shuffle_native/pages/search_page.dart'; // Import the SearchPage

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
    tilt: 0, // Set tilt to 0 for 2D view
    bearing: 0, // Set bearing to 0 for 2D view
  );

  final Set<Marker> _markers = {};
  final LocationService _locationService = LocationService();
  bool _isLoading = true;
  LatLng? _currentCameraPosition; // Track the current camera position
  bool _isPanning = false; // Track whether the user is panning the map
  late AnimationController _animationController; // Animation controller for marker lift
  late Animation<double> _liftAnimation; // Animation for vertical lift
  String _currentAddress = 'Fetching address...'; // Variable to store the address

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Animation duration
    );
    _liftAnimation = Tween<double>(begin: 0, end: -20).animate(_animationController); // Lift by 20 pixels
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            polylines: {}, // Clear polylines
            compassEnabled: false, // Disable compass
            zoomGesturesEnabled: true, // Enable zoom gestures
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            onCameraMove: (CameraPosition position) {
              if (!_isPanning) {
                setState(() {
                  _isPanning = true; // Lift the marker while panning
                });
                _animationController.forward(); // Start lift animation
              }
              _currentCameraPosition = position.target; // Update camera position
            },
            onCameraIdle: () async {
              if (_currentCameraPosition != null) {
                setState(() {
                  _isPanning = false; // Place the marker back when panning stops
                });
                _animationController.reverse(); // Reverse lift animation

                // Update the location in LocationProvider
                Provider.of<LocationProvider>(context, listen: false).updateLocation(
                  _currentCameraPosition!.latitude,
                  _currentCameraPosition!.longitude,
                );

                // Fetch and update the address
                await _updateAddress(_currentCameraPosition!.latitude, _currentCameraPosition!.longitude);

                print('Selected Position: ${_currentCameraPosition!.latitude}, ${_currentCameraPosition!.longitude}');
              }
            },
            onMapCreated: (GoogleMapController controller) async {
              _controller.complete(controller);
              await _addCurrentLocationMarker();
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8, // Add safe area padding
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );

                if (selectedLocation != null && selectedLocation is LatLng) {
                  // Update the current location in LocationProvider
                  Provider.of<LocationProvider>(context, listen: false).updateLocation(
                    selectedLocation.latitude,
                    selectedLocation.longitude,
                  );

                  // Update the map camera position
                  final GoogleMapController controller = await _controller.future;
                  controller.animateCamera(CameraUpdate.newLatLngZoom(selectedLocation, 14));

                  // Update the address
                  await _updateAddress(selectedLocation.latitude, selectedLocation.longitude);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _liftAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _liftAnimation.value), // Apply vertical lift
                  child: const Icon(
                    Icons.location_pin,
                    size: 40,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final locationProvider = Provider.of<LocationProvider>(context, listen: false);
          await locationProvider.fetchLocation(); // Fetch the current location
          // if (locationProvider.currentLocation != null) {
            final currentLocation = LatLng(
              locationProvider.currentLocation!.latitude!,
              locationProvider.currentLocation!.longitude!,
            );
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 14));
          // }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _updateAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      final Placemark place = placemarks.first;

      setState(() {
        _currentAddress =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    } catch (e) {
      setState(() {
        _currentAddress = 'Unable to fetch address';
      });
    }
  }

  Future<void> _addCurrentLocationMarker() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if (locationProvider.currentLocation != null) {
      // Use the current location from LocationProvider if available
      final currentLocation = LatLng(
        locationProvider.currentLocation!.latitude!,
        locationProvider.currentLocation!.longitude!,
      );
      _currentCameraPosition = currentLocation; // Set the initial camera position
      _updateMarkerPosition(currentLocation);

      await _updateAddress(currentLocation.latitude, currentLocation.longitude); // Fetch initial address

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 14));
    }
  }

  void _updateMarkerPosition(LatLng position) {
    print('Selected Position: ${position.latitude}, ${position.longitude}'); // Log the position
  }
}


