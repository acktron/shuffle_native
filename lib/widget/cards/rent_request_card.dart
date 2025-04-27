import 'package:flutter/material.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/pages/rental/approve_page.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/utils/constants.dart';

class RentRequestCard extends StatefulWidget {
  final int id;
  final String productName;
  final String price;
  final String requester;
  final int rentalDuration;
  final String returnDate;
  final String imagePath;
  final Booking booking;
  final VoidCallback onRequestUpdated; // Callback to notify parent

  const RentRequestCard({
    super.key,
    required this.productName,
    required this.price,
    required this.requester,
    required this.rentalDuration,
    required this.returnDate,
    required this.imagePath,
    required this.id,
    required this.onRequestUpdated, // Pass callback from parent
    required this.booking,
  });

  @override
  State<RentRequestCard> createState() => _RentRequestCardState();
}

class _RentRequestCardState extends State<RentRequestCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RentRequestDetailsPage(booking: widget.booking),
          ),
        );
        print('Rent request tapped');
      },
      child: Container(
        height: 120, // Set a fixed height for the card
        margin: const EdgeInsets.only(bottom: 10), // Add external margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1, // Set 1:1 aspect ratio
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Image.network(
                  "$baseUrl${widget.imagePath}",
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
            const SizedBox(width: 8),
            Expanded( // Ensure Expanded is directly inside Row
              child: Padding( // Add Padding inside Expanded if needed
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${widget.price}/day',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Request by : ${widget.requester}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rented for ${widget.rentalDuration} days',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
