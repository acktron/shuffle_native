import 'package:flutter/material.dart';

class ReceiptPage extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final double rentalCharge;
  final double deposit;
  final double platformFee;
  final double totalAmount;
  final String fromDate;
  final String toDate;
  final String owner;
  final String orderId;

  const ReceiptPage({
    super.key,
    required this.itemName,
    required this.imageUrl,
    required this.rentalCharge,
    required this.deposit,
    required this.platformFee,
    required this.totalAmount,
    required this.fromDate,
    required this.toDate,
    required this.owner,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Receipt'),
        backgroundColor: const Color(0xFF087272),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Order ID: $orderId',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Divider(height: 30),

            // Item summary
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('From $fromDate to $toDate'),
                      Text('Owner: $owner'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildRow('Rental Charge', '₹ ${rentalCharge.toStringAsFixed(2)}'),
            _buildRow('Deposit', '₹ ${deposit.toStringAsFixed(2)}'),
            _buildRow('Platform Fee', '₹ ${platformFee.toStringAsFixed(2)}'),
            const Divider(height: 30),
            _buildRow('Total Paid', '₹ ${totalAmount.toStringAsFixed(2)}', bold: true),
            const SizedBox(height: 30),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087272),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
