import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/pages/auth/change_password.dart';
import 'package:shuffle_native/pages/contact_us.dart';
import 'package:shuffle_native/pages/profile/edit_profile.dart';
import 'package:shuffle_native/pages/profile/pickup_spots.dart';
import 'package:shuffle_native/pages/rental/rented_page.dart';
import 'package:shuffle_native/pages/rental/rest_request.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/services/api_service.dart';
import 'package:shuffle_native/widgets/buttons/danger_button.dart';
import 'package:shuffle_native/widgets/logos/app_logo.dart';

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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
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
                _buildProfileOption(
                  context,
                  Icons.image,
                  "My Rentals",
                  destinationPage: RentedItemsPage(),
                ),
                _buildProfileOption(
                  context,
                  Icons.check_circle_outline,
                  "Rent Request",
                  destinationPage: const RentRequestsPage(),
                ),
                _buildProfileOption(
                  context,
                  Icons.location_on_outlined,
                  "My Address",
                  destinationPage: const MyPickupSpots(),
                  onPressed:
                      () {}, // No action needed since destinationPage is provided
                ),
                _buildProfileOption(
                  context,
                  Icons.lock_outline,
                  "Change Password",
                  destinationPage: const ChangePasswordPage(),
                  // onPressed: () {
                  //   Navigator.pushNamed(context, '/change-password');
                  // },
                ),
                _buildProfileOption(
                  context,
                  Icons.support_agent,
                  "Contact Us",
                  destinationPage: const ContactUsPage(),
                ),
                const SizedBox(height: 20),
                DangerButton(
                  label: "Logout",
                  onPressed: () async {
                    // Logout logic
                    // Call the login method from AuthProvider
                    final success =
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).logout();
                    if (success) {
                      Navigator.pushNamed(context, '/welcome');
                    }
                  },
                ),
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
    VoidCallback? onPressed,
    Widget? destinationPage, // Optional parameter for navigation
  }) {
    return GestureDetector(
      onTap: () {
        if (destinationPage != null) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => destinationPage,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = Offset(1.0, 0.0); // Slide in from the right
                const end = Offset.zero; // End at the current position
                const curve = Curves.easeInOut;

                var tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(position: offsetAnimation, child: child);
              },
            ),
          );
        } else {
          onPressed!();
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
