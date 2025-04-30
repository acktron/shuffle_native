import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:shuffle_native/models/address.dart';
import 'package:shuffle_native/widgets/cards/pickup_spot_card.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widgets/shimmers/address_card_shirmmer.dart';
import 'package:shuffle_native/pages/profile/add_pickup_spot.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';

class MyPickupSpots extends StatefulWidget {
  const MyPickupSpots({super.key});

  @override
  State<MyPickupSpots> createState() => _MyPickupSpotsState();
}

class _MyPickupSpotsState extends State<MyPickupSpots> {
  final ApiService _apiService = ApiService();
  List<Address> pickupSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPickupSpots();
  }

  Future<void> _fetchPickupSpots() async {
    try {
      final fetchedPickupSpots =
          await _apiService.getAddresses();
      setState(() {
        pickupSpots = fetchedPickupSpots;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Pickup Spots',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading ? _buildLoadingState() : _buildLoadedState(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onAddPickupSpotPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Pickup Spot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 3, // Display 3 shimmer cards as placeholders
      itemBuilder: (context, index) => AddressCardShirmmer(), // No change needed
    );
  }

  Widget _buildLoadedState() {
    if (pickupSpots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No pickup spots found.', // Updated text
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPickupSpots, // Renamed from _fetchAddresses
      child: ImplicitlyAnimatedReorderableList<Address>(
        items: pickupSpots, // Renamed from addresses
        areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
        onReorderFinished: (item, from, to, newItems) {
          setState(() {
            pickupSpots
              ..clear()
              ..addAll(newItems);
          });
        },
        itemBuilder: (context, itemAnimation, item, index) {
          return Reorderable(
            key: ValueKey(item.id),
            builder: (context, dragAnimation, inDrag) {
              return SizeFadeTransition(
                sizeFraction: 0.7,
                curve: Curves.easeInOut,
                animation: itemAnimation,
                child: MyAddressCard(
                  address: item,
                  onDelete: (id) async {
                    final success = await _apiService.deleteAddress(id);
                    if (success) {
                      setState(() {
                        pickupSpots.removeWhere((pickupSpot) => pickupSpot.id == id);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete pickup spot. Please try again.'), // Updated text
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _onAddPickupSpotPressed() {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const AddPickupSpot(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
}
