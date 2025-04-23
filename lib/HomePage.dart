import 'package:flutter/material.dart';
import 'package:shuffle_native/widget/rent_card.dart'; // Import the RentCard widget
import 'package:shuffle_native/models/item.dart'; // Import the shared RentItem class
import 'package:shuffle_native/services/location_service.dart'; // Import the LocationService
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import 'package:shuffle_native/services/api_service.dart'; // Import ApiService
import 'package:shuffle_native/models/location.dart' as loc;

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

  @override
  void initState() {
    super.initState();
    _fetchLocationAndAddress();
  }

  Future<void> _fetchLocationAndAddress() async {
    final locationService = LocationService();
    final locationData = await locationService.getLocation();

    if (locationData != null) {
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      setState(() {
        _currentLocation = 'Fetching address...';
      });

      try {
        // Fetch the address using geocoding
        final placemarks = await placemarkFromCoordinates(
          latitude!,
          longitude!,
        );
        final Placemark place = placemarks.first;

        setState(() {
          _currentAddress =
              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        });

        // Fetch items based on location
        final location = loc.Location('Point', [longitude, latitude]);
        print('Location: $location');
        final items = await _apiService.getItems(location, 10000); // Radius = 10 km

        setState(() {
          _items = items; // Update the items list
        });
        print(
          items
        );
      } catch (e) {
        print('Error fetching items: $e');
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
  }

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF21C7A7);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(tealColor),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar with Shuffle logo
            SliverToBoxAdapter(
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Shuffle logo row with icon and text
                    Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assesets/images/MainLogo.png',
                              height: 30,
                              width: 30,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.shuffle,
                                  color: Color(0xFF21C7A7),
                                  size: 20,
                                );
                              },
                            ),
                          ),
                        ),
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
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // Location bar
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                  ],
                ),
              ),
            ),

            // Search bar
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    hintText: 'Search for calculator, tools etc',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),

            // Grid of cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = _items[index];
                  return RentCard(item: item, tealColor: tealColor);
                }, childCount: _items.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
              ),
            ),

            // Bottom padding
            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color tealColor) {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: tealColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Rented'),
        BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Upload'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      onTap: (i) {
        // handle tab changes
      },
    );
  }
}
