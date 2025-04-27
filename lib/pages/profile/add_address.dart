import 'package:flutter/material.dart';
import 'package:shuffle_native/widget/inputs/text_input.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  bool isDefault = false;

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ fix yellow overflow
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
            const Text(
              'Add New Address',
              style: TextStyle(
                fontSize: 24, // Slightly larger font for emphasis
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Softer black for better contrast
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
                onPressed: () {
                  // TODO: Save address logic using controllers
                  print({
                    'full_name': fullNameController.text,
                    'phone_number': phoneNumberController.text,
                    'street_address': streetController.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'postal_code': pincodeController.text,
                    'country': countryController.text,
                    'is_default': isDefault,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Slightly larger radius
                  ),
                  elevation: 2, // Add subtle shadow for depth
                ),
                child: const Text(
                  'Save Address',
                  style: TextStyle(
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



