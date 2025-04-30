import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assesets/images/MainLogo.png', height: height);
  }
}
