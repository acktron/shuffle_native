import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/rental/my_rentals.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shuffle_native/models/item.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widget/buttons/secondary_button.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class ProductDetailPage extends StatefulWidget {
  final Item item;
  const ProductDetailPage({super.key, required this.item});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  bool _isBooking = false; // State variable to track booking status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF26C6DA)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            AppLogo(height: 25),
            Text(
              'Shuffle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image Carousel
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Hero(
                tag:
                    'image-hero-${widget.item.id}', // Use the same tag as in RentCard
                child: Image.network(
                  "$baseUrl${widget.item.image}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),

            // Product Info
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product title
                  Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // Owner info
                  Text(
                    'Owner: ${widget.item.owner_name}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Price info
                  Row(
                    children: [
                      Text(
                        'Rs ${widget.item.pricePerDay}/day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Deposit: Rs ${widget.item.depositAmount}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Rent Now button
                  SecondaryButton(
                    text: "Rent Now",
                    onPressed: () {
                      _showBottomModalSheet(context);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description section
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomModalSheet(BuildContext context) {
    DateTime? startDate;
    DateTime? endDate;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Text(
                    'Select Dates',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Start Date
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: startDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                startDate = selectedDate;
                                if (endDate != null &&
                                    endDate!.isBefore(startDate!)) {
                                  endDate = null;
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            startDate == null
                                ? 'Start Date'
                                : startDate!.toLocal().toString().split(' ')[0],
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(0, 50),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // End Date
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              startDate == null
                                  ? null
                                  : () async {
                                    final selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: endDate ?? startDate!,
                                      firstDate: startDate!,
                                      lastDate: DateTime(2100),
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        endDate = selectedDate;
                                      });
                                    }
                                  },
                          icon: Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            endDate == null
                                ? 'End Date'
                                : endDate!.toLocal().toString().split(' ')[0],
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(0, 50),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Confirm Button
                  ElevatedButton(
                    onPressed:
                        _isBooking
                            ? null
                            : () async {
                              if (startDate != null && endDate != null) {
                                setState(() {
                                  _isBooking = true; // Start loading
                                });
                                final success = await _apiService.bookItem(
                                  widget.item.id,
                                  startDate!,
                                  endDate!,
                                );
                                setState(() {
                                  _isBooking = false; // Stop loading
                                });
                                if (success) {
                                  print(
                                    'Booked item with ID: ${widget.item.id} from $startDate to $endDate',
                                  );

                                  Navigator.pop(context);
                                  Navigator.push(context, 
                                    MaterialPageRoute(
                                      builder: (context) => MyRentalsPage(
                                        selectedStatus: 'PENDING',
                                      )
                                    ),
                                  );
                                }
                              } else {
                                // Show Toast
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please select both dates.'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF087272),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        _isBooking
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Book',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
