import 'package:flutter/material.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';

class RentRequestsPage extends StatefulWidget {
  const RentRequestsPage({Key? key}) : super(key: key);

  @override
  State<RentRequestsPage> createState() => _RentRequestsPageState();
}

class _RentRequestsPageState extends State<RentRequestsPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  List<Booking> _rentRequests = []; // List to hold rent requests

  @override
  void initState() {
    fetchRentRequests();
    super.initState();
  }

  void fetchRentRequests() async {
    try {
      // Fetch rent requests from the API
      final response = await _apiService.getItemPendingBookings();
      setState(() {
        _rentRequests = response; // Update the state with fetched data
      });
      print('Rent requests fetched successfully: $_rentRequests');
    } catch (e) {
      // Handle error
      print('Error fetching rent requests: $e');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assesets/images/MainLogo.png', // Fixed path for app bar logo
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'Shuffle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Rent Requests',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                RentRequestCard(
                  productName: 'Casio FX-991MS',
                  productCategory: 'Scientific Calculator',
                  price: 'Rs 30',
                  requester: 'Devansh',
                  rentalDuration: 5,
                  returnDate: 'April 29',
                  isPricePerDay: false,
                ),
                const SizedBox(height: 12),
                RentRequestCard(
                  productName: 'Casio FX-991MS',
                  productCategory: 'Scientific Calculator',
                  price: 'Rs 10',
                  requester: 'Devansh',
                  rentalDuration: 3,
                  returnDate: 'March 10',
                  isPricePerDay: true,
                ),
                const SizedBox(height: 12),
                RentRequestCard(
                  productName: 'Casio FX-991MS',
                  productCategory: 'Scientific Calculator',
                  price: 'Rs 10',
                  requester: 'Devansh',
                  rentalDuration: 3,
                  returnDate: 'March 10',
                  isPricePerDay: true,
                ),
                const SizedBox(height: 12),
                RentRequestCard(
                  productName: 'Casio FX-991MS',
                  productCategory: 'Scientific Calculator',
                  price: 'Rs 10',
                  requester: 'Devansh',
                  rentalDuration: 3,
                  returnDate: 'March 10',
                  isPricePerDay: true,
                ),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RentRequestCard extends StatelessWidget {
  final String productName;
  final String productCategory;
  final String price;
  final String requester;
  final int rentalDuration;
  final String returnDate;
  final bool isPricePerDay;

  const RentRequestCard({
    Key? key,
    required this.productName,
    required this.productCategory,
    required this.price,
    required this.requester,
    required this.rentalDuration,
    required this.returnDate,
    required this.isPricePerDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assesets/images/test_img.png', // Fixed path for RentRequestCard image
              height: 100,
              width: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productCategory,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isPricePerDay ? '$price/day' : price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Request by : $requester',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Rented for $rentalDuration days',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Return by $returnDate',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red[50],
                  radius: 18,
                  child: Icon(Icons.close, color: Colors.red, size: 20),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.green[50],
                  radius: 18,
                  child: Icon(Icons.check, color: Colors.green, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
