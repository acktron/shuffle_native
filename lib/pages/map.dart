import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // San Francisco coordinates
          zoom: 10,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('sf'),
            position: const LatLng(37.7749, -122.4194),
            infoWindow: const InfoWindow(title: 'San Francisco'),
          ),
        },
      ),
    );
  }
}