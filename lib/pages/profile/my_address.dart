import 'package:flutter/material.dart';
import 'package:shuffle_native/models/address.dart';
import 'package:shuffle_native/widget/cards/address_card.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widget/shimmers/address_card_shirmmer.dart';
import 'package:shuffle_native/pages/profile/add_address.dart';

class MyAddress extends StatefulWidget {
  const MyAddress({super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final ApiService _apiService = ApiService();
  List<Address> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    try {
      final fetchedAddresses =
          await _apiService
              .getAddresses(); // Assume this returns a list of address maps
      setState(() {
        addresses = fetchedAddresses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Address',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: isLoading ? _buildLoadingState() : _buildLoadedState()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onAddAddressPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 3, // Display 3 shimmer cards as placeholders
      itemBuilder: (context, index) => AddressCardShirmmer(),
    );
  }

  Widget _buildLoadedState() {
    return RefreshIndicator(
      onRefresh: _fetchAddresses,
      child: ListView.builder(
        itemCount: addresses.length, // Remove +1 for the button
        itemBuilder: (context, index) {
          final address = addresses[index];
          return null;
          // return MyAddressCard(
          //   street: ,
          //   city: address['city']!,
          //   state: address['state']!,
          //   pincode: address['pincode']!,
          // );
        },
      ),
    );
  }

  void _onAddAddressPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddress()),
    );
  }
}
