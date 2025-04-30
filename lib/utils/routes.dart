import 'package:flutter/material.dart';
import 'package:shuffle_native/pages/auth/signin.dart';
import 'package:shuffle_native/pages/auth/signup.dart';
import 'package:shuffle_native/pages/auth/change_password.dart';
import 'package:shuffle_native/pages/rental/rest_request.dart';
import 'package:shuffle_native/pages/rental/my_rentals.dart';
import 'package:shuffle_native/pages/home.dart';
import 'package:shuffle_native/pages/auth/otp.dart';
import 'package:shuffle_native/pages/auth/new_pass.dart';
import 'package:shuffle_native/pages/contact_us.dart';
import 'package:shuffle_native/pages/welcome.dart';
import 'package:shuffle_native/pages/profile/add_pickup_spot.dart';
import 'package:shuffle_native/pages/rental/upload_item.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/signin': (_) => SignInPage(),
  '/signup': (_) => SignUpPage(),
  '/welcome': (_) => const WelcomePage(),
  '/uploadpage': (_) => const UploadItemPage(),
  '/change-password': (_) => const ChangePasswordPage(),
  '/requestpage': (_) => RentRequestsPage(),
  '/myrentalspage': (_) => MyRentalsPage(),
  '/homepage': (_) => const Homepage(),
  '/otppage': (_) => const OtpPage(),
  '/newpass': (_) => const NewPass(),
  '/contactus': (_) => ContactUsPage(),
  '/myaddress': (_) => AddPickupSpot(),
};
