import 'package:flutter/material.dart';

class RentalItem {
  final String name;
  final String category;
  final double pricePerDay;
  final int rentedDays;
  final String returnDate;
  final String imageUrl;
  final bool isActive;

  RentalItem({
    required this.name,
    required this.category,
    required this.pricePerDay,
    required this.rentedDays,
    required this.returnDate,
    required this.imageUrl,
    this.isActive = true,
  });
}

class RentedItemsPage extends StatefulWidget {
  const RentedItemsPage({super.key});

  @override
  _RentedItemsPageState createState() => _RentedItemsPageState();
}

class _RentedItemsPageState extends State<RentedItemsPage> {
  List<RentalItem> rentedItems = [
    RentalItem(
      name: 'Casio FX-991MS',
      category: 'Scientific Calculator',
      pricePerDay: 10.0,
      rentedDays: 3,
      returnDate: 'March 10',
      imageUrl: 'assets/images/calculator.png',
    ),
    RentalItem(
      name: 'Casio FX-991MS',
      category: 'Scientific Calculator',
      pricePerDay: 10.0,
      rentedDays: 3,
      returnDate: 'March 10',
      imageUrl: 'assets/images/calculator.png',
    ),
    RentalItem(
      name: 'Casio FX-991MS',
      category: 'Scientific Calculator',
      pricePerDay: 10.0,
      rentedDays: 3,
      returnDate: 'March 10',
      imageUrl: 'assets/images/calculator.png',
    ),
    // Add more items as needed
  ];

  Future<void> _refreshItems() async {
    // Simulate a network call or data refresh
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      rentedItems = List.from(rentedItems); // Replace with updated data
    });
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
              child: ListView.builder(
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
  final RentalItem item;

  const RentedItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Item Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                item.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ); // Fallback icon for missing images
                },
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Rs ${item.pricePerDay.toInt()}/day',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Rented for ${item.rentedDays} days',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Text(
                    'Return by ${item.returnDate}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                color: const Color(0x1A4CAF50),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Active !',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
