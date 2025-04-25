import 'package:flutter/material.dart';
import 'package:shuffle_native/constants.dart';
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
  bool _isLoading = true; // State variable to track loading status

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
        _isLoading = false; // Set loading to false
      });
      print('Rent requests fetched successfully: $_rentRequests');
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false even on error
      });
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Rent Requests',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Show loader while loading
                    : _rentRequests.isEmpty
                    ? const Center(
                      child: Text(
                        'No rent requests available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ) // Show placeholder if no bookings
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _rentRequests.length,
                      itemBuilder: (context, index) {
                        final request = _rentRequests[index];
                        return RentRequestCard(
                          productName: request.item.name,
                          price: request.total_price,
                          requester: "Devansh",
                          rentalDuration:
                              request.end_date
                                  .difference(request.start_date)
                                  .inDays,
                          returnDate: request.end_date.toString().split(' ')[0],
                          imagePath: request.item.image,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class RentRequestCard extends StatelessWidget {
  final String productName;
  final String price;
  final String requester;
  final int rentalDuration;
  final String returnDate;
  final String imagePath;

  const RentRequestCard({
    Key? key,
    required this.productName,
    required this.price,
    required this.requester,
    required this.rentalDuration,
    required this.returnDate,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/approvepage');
        print('Rent request tapped');
      },
      child: Container(
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
              Image.network(
                "$baseUrl$imagePath",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 40,
                  ); // Fallback icon for missing images
                }
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
                    // Text(
                    //   productCategory,
                    //   style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    // ),
                    // const SizedBox(height: 4),
                    Text(
                      '$price/day',
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
      ),
    );
  }
}
