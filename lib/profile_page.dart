import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const tealColor = Color(0xFF00C6A2);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(
                    'assesets/images/MainLogo.png',
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Shuffle",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Avatar & Name
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 48,
              backgroundColor: tealColor,
              child: Icon(Icons.person, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Rehman Bhaijan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {},
              child: const Text("Edit Profile", style: TextStyle(decoration: TextDecoration.underline)),
            ),
            const SizedBox(height: 20),

            // List Tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildTile(Icons.image_outlined, "My Rentals", tealColor),
                  _buildTile(Icons.check_circle_outline, "Rent Request", tealColor),
                  _buildTile(Icons.location_on_outlined, "My Address", tealColor),
                  const SizedBox(height: 16),
                  _buildTile(Icons.lock_outline, "Change Password", tealColor),
                  _buildTile(Icons.support_agent, "Contact Us", tealColor),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(color: Colors.black12),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          // TODO: Navigate to respective screens
        },
      ),
    );
  }
}
