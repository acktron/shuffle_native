import 'package:flutter/material.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';
import 'package:shuffle_native/widget/rent_card.dart'; // Import the RentCard widget
import 'package:shuffle_native/models/item.dart'; // Import the shared RentItem class
import 'package:shuffle_native/services/location_service.dart'; // Import the LocationService
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:shuffle_native/services/api_service.dart'; // Import ApiService
import 'package:shuffle_native/models/location.dart' as loc;
import 'package:shimmer/shimmer.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _currentLocation = 'Fetching location...';
  String _currentAddress = 'Fetching address...';
  List<Item> _items = []; // Update to make it dynamic
  final ApiService _apiService = ApiService(); // Initialize ApiService
  bool isLoading = false; // Add a state variable for loading

  @override
  void initState() {
    super.initState();
    _fetchLocationAndAddress();
  }

  Future<void> _fetchLocationAndAddress() async {
    setState(() {
      isLoading = true; // Show loader
    });

    final locationService = LocationService();
    final locationData = await locationService.getLocation();
    print("Location data:");

    if (locationData != null) {
      print(
        "Location data: ${locationData.latitude}, ${locationData.longitude}",
      );
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      setState(() {
        _currentLocation = 'Fetching address...';
      });

      try {
        // Fetch the address using geocoding
        final placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );
        final Placemark place = placemarks.first;

        setState(() {
          _currentAddress =
              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });

        // Fetch items based on location
        final location = loc.Location('Point', [
          locationData.longitude!,
          locationData.latitude!,
        ]);
        final items = await _apiService.getItems(
          location,
          10000,
        ); // Radius = 10 km
        setState(() {
          _items = items; // Update the items list
        });
      } catch (e) {
        setState(() {
          _currentAddress = 'Unable to fetch address';
        });
      }
    } else {
      setState(() {
        _currentLocation = 'Unable to fetch location';
        _currentAddress = 'Unable to fetch address';
      });
    }

    setState(() {
      isLoading = false; // Hide loader
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF21C7A7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _fetchLocationAndAddress, // Trigger refresh
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true, // AppBar scrolls with content
              snap: true, // Reappears when scrolling back
              backgroundColor: Colors.white,
              elevation: 1,
              title: Row(
                children: [
                  AppLogo(height: 30),
                  const SizedBox(width: 8),
                  const Text(
                    'Shuffle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30), // Adjusted height
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced vertical padding
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey[700],
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _currentAddress,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Ensure consistent padding
              sliver: isLoading
                  ? SliverToBoxAdapter(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero, // Remove any extra padding
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: 6, // Placeholder shimmer items
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = _items[index];
                        return RentCard(
                          item: item,
                          tealColor: tealColor,
                        );
                      }, childCount: _items.length),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
