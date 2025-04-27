import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/widget/buttons/primary_button.dart';
import 'package:shuffle_native/widget/indicators/pacman_loading_indicator.dart';
import 'package:shuffle_native/widget/inputs/email_input.dart';
import 'package:shuffle_native/widget/inputs/password_input.dart';
import 'package:shuffle_native/widget/inputs/text_input.dart';
import 'package:shuffle_native/widget/dialogs/alert_dialog.dart';
import 'package:shuffle_native/widget/logos/app_logo.dart';

class ShuffleApp extends StatelessWidget {
  const ShuffleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpPage(), debugShowCheckedModeBanner: false);
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() async {
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All fields are required')),
        );
      }
      return;
    }

    if (password != confirmPassword) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).register(name, email, password);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (BuildContext context) => CustomAlertDialog(
              icon: Icons.error,
              iconColor: Colors.green,
              title: 'Registration Failed',
              message: 'Unable to create an account. Please try again.',
              buttonText: 'Retry',
              onButtonPressed: () {
                Navigator.of(context).pop();
              },
            ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ShuffleApp();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              // Added SingleChildScrollView
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  AppLogo(height: 60),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Create account',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  TextInput(controller: _nameController, labelText: "Name"),
                  const SizedBox(height: 16),

                  EmailField(controller: _emailController),
                  const SizedBox(height: 16),

                  PasswordField(controller: _passwordController),
                  const SizedBox(height: 16),

                  PasswordField(
                    controller: _confirmPasswordController,
                    labelText: "Confirm Password",
                  ),
                  const SizedBox(height: 24),

                  PrimaryButton(text: "Sign up", onPressed: () => _register()),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: const Text(
                          'Sign in',
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

          if (_isLoading) PacmanLoadingIndicator(),
        ],
      ),
    );
  }
}
