import 'package:flutter/material.dart';
import 'package:shuffle_native/widget/rent_card.dart'; // Import the RentCard widget
import 'package:shuffle_native/models/item.dart'; // Import the shared RentItem class

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  // Dummy data model for each rentable item
  final List<RentItem> _items = const [
    RentItem(
      price: 'Rs 10/day',
      title: 'Casio FX-991MS Scientific Calculator',
      location: 'Crossing Republik',
      imageAsset: 'assesets/images/test_img.png',
    ),
    RentItem(
      price: 'Rs 50/day',
      title: 'Sony Bluetooth Headphones',
      location: 'Crossing Republik',
      imageAsset: 'assets/headphones.png',
    ),
    RentItem(
      price: 'Rs 10/day',
      title: 'Canon EOS 1500D DSLR Camera',
      location: 'Crossing Republik',
      imageAsset: 'assets/camera.png',
    ),
    RentItem(
      price: 'Rs 10/day',
      title: 'Logitech Wireless Mouse',
      location: 'Crossing Republik',
      imageAsset: 'assets/mouse.png',
    ),
    RentItem(
      price: 'Rs 10/day',
      title: 'Casio FX-991MS Scientific Calculator',
      location: 'Crossing Republik',
      imageAsset: 'assets/calculator.png',
    ),
    RentItem(
      price: 'Rs 10/day',
      title: 'Casio FX-991MS Scientific Calculator',
      location: 'Crossing Republik',
      imageAsset: 'assets/calculator.png',
    ),
    // add more items as needed...
  ];

  @override
  Widget build(BuildContext context) {
    final Color tealColor = const Color(0xFF21C7A7);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(tealColor),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top App Bar with Shuffle logo - matched exactly with the reference image
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
                            // color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assesets/images/MainLogo.png',
                              height: 30,
                              width: 30,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback icon if image not found
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
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[700], size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Crossing Republik',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: Colors.grey[700],
                        size: 20,
                      ),
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
                  childAspectRatio: 0.72, // Further adjusted for better layout
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
