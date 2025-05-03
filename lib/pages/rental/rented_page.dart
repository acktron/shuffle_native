import 'package:flutter/material.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/pages/rental/product_page.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class RentedItemsPage extends StatefulWidget {
  const RentedItemsPage({super.key});

  @override
  _RentedItemsPageState createState() => _RentedItemsPageState();
}

class _RentedItemsPageState extends State<RentedItemsPage> {
  List<Item> rentedItems = [];
  final ApiService _apiService = ApiService(); // Initialize ApiService

  void _fetchRentedItems() async {
    setState(() {
      rentedItems = []; // Clear the list before fetching
    });

    try {
      final items = await _apiService.getUserItems();
      setState(() {
        rentedItems = items;
      });
    } catch (error) {
      // Handle error
      print('Error fetching rented items: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRentedItems();
  }

  Future<void> _refreshItems() async {
    try {
      final items = await _apiService.getUserItems();
      setState(() {
        rentedItems = items;
      });
    } catch (error) {
      // Handle error if needed
      print('Error refreshing rented items: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assesets/images/MainLogo.png', // Replace with the path to your image
              height: 32.0, // Adjust the height as needed
            ),
            const SizedBox(
              width: 8.0,
            ), // Add spacing between the image and text
            const Text(
              'Shuffle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Rented Items',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshItems,
              child: rentedItems.isEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      itemCount: 6, // Number of shimmer placeholders
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 16.0,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Container(
                                          height: 16.0,
                                          width: 100.0,
                                          color: Colors.grey[300],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      itemCount: rentedItems.length,
                      itemBuilder: (context, index) {
                        final item = rentedItems[index];
                        return RentedItemCard(item: item);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class RentedItemCard extends StatelessWidget {
  final Item item;

  const RentedItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle onTap action here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(item: item),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Item Image with Hero
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Hero(
                    tag: "image-hero-${item.id}", // Unique tag for Hero animation
                    child: Image.network(
                      "$baseUrl${item.image}",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                          size: 40,
                        ); // Fallback icon for missing images
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Rs ${item.pricePerDay.toString()}/day',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Active Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: item.isAvailable
                      ? const Color(0x1A4CAF50)
                      : const Color(0x1AF44336),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  item.isAvailable ? 'Available' : 'Rented',
                  style: TextStyle(
                    color: item.isAvailable
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFF44336),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
