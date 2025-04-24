import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shuffle_native/models/location.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/services/location_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shuffle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const UploadItemPage(),
    );
  }
}

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({Key? key}) : super(key: key);

  @override
  State<UploadItemPage> createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF087272)),
          onPressed: () {},
        ),
        title: Row(
          children: [
            Image.asset(
              'assesets/images/MainLogo.png', // Replace with the actual path to your image
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Item',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Item Data Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF087272),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Item Data:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Image Upload Section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.image, color: Color(0xFF087272)),
                                    SizedBox(width: 8),
                                    Text(
                                      'Image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                    ),
                                    child:
                                        _imageFile != null
                                            ? ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                8,
                                              ),
                                              child: Image.file(
                                                _imageFile!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                            : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.add_a_photo,
                                                  size: 48,
                                                  color: Color(0xFF087272),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Tap to upload image',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Item Name
                    buildTextFormField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.label,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item name';
                        }
                        return null;
                      },
                    ),

                    // Description
                    buildTextFormField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item description';
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),
                    // Note (Optional)
                    buildTextFormField(
                      controller: _noteController,
                      label: 'Note (Optional)',
                      icon: Icons.description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null; // Optional field, no validation needed
                        }
                        return null;
                      },
                      maxLines: 3,
                    ),

                    // Price Per Day
                    buildTextFormField(
                      controller: _priceController,
                      label: 'Price per day',
                      icon: Icons.attach_money,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price per day';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      prefix: 'Rs ',
                    ),

                    // Deposit Amount
                    buildTextFormField(
                      controller: _depositController,
                      label: 'Deposit amount',
                      icon: Icons.account_balance_wallet,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter deposit amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      prefix: 'Rs ',
                    ),

                    // Upload Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true; // Show loader
                                  });

                                  final locationService = LocationService();
                                  final locationData =
                                      await locationService.getLocation();

                                  final success = await _apiService.listNewItem(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    pricePerDay: _priceController.text,
                                    depositAmount: _depositController.text,
                                    image: _imageFile,
                                    conditionNotes: _noteController.text,
                                    location: Location("Point", [
                                      locationData?.longitude,
                                      locationData?.latitude,
                                    ]),
                                  );

                                  setState(() {
                                    _isLoading = false; // Hide loader
                                  });

                                  if (success) {
                                    Navigator.pushNamed(context, '/homepage');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Failed to upload item'),
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF087272),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Upload',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF087272),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? prefix,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF087272)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $label',
                prefixText: prefix,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF26C6DA),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
              validator: validator,
              maxLines: maxLines,
              keyboardType: keyboardType,
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? const Color(0xFF26C6DA) : Colors.grey),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF26C6DA) : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
