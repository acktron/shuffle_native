import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widgets/cards/rent_request_card.dart';

class RentRequestsPage extends StatefulWidget {
  const RentRequestsPage({super.key});

  @override
  State<RentRequestsPage> createState() => _RentRequestsPageState();
}

class _RentRequestsPageState extends State<RentRequestsPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  List<Booking> _rentRequests = []; // List to hold rent requests
  bool _isLoading = true; // State variable to track loading status

  @override
  void initState() {
    super.initState();
    fetchRentRequests();
  }

  Future<void> fetchRentRequests() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching rent requests: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
              'assesets/images/MainLogo.png', // Corrected path for app bar logo
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
            child: const Text(
              'Rent Requests',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded( // Ensure Expanded is directly inside Column
            child: Padding( // Add Padding inside Expanded if needed
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RefreshIndicator(
                onRefresh: fetchRentRequests, // Pull-to-refresh functionality
                child: _isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 6, // Placeholder shimmer items
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ) // Show shimmer effect while loading
                    : _rentRequests.isEmpty
                        ? const Center(
                            child: Text(
                              'No rent requests available.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ) // Show placeholder if no bookings
                        : ListView.builder(
                            itemCount: _rentRequests.length,
                            itemBuilder: (context, index) {
                              final request = _rentRequests[index];
                              return RentRequestCard(
                                booking: request,
                                id: request.id,
                                productName: request.item.name,
                                price: request.total_price,
                                requester: "${request.renter}",
                                rentalDuration: request.end_date
                                    .difference(request.start_date)
                                    .inDays,
                                returnDate:
                                    request.end_date.toString().split(' ')[0],
                                imagePath: request.item.image,
                                onRequestUpdated: () {
                                  // Remove this request from the list
                                  setState(() {
                                    _rentRequests.removeAt(index);
                                  });
                                },
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
