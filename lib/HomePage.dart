import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/main.dart';
import 'package:shuffle_native/providers/auth_provider.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF21C7A7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text("Logout"),
          onPressed: () {
            // Call the logout method from the AuthProvider
            Provider.of<AuthProvider>(context, listen: false).logout();

            // Navigate back to the SignInPage
            Navigator.pushReplacementNamed(context, '/welcome');
          },
        ),
      ),
    );
  }
}
