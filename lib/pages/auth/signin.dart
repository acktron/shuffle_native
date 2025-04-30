import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/app.dart';
import 'package:shuffle_native/pages/auth/forgot_password.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/widgets/buttons/primary_button.dart';
import 'package:shuffle_native/widgets/dialogs/alert_dialog.dart';
import 'package:shuffle_native/widgets/indicators/pacman_loading_indicator.dart';
import 'package:shuffle_native/widgets/inputs/email_input.dart';
import 'package:shuffle_native/widgets/inputs/password_input.dart';
import 'package:shuffle_native/widgets/logos/app_logo.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: "431947796542-v5n1pf7srtpfifdqsvf8jvjia32c3ejg.apps.googleusercontent.com"
  );
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
        builder:
            (BuildContext context) => CustomAlertDialog(
              icon: Icons.error,
              iconColor: Colors.green,
              title: 'Login Failed',
              message: 'Invalid email or password.',
              buttonText: 'Try Again',
              onButtonPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
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
                  PrimaryButton(
                    text: "Sign in with Google",
                    onPressed: () async {
                      // Handle Google Sign-In
                      // logout if already signed in
                      // try {
                      //   await _googleSignIn.signOut();
                      // } catch (error) {
                      //   // Handle error
                      //   showDialog(
                      //     context: context,
                      //     builder:
                      //         (context) => CustomAlertDialog(
                      //           icon: Icons.error,
                      //           iconColor: Colors.red,
                      //           title: 'Google Sign-Out Failed',
                      //           message: 'Please try again later.',
                      //           buttonText: 'OK',
                      //           onButtonPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //         ),
                      //   );
                      // }
                      try {
                        setState(() {
                          isLoading = true;
                        });

                        _googleSignIn
                            .signIn()
                            .then((result) {
                              result?.authentication
                                  .then((googleKey) {
                                    // Handle the Google Sign-In result
                                    print('Google Sign-In successful');
                                    print("Google User: ${result.displayName}");
                                    print("Google ID Token: ${googleKey.idToken}");
                                    print("Google Access Token: ${googleKey.accessToken}");

                                  })
                                  .catchError((err) {
                                    print('inner error');
                                  });
                            })
                            .catchError((err) {
                              print('error occured $err');
                            });

                        // final GoogleSignInAccount? googleUser =
                        //     await _googleSignIn.signIn();

                        // if (googleUser == null) {
                        //   // User canceled the sign-in
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        //   return;
                        // }

                        // print("Google User: ${googleUser}");

                        // final GoogleSignInAuthentication? googleAuth =
                        //     await googleUser?.authentication;

                        // final idToken = googleAuth?.idToken;
                        // if (idToken == null) {
                        //   // Handle error
                        //   // return;
                        // }

                        // print("Google ID Token: $idToken");

                        setState(() {
                          isLoading = false;
                        });
                      } catch (error) {
                        print("Error signing in with Google: $error");
                        // Handle error
                        showDialog(
                          context: context,
                          builder:
                              (context) => CustomAlertDialog(
                                icon: Icons.error,
                                iconColor: Colors.red,
                                title: 'Google Sign-In Failed',
                                message: 'Please try again later.',
                                buttonText: 'OK',
                                onButtonPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),
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
