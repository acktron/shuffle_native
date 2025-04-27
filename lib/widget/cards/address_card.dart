import 'package:flutter/material.dart';
import '../../models/address.dart';

class MyAddressCard extends StatelessWidget {
  final Address address;

  const MyAddressCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
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
                  Text(
                    'Address',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  Text(
                    'Created At: ${address.createdAt!.toLocal()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: () {
                // TODO: Implement edit address logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
