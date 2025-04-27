import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/pages/rental/product_page.dart'; // Import the shared RentItem class

class RentCard extends StatelessWidget {
  final Item item;
  final Color tealColor;

  const RentCard({super.key, required this.item, required this.tealColor});

  // Calculate distance between user and item location
  Future<double> _calculateDistance(Position userPosition) async {
    if (item.location != null) {
      return Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        item.location!.coordinates[1]!, // Latitude of the item
        item.location!.coordinates[0]!, // Longitude of the item
      );
    }
    return 0.0;
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 5,
      child: AspectRatio(
        aspectRatio: 1 / 1, // Enforce 1:1 aspect ratio
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Hero(
            tag: 'image-hero-${item.id}', // Unique tag for hero animation
            child: Container(
              color: Colors.grey.shade200, // Fallback color
              child: Image.network(
                "$baseUrl${item.image}",
                fit: BoxFit.cover, // Ensure it covers the aspect ratio
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
            ),
          ),
        ),
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
  Widget _buildInfoSection(BuildContext context) {
    // Accept context as a parameter
    return Container(
      // color: const Color(0xFF087272),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              // fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '₹${item.pricePerDay} / day',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            "Owner: ${item.owner_name}",
            maxLines: 2,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),

          // Location and Distance
          // _buildDistanceSection(),
          // const SizedBox(height: 8),

          // Rent button
          // SizedBox(
          //   width: double.infinity,
          //   height: 30,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white,
          //       foregroundColor: tealColor,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(6),
          //       ),
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ProductDetailPage(item: item),
          //         ),
          //       );j
          //     },
          //     child: const Text(
          //       'Rent Now',
          //       style: TextStyle(
          //         color: Color(0xFF087272),
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(item: item),
          ),
        );
      },
      child: Material(
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
      ),
    );
  }
}
