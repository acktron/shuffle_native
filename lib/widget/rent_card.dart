import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shuffle_native/constants.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/product_page.dart'; // Import the shared RentItem class

class RentCard extends StatelessWidget {
  final Item item;
  final Color tealColor;

  const RentCard({required this.item, required this.tealColor});

  // Calculate distance between user and item location
  Future<double> _calculateDistance(Position userPosition) async {
    if (item.location != null) {
      return Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        item.location!.coordinates[1], // Latitude of the item
        item.location!.coordinates[0], // Longitude of the item
      );
    }
    return 0.0;
  }

  // Build the image section of the card
  Widget _buildImageSection() {
    return Expanded(
      flex: 5,
      child: Stack(
        children: [
          Image.network(
            "$baseUrl${item.image}",
            fit: BoxFit.contain,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF087272),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Text(
                '${item.pricePerDay} / day',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the distance display section
  Widget _buildDistanceSection() {
    return FutureBuilder<Position>(
      future: Geolocator.getCurrentPosition(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            'Calculating distance...',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          );
        } else if (snapshot.hasError) {
          return const Text(
            'Error fetching location',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          );
        } else if (snapshot.hasData) {
          final userPosition = snapshot.data!;
          return FutureBuilder<double>(
            future: _calculateDistance(userPosition),
            builder: (context, distanceSnapshot) {
              if (distanceSnapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Calculating distance...',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                );
              } else if (distanceSnapshot.hasError) {
                return const Text(
                  'Error calculating distance',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                );
              } else {
                final distance = distanceSnapshot.data!;
                return Text(
                  '${(distance / 1000).toStringAsFixed(2)} km away',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                );
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Build the info section of the card
  Widget _buildInfoSection(BuildContext context) { // Accept context as a parameter
    return Container(
      color: const Color(0xFF087272),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),

          // Location and Distance
          _buildDistanceSection(),
          const SizedBox(height: 8),

          // Rent button
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: tealColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(item: item),
                  ),
                );
              },
              child: const Text(
                'Rent Now',
                style: TextStyle(
                  color: Color(0xFF087272),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(),
          _buildInfoSection(context), // Pass context here
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap; // Added onTap as a nullable parameter

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap, // Initialize onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use onTap here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF26C6DA) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF26C6DA) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
