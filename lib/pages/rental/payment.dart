import 'package:flutter/material.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';

class CheckoutPage extends StatefulWidget {
  final int bookingId;
  const CheckoutPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  Booking? booking; // Nullable booking object
  bool isLoading = true; // Loading state
  String? errorMessage; // Error message state

  @override
  void initState() {
    super.initState();
    _fetchBooking(); // Fetch booking on init
  }

  Future<void> _fetchBooking() async {
    try {
      final fetchedBooking = await _apiService.getBookingById(widget.bookingId);
      setState(() {
        booking = fetchedBooking;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load booking details';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = 0;
    int depositAmount = 0;

    if (booking != null) {
      totalPrice = double.parse(booking!.total_price).toInt();
      depositAmount = double.parse(booking!.item.depositAmount).toInt();
    }

    // Remove the default Material styling
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.white),
      ),
      body: SafeArea(
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(),
                ) // Show loader
                : errorMessage != null
                ? Center(child: Text(errorMessage!)) // Show error message
                : Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back navigation with title
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 20,
                          bottom: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: const Color(0xFF26C6B7),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Confirm & Pay',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Main content with scrolling
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product card
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 20,
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Product image
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      // Product details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking!.item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            // Text(
                                            //   booking!.,
                                            //   style: const TextStyle(
                                            //     fontSize: 14,
                                            //     color: Color(0xFF666666),
                                            //   ),
                                            // ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Rs ${booking!.item.pricePerDay}/day',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'From ${booking!.start_date} to ${booking!.end_date}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Owner: ${booking!.item.owner_name}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF666666),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Order Summary
                                const Text(
                                  'Order Summary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Summary rows
                                buildSummaryRow(
                                  'Rental Charge',
                                  '₹ ${booking!.total_price}',
                                ),
                                buildSummaryRow(
                                  'Deposit',
                                  '₹ ${booking!.item.depositAmount}',
                                ),

                                buildSummaryRow('Platform Fee', '₹ ${(0.1 * totalPrice).toStringAsFixed(2)}'),
                                const Divider(
                                  height: 32,
                                  color: Color(0xFFEEEEEE),
                                ),

                                // Total amount
                                buildTotalRow(
                                  'Total Amount',
                                  '₹ ${totalPrice + depositAmount}',
                                ),

                                const SizedBox(height: 24),

                                // Payment method
                                const Text(
                                  'Online Payment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Razorpay option
                                Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/razorpay_logo.png',
                                      height: 30,
                                      // If you don't have the asset, use a placeholder
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text(
                                                'Razorpay',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Confirm button
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF26C6B7),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    minimumSize: const Size(
                                      double.infinity,
                                      56,
                                    ),
                                  ),
                                  child: const Text(
                                    'Confirm Order',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  Widget buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
          ),
        ],
      ),
    );
  }

  Widget buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
      ],
    );
  }
}
