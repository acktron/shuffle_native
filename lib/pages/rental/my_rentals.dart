import 'package:flutter/material.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widgets/cards/rental_item_card.dart';
import 'package:shimmer/shimmer.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rented Items",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
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
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  List<Booking> updatedBookings =
                      await widget._apiService.getUserBookings();
                  setState(() {
                    allItems = updatedBookings;
                  });
                } catch (error) {
                  // Handle error if needed
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: ListView.builder(
                        itemCount: 6,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    )
                  : filteredItems.isEmpty
                      ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.hourglass_empty,
                                    size: 80,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No rentals available for the selected status.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
          ),
        ],
      ),
    );
  }
}
