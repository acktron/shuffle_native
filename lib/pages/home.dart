import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/map.dart';
import 'package:shuffle_native/widgets/logos/app_logo.dart';
import 'package:shuffle_native/widgets/rent_card.dart'; // Import the RentCard widget
import 'package:shuffle_native/models/item.dart'; // Import the shared RentItem class
import 'package:shuffle_native/services/location_service.dart'; // Import the LocationService
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:shuffle_native/services/api_service.dart'; // Import ApiService
import 'package:shuffle_native/models/location.dart' as loc;
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:shuffle_native/providers/location_provider.dart'; // Import LocationProvider

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _currentAddress = 'Fetching address...';
  List<Item> _items = [];
  final ApiService _apiService = ApiService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndAddress();
  }

  Future<void> _fetchLocationAndAddress() async {
    setState(() {
      isLoading = true;
    });

    try {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      await locationProvider.fetchLocation();
      final locationData = locationProvider.currentLocation;

      if (locationData != null) {
        await _updateAddress(locationData.latitude!, locationData.longitude!);

        // Fetch items based on location
        final location = loc.Location('Point', [
          locationData.longitude!,
          locationData.latitude!,
        ]);
        final items = await _apiService.getItems(location, 10000);
        setState(() {
          _items = items;
        });
      } else {
        setState(() {
          _currentAddress = 'Unable to fetch address';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Unable to fetch address';
      });
    }

    setState(() {
      isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    // Listen to location updates and update the address dynamically
    if (locationProvider.currentLocation != null) {
      _updateAddress(
        locationProvider.currentLocation!.latitude!,
        locationProvider.currentLocation!.longitude!,
      );
    }

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    // vertical: 2,
                  ), // Reduced vertical padding
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPage(),
                        ),
                      );
                    },
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
                        // Add a small icon to indicate the button is clickable
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ), // Ensure consistent padding
              sliver:
                  isLoading
                      ? SliverToBoxAdapter(
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero, // Remove any extra padding
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                          return RentCard(item: item, tealColor: tealColor);
                        }, childCount: _items.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const MapPage()),
      //     );
      //   },
      //   backgroundColor: tealColor,
      //   child: const Icon(Icons.map_outlined),
      // ),
    );
  }
}
