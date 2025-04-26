import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/app.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init(); // Initialize Dio client and interceptors

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider()..checkLoginStatus(),
      child: const App(),
    ),
  );
}