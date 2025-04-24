import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/HomePage.dart';
import 'package:shuffle_native/SignInPage.dart';
import 'package:shuffle_native/SignUpPage.dart';
import 'package:shuffle_native/product_page.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/services/api_client.dart';
import 'package:shuffle_native/uploadpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init(); // Initialize Dio client and interceptors

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return MaterialApp(
      title: 'Shuffle',
      debugShowCheckedModeBanner: false,
      home: authProvider.isLoggedIn ? Homepage() : WelcomePage(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => Homepage(),
        '/welcome': (context) => WelcomePage(),
        '/homepage': (context) => Homepage(),
        '/uploadpage': (context) => UploadItemPage(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top content inside Expanded to avoid overflow
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('assesets/images/MainLogo.png', height: 120),
                    const SizedBox(height: 0),
                    const Text(
                      'Shuffle',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'Rent anything from people near you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 55),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21C7A7),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Terms of Service
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: const [
                    Text(
                      'By continuing, you agree to our',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF21C7A7),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
