import 'package:flutter/material.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/pages/rental/payment.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widget/shimmers/address_card_shirmmer.dart';

class MyRentalsPage extends StatefulWidget {
  final ApiService _apiService = ApiService();
  final String selectedStatus;
  final bool showAppBar;

  MyRentalsPage({
    super.key,
    this.selectedStatus = "Active",
    this.showAppBar = true,
  });

  @override
  _MyRentalsPageState createState() => _MyRentalsPageState();
}

class _MyRentalsPageState extends State<MyRentalsPage> {
  late String selectedStatus;
  List<Booking> allItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.selectedStatus;
    widget._apiService
        .getUserBookings()
        .then((value) {
          setState(() {
            allItems = value;
            isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Booking> filteredItems =
        allItems.where((item) => item.status == selectedStatus).toList();

    Widget mainContent = Column(
      children: [
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children:
                ["ACTIVE", "PENDING", "APPROVED", "REJECTED", "COMPLETED"]
                    .map(
                      (status) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                selectedStatus == status
                                    ? Colors.teal.shade100
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.teal),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedStatus = status;
                            });
                          },
                          child: Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color:
                                  selectedStatus == status
                                      ? Colors.teal[900]
                                      : Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: isLoading
              ? _buildLoadingState()
              : filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        "No rentals available for the selected status.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return RentalItemCard(booking: filteredItems[index]);
                      },
                    ),
        ),
      ],
    );

    return widget.showAppBar
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.teal),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Rented Items",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            body: mainContent,
          )
        : mainContent;
  }
}

Widget _buildLoadingState() {
  return ListView.builder(
    itemCount: 3, // Display 3 shimmer cards as placeholders
    itemBuilder: (context, index) => AddressCardShirmmer(), // No change needed
  );
}

class RentalItemCard extends StatelessWidget {
  final Booking booking;

  const RentalItemCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutPage(bookingId: booking.id),
          ),
        );
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
                    booking.status == "Rejected"
                        ? Colors.red.shade100
                        : Colors.green.shade100,
                labelStyle: TextStyle(
                  color:
                      booking.status == "Rejected" ? Colors.red : Colors.teal,
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
