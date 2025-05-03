import 'package:flutter/material.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/pages/rental/approve_page.dart';
import 'package:shuffle_native/pages/rental/payment.dart';
import 'package:shuffle_native/pages/rental/receivepage.dart';
import 'package:shuffle_native/utils/constants.dart';

class RentalItemCard extends StatelessWidget {
  final Booking booking;

  const RentalItemCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Tapped on booking: ${booking.id}");
        Widget? targetPage;
        switch (booking.status) {
          case "APPROVED":
            targetPage = ReceivePage(
              booking: booking,
            ); // Replace with actual page
            break;
          case "PENDING":
            targetPage = RentRequestDetailsPage(
              booking: booking,
            ); // Replace with actual page
            break;
          // case "APPROVED":
          //   targetPage = ApprovedPage(bookingId: booking.id); // Replace with actual page
          //   break;
          // case "REJECTED":
          //   targetPage = RejectedPage(bookingId: booking.id); // Replace with actual page
          //   break;
          // case "COMPLETED":
          //   targetPage = CompletedPage(bookingId: booking.id); // Replace with actual page
          //   break;
        }
        if (targetPage != null) {
          print("Navigating to target page: ${targetPage.runtimeType}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage!),
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Image.network(
                "$baseUrl${booking.item.image}",
                height: 80,
                width: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(booking.item.description),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: "Rs ${booking.item.pricePerDay}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: const [
                          TextSpan(
                            text: "/day",
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Text("Rented for ${booking.item.pricePerDay} days"),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text("${booking.status} !"),
                backgroundColor:
                    {
                      "ACTIVE": Colors.green.shade100,
                      "PENDING": Colors.orange.shade100,
                      "APPROVED": Colors.blue.shade100,
                      "REJECTED": Colors.red.shade100,
                      "COMPLETED": Colors.purple.shade100,
                    }[booking.status] ??
                    Colors.grey.shade100,
                labelStyle: TextStyle(
                  color:
                      {
                        "ACTIVE": Colors.green.shade800,
                        "PENDING": Colors.orange.shade800,
                        "APPROVED": Colors.blue.shade800,
                        "REJECTED": Colors.red.shade800,
                        "COMPLETED": Colors.purple.shade800,
                      }[booking.status] ??
                      Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
