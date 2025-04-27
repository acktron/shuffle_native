import 'package:flutter/material.dart';
import 'package:shuffle_native/utils/constants.dart';
import 'package:shuffle_native/models/booking.dart';
import 'package:shuffle_native/services/api_service.dart';

class RentRequestDetailsPage extends StatefulWidget {
  final Booking booking;
  const RentRequestDetailsPage({super.key, required this.booking});

  @override
  State<RentRequestDetailsPage> createState() => _RentRequestDetailsPageState();
}

class _RentRequestDetailsPageState extends State<RentRequestDetailsPage> {
  final ApiService _apiService = ApiService(); // Initialize ApiService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(height: 20),
            _buildProductDetails(),
            const SizedBox(height: 30),
            _buildRequestInfo(),
            const Spacer(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.teal),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Rent Requests',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: Image.network(
        "${baseUrl}${widget.booking.item.image}", // Replace with your actual image path
        height: 180,
        width: 180,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      children: [
        Center(
          child: Text(
            "${widget.booking.item.name}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Rs ${widget.booking.total_price}/-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RequestInfoItem(
          label: 'Rent Request by:',
          value: '${widget.booking.renter}',
        ),
        RequestInfoItem(label: 'From:', value: '${widget.booking.start_date}'),
        RequestInfoItem(label: 'To:', value: '${widget.booking.end_date}'),
        RequestInfoItem(
          label: 'Total Days:',
          value:
              '${widget.booking.end_date.difference(widget.booking.start_date).inDays + 1}',
        ),
        RequestInfoItem(
          label: 'Status:',
          value: '${widget.booking.status}',
          valueStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Recievers Address:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 5),
        Text(
          'Paramount,Near ABES Engg. College, Crossing Republik, Ghaziabad,454126',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDeclineButton(context)),
        const SizedBox(width: 16),
        Expanded(child: _buildAcceptButton(context)),
      ],
    );
  }

  Widget _buildDeclineButton(BuildContext context) {
    return OutlinedButton(
      onPressed:
      // () => _showDialog(
      //   context,
      //   icon: Icons.cancel,
      //   color: Colors.red,
      //   message: 'Declined!',
      // ),
      () async {
        final success = await _apiService.manageBooking(widget.booking.id, "REJECTED");
        if (success) {
          // Handle error
          _showDialog(
            context,
            icon: Icons.cancel,
            color: Colors.red,
            message: 'Declined!',
          );
          return;
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Decline'),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return ElevatedButton(
      onPressed:
      // () => _showDialog(
      //   context,
      //   icon: Icons.check_circle,
      //   color: Colors.green,
      //   message: 'Approved!',
      // ),
      () async {
        final success = await _apiService.manageBooking(widget.booking.id, "APPROVED");
        if (success) {
          _showDialog(
            context,
            icon: Icons.check_circle,
            color: Colors.green,
            message: 'Approved!',
          );
          return;
        }
        // _showDialog(
        //   context,
        //   icon: Icons.check_circle,
        //   color: Colors.green,
        //   message: 'Approved!',
        // );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Accept'),
    );
  }

  void _showDialog(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(); // Close the dialog
          Navigator.pushReplacementNamed(context, "/requestpage"); // Return to the previous page
        });

        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Helper widget for request information items
class RequestInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const RequestInfoItem({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(value, style: valueStyle ?? const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
