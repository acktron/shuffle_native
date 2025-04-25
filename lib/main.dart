import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/HomePage.dart';
import 'package:shuffle_native/SignInPage.dart';
import 'package:shuffle_native/SignUpPage.dart';
import 'package:shuffle_native/change_password.dart';
import 'package:shuffle_native/product_page.dart'; // Ensure this import is correct
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/rented_page.dart';
import 'package:shuffle_native/services/api_client.dart';
import 'package:shuffle_native/uploadpage.dart';
import 'package:shuffle_native/forgot_password.dart';
import 'package:shuffle_native/profile_page.dart'; // Ensure this import is correct
import 'package:shuffle_native/notification_page.dart'; // Updated import

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const RentedItemsPage(),
    const UploadItemPage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    // if (index == 4) {
    //   // Index for "Upload Item"
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder:
    //           (context) =>
    //               const ProfilePage(), // Ensure UploadItemPage is correctly imported
    //     ),
    //   ).then((_) {
    //     // Reset the selected index to avoid issues when returning
    //     setState(() {
    //       _selectedIndex = _selectedIndex; // Keep the current index
    //     });
    //   });
    //   return;
    // }
    // else {
    //   setState(() {
    //     _selectedIndex = index;
    //   });
    // }
    if (index == 2) {
      // Index for "Upload Item"
      Navigator.pushNamed(context, '/uploadpage');
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // if (index == 5) {
    //   // Index for "Upload Item"
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder:
    //           (context) =>
    //               const ProfilePage(), // Ensure UploadItemPage is correctly imported
    //     ),
    //   ).then((_) {
    //     // Reset the selected index to avoid issues when returning
    //     setState(() {
    //       _selectedIndex = _selectedIndex; // Keep the current index
    //     });
    //   });
    // } else {
    //   setState(() {
    //     _selectedIndex = index;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Shuffle',
      debugShowCheckedModeBanner: false,
      home:
          authProvider.isLoggedIn
              ? Builder(
                builder:
                    (context) => Scaffold(
                      body: IndexedStack(
                        index: _selectedIndex,
                        children: _pages,
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                        currentIndex: _selectedIndex,
                        onTap: (index) {
                          if (index == 2) {
                            // Navigate to the upload page
                            Navigator.pushNamed(context, '/uploadpage');
                            return;
                          }
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: const Color(0xFF087272),
                        unselectedItemColor: Colors.grey,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.inventory_2),
                            label: 'Rented',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.add_box),
                            label: 'Upload Item',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.notifications),
                            label: 'Notifications',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    ),
              )
              : const WelcomePage(),
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/welcome': (context) => WelcomePage(),
        '/uploadpage': (context) => const UploadItemPage(),
        '/change-password': (context) => const ChangePasswordPage(),

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

              // Terms of Service
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
