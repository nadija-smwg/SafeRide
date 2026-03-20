import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Added Firebase import

// 2. Converted to StatefulWidget to handle the text field and loading state
class DriverForgotPasswordScreen extends StatefulWidget {
  const DriverForgotPasswordScreen({super.key});

  @override
  State<DriverForgotPasswordScreen> createState() => _DriverForgotPasswordScreenState();
}

class _DriverForgotPasswordScreenState extends State<DriverForgotPasswordScreen> {
  // 3. Controller to grab the email address
  final TextEditingController emailController = TextEditingController();
  
  // Variable for the loading spinner
  bool isLoading = false;

  // 4. The Firebase Password Reset Function
  Future<void> resetPassword() async {
    // Quick check to make sure they actually typed something
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address.")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Start spinner
    });

    try {
      // Tell Firebase to send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      
      if (mounted) {
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset link sent! Check your email.")),
        );
        // Send them back to the login screen to sign in with their new password
        Navigator.pushReplacementNamed(context, '/Driverlogin');
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found for that email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Stop spinner
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Don't worry! It occurs. Please enter the email address linked with your account.",
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),

              // 5. Attached the controller to the CustomTextField
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
              ),

              const SizedBox(height: 30),

              // 6. Hooked up the button to Firebase and added the loading spinner
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Send Reset Link'), // Updated text to reflect reality
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Remember Password? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/Driverlogin'),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF00C2E0),
                          fontWeight: FontWeight.bold,
                        ),
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