import "package:flutter/material.dart";
import "package:shuffle_native/pages/auth/signin.dart";
import "package:shuffle_native/pages/auth/signup.dart";
import "package:shuffle_native/widget/buttons/primary_button.dart";
import "package:shuffle_native/widget/logos/app_logo.dart";

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
              Expanded(child: _buildTopContent(context)),
              _buildTermsOfService(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        AppLogo(height: 120),
        const Text(
          'Shuffle',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
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
        PrimaryButton(
          text: "Get Started",
          onPressed: () => _navigateToSignUpPage(context),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => _navigateToSignInPage(context),
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
    );
  }

  Widget _buildTermsOfService() {
    return Padding(
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
    );
  }

  PageRouteBuilder _createPageRoute(Widget page, {Offset begin = const Offset(1.0, 0.0)}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _navigateToSignUpPage(BuildContext context) {
    Navigator.push(context, _createPageRoute(const SignUpPage(), begin: const Offset(1.0, 0.0))); // Slide in from the right
  }

  void _navigateToSignInPage(BuildContext context) {
    Navigator.push(context, _createPageRoute(SignInPage(), begin: const Offset(-1.0, 0.0))); // Slide in from the left
  }
}
