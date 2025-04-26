import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/rental/my_rentals.dart';
import 'package:shuffle_native/pages/rental/request_page.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widget/buttons/danger_button.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "..."; // Provide a default value
  @override
  void initState() {
    super.initState();
    print("Profile Page");
    _apiService.getName().then((value) {
      setState(() {
        _name = value;
        print("Name: $_name");
      });
    });
  }
  final ApiService _apiService = ApiService(); // Initialize ApiService
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          // 👈 Wrap the whole page in this
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    AppLogo(height: 30),
                    const SizedBox(width: 10),
                    const Text(
                      "Shuffle",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  _name, // Safely use _name
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    // Edit profile logic
                  },
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Your profile options
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyRentalsPage()),
                    );
                  },
                  child: _buildProfileOption(
                    context,
                    Icons.image,
                    "My Rentals",
                    routeTo: "/myrentalspage",
                  ),
                ),

                GestureDetector(
                  child: _buildProfileOption(
                    context,
                    Icons.check_circle_outline,
                    "Rent Request",
                    routeTo: "/requestpage",
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/requestpage');
                  },
                ),
                _buildProfileOption(
                  context,
                  Icons.location_on_outlined,
                  "My Address",
                  routeTo: "/myaddress",
                ),
                _buildProfileOption(
                  context,
                  Icons.lock_outline,
                  "Change Password",
                  routeTo: "/change-password",
                ),
                _buildProfileOption(
                  context,
                  Icons.support_agent, 
                  "Contact Us",
                  routeTo: "/contactus",),
                const SizedBox(height: 20),
                DangerButton(label: "Logout", onPressed: () {
                  // Logout logic
                  Navigator.pushNamed(context, '/welcome');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title, {
    String? routeTo,
  }) {
    return GestureDetector(
      onTap: () {
        if (routeTo != null) {
          Navigator.pushNamed(context, routeTo);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}