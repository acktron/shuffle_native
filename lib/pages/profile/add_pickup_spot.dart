import 'package:flutter/material.dart';
import 'package:shuffle_native/models/address.dart';
import 'package:shuffle_native/pages/profile/pickup_spots.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widget/inputs/text_input.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class AddPickupSpot extends StatefulWidget {
  final Address? pickupSpot;

  const AddPickupSpot({super.key, this.pickupSpot});

  @override
  State<AddPickupSpot> createState() => _AddPickupSpotState();
}

class _AddPickupSpotState extends State<AddPickupSpot> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  bool isDefault = false;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    countryController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.pickupSpot != null) {
      // Populate controllers with the pickup spot data for editing
      fullNameController.text = widget.pickupSpot!.fullName;
      phoneNumberController.text = widget.pickupSpot!.phoneNumber;
      streetController.text = widget.pickupSpot!.streetAddress;
      cityController.text = widget.pickupSpot!.city;
      stateController.text = widget.pickupSpot!.state;
      pincodeController.text = widget.pickupSpot!.postalCode;
      countryController.text = widget.pickupSpot!.country;
      isDefault = widget.pickupSpot!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            AppLogo(height: 28),
            const SizedBox(width: 8),
            const Text(
              'Shuffle',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5, // Improved readability
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              widget.pickupSpot == null ? 'Add New Pickup Spot' : 'Edit Pickup Spot', // Updated text
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            TextInput(
              labelText: 'Full Name',
              controller: fullNameController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'Phone Number',
              controller: phoneNumberController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'Street Address',
              controller: streetController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'City',
              controller: cityController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'State',
              controller: stateController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'Pincode',
              controller: pincodeController,
            ),
            const SizedBox(height: 16),
            TextInput(
              labelText: 'Country',
              controller: countryController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Set as default address',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final pickupSpot = Address( // Renamed variable
                    id: widget.pickupSpot?.id, // Renamed from address
                    fullName: fullNameController.text,
                    phoneNumber: phoneNumberController.text,
                    streetAddress: streetController.text,
                    city: cityController.text,
                    state: stateController.text,
                    postalCode: pincodeController.text,
                    country: countryController.text,
                    isDefault: isDefault,
                  );
                  final success = widget.pickupSpot == null
                      ? await _apiService.addAddress(pickupSpot) // Renamed from address
                      : await _apiService.updateAddress(pickupSpot);

                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPickupSpots(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to save pickup spot. Please try again.'), // Updated text
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Slightly larger radius
                  ),
                  elevation: 2, // Add subtle shadow for depth
                ),
                child: Text(
                  widget.pickupSpot == null ? 'Save Pickup Spot' : 'Update Pickup Spot', // Updated text
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Slightly larger font for button text
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



