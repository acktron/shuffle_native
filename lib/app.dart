import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shuffle_native/pages/home.dart';
import 'package:shuffle_native/pages/auth/signin.dart';
import 'package:shuffle_native/pages/auth/signup.dart';
import 'package:shuffle_native/pages/auth/change_password.dart';
import 'package:shuffle_native/pages/rental/my_rentals.dart';
import 'package:shuffle_native/pages/auth/new_pass.dart';
import 'package:shuffle_native/pages/auth/otp.dart';
import 'package:shuffle_native/pages/notification.dart';
import 'package:shuffle_native/pages/welcome.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/pages/rental/rented_page.dart';
import 'package:shuffle_native/pages/profile/profile.dart';
import 'package:shuffle_native/pages/rental/rest_request.dart';
import 'package:shuffle_native/services/web_socket_service.dart';
import 'package:shuffle_native/pages/rental/upload_item.dart';
import 'package:shuffle_native/pages/contact_us.dart';
import 'package:shuffle_native/pages/profile/add_address.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness: Brightness.dark, // Dark icons for light background
      ),
    );
  }

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Homepage(),
    const RentedItemsPage(),
    const UploadItemPage(),
    NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Shuffle',
      debugShowCheckedModeBanner: false,
      home: authProvider.isLoggedIn 
          ? Builder(
              builder: (context) => Scaffold(
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _pages,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    if (index == 2) {
                      // Navigate to the upload page
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const UploadItemPage(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0); // Start from bottom
                            const end = Offset.zero; // End at original position
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                      return;
                    }
                    setState(() {
                      _selectedIndex = index;
                      if (index == 3) {
                        WebSocketService.notificationCount.value = 0; // Reset count on Notifications tab
                      }
                    });
                  },
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: const Color(0xFF087272),
                  unselectedItemColor: Colors.grey,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.inventory_2),
                      label: 'Rented',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.add_box),
                      label: 'Upload Item',
                    ),
                    BottomNavigationBarItem(
                      icon: ValueListenableBuilder<int>(
                        valueListenable: WebSocketService.notificationCount,
                        builder: (context, count, child) {
                          return Stack(
                            children: [
                              const Icon(Icons.notifications),
                              if (count > 0)
                                Positioned(
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      '$count',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      label: 'Notifications',
                    ),
                    const BottomNavigationBarItem(
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
        '/requestpage': (context) => RentRequestsPage(),
        '/myrentalspage': (context) => MyRentalsPage(),
        '/homepage': (context) => const Homepage(),
        '/otppage': (context) => const OtpPage(),
        '/newpass': (context) => const NewPass(),
        '/contactus': (context) => ContactUsPage(),
        '/myaddress': (context) => AddAddress(),
      },
    );
  }
}