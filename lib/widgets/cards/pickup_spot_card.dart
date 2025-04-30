import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/profile/add_pickup_spot.dart';
import '../../models/address.dart';

class MyAddressCard extends StatelessWidget {
  final Address address;
  final void Function(int id) onDelete; // Callback for delete action with id

  const MyAddressCard({super.key, required this.address, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Full Name: ${address.fullName}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Phone: ${address.phoneNumber}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Street: ${address.streetAddress}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'City: ${address.city}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'State: ${address.state}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Postal Code: ${address.postalCode}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Country: ${address.country}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Default: ${address.isDefault ? "Yes" : "No"}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.teal),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => AddPickupSpot(pickupSpot: address),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // Start from the right
                          const end = Offset.zero; // End at the current position
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Address'),
                        content: const Text('Are you sure you want to delete this address?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete(address.id!); // Pass the address id to the callback
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
