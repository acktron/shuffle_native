import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF21C7A7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchLocationAndAddress, // Pull-to-refresh logic
          child: CustomScrollView(
            slivers: [
              // Top App Bar with Shuffle logo and Logout button
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
                      // Logout button
                      TextButton(
                        onPressed: () async {
                          final success =
                              await Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).logout();
                          if (success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/signin',
                              (route) => false,
                            );
                          }
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF21C7A7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Location bar
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: 'Search for calculator, tools etc',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
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
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _NavBarItemState createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.9; // Scale down on tap
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Scale back to normal
    });
    if (widget.onTap != null) {
      widget.onTap!(); // Trigger the onTap callback
    }
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0; // Reset scale if tap is canceled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.isSelected ? const Color(0xFF087272) : Colors.grey,
              size:
                  widget.isSelected ? 28 : 24, // Larger size for selected icons
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color:
                    widget.isSelected ? const Color(0xFF087272) : Colors.grey,
                fontSize:
                    widget.isSelected
                        ? 14
                        : 12, // Larger font size for selected labels
                fontWeight:
                    widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
