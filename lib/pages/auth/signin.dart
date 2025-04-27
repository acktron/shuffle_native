import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/app.dart';
import 'package:shuffle_native/pages/auth/forgot_password.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/widget/buttons/primary_button.dart';
import 'package:shuffle_native/widget/dialogs/alert_dialog.dart';
import 'package:shuffle_native/widget/indicators/pacman_loading_indicator.dart';
import 'package:shuffle_native/widget/inputs/email_input.dart';
import 'package:shuffle_native/widget/inputs/password_input.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false; // Add a state variable for loading

  void _login() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password are required')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call the login method from AuthProvider
    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(email, password);

    if (!mounted) return; // Ensure context is still valid

    setState(() {
      isLoading = false; // Hide loading indicator
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => App()),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to dismiss
        builder: (BuildContext context) => CustomAlertDialog(
          icon: Icons.error,
          iconColor: Colors.green,
          title: 'Login Failed',
          message: 'Invalid email or password.',
          buttonText: 'Try Again',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  AppLogo(height: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  EmailField(controller: emailController),
                  const SizedBox(height: 16),

                  PasswordField(controller: passwordController),
                  const SizedBox(height: 8),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordUI(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(text: "Sign in", onPressed: _login),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isLoading) PacmanLoadingIndicator(),
        ],
      ),
    );
  }
}
