import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shuffle_native/widgets/indicators/pacman_loading_indicator.dart';

class CheckoutPage extends StatefulWidget {
  final int bookingId;
  const CheckoutPage({super.key, required this.bookingId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService
  Booking? booking; // Nullable booking object
  bool isLoading = true; // Loading state
  String? errorMessage; // Error message state
  final _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print("Payment successful: ${response.paymentId}");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Payment Successful',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your payment has been processed successfully. Thank you for your order!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back
                Navigator.of(context).pop(); // Navigate back

              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    final success = _apiService.manageBooking(booking!.id, "ACTIVE");

    // Add your logic here
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    print("Payment failed: ${response.code} - ${response.message}");
    // Add your logic here
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print("External wallet selected: ${response.walletName}");
    // Add your logic here
  }

  @override
  void initState() {
    super.initState();
    _fetchBooking(); // Fetch booking on init
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> createOrder() async {
    try {
      final response = await _apiService.createPayment(
        booking!.total_price,
        booking!.id,
      );

      // Initialize Razorpay with the order ID
      var options = {
        'key': response.razorpayKey,
        'amount': (double.parse(booking!.total_price) * 100).toInt(),
        'currency': 'INR',
        'name': booking!.item.name,
        'description': 'Payment for booking ID: ${booking!.id}',
        'order_id': response.orderId, // Use the order ID from the API response
      };
      _razorpay.open(options); // Open Razorpay payment gateway
      // Handle successful order creation
      print('Order created successfully: $response');
    } catch (e) {
      // Handle error
      print('Error creating order: $e');
    }
  }

  // Future<void> verifyOrder(String razorpayOrderId) async {
  //   try {
  //     final response = await _apiService.verifyPayment(razorpayOrderId);
  //     // Handle successful verification
  //     print('Payment verified successfully: $response');
  //   } catch (e) {
  //     // Handle error
  //     print('Error verifying payment: $e');
  //   }
  // }

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
    double totalPrice = 0;
    double depositAmount = 0;
    double platformFee = 0;

    if (booking != null) {
      totalPrice = double.parse(booking!.total_price);
      depositAmount = double.parse(booking!.item.depositAmount);
      platformFee = 0.1 * totalPrice; // 10% platform fee
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(elevation: 0, backgroundColor: Colors.white),
      ),
      body: Stack(
        children: [
          SafeArea(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                          Image.network(
                                            "$baseUrl${booking!.item.image}",
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.broken_image,
                                                      color: Colors.grey,
                                                      size: 40,
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

                                    buildSummaryRow(
                                      'Platform Fee',
                                      '₹ ${(0.1 * totalPrice).toStringAsFixed(2)}',
                                    ),
                                    const Divider(
                                      height: 32,
                                      color: Color(0xFFEEEEEE),
                                    ),

                                    // Total amount
                                    buildTotalRow(
                                      'Total Amount',
                                      '₹ ${totalPrice + depositAmount + platformFee}',
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

                                    const SizedBox(height: 24),

                                    // Confirm button
                                    ElevatedButton(
                                      onPressed: () {
                                        createOrder(); // Call createOrder on press
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF26C6B7,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
          if (isLoading) const PacmanLoadingIndicator(),
        ],
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
