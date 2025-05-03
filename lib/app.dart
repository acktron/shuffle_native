import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/pages/welcome.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/utils/routes.dart';
import 'package:shuffle_native/widgets/main_scaffold.dart';

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      title: 'Shuffle',
      debugShowCheckedModeBanner: false,
      home: authProvider.isLoggedIn ? const MainScaffold() : const WelcomePage(),
      routes: appRoutes,
      navigatorKey: navigatorKey,
    );
  }
}
