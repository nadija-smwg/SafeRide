import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';

class DriverCreateNewPasswordScreen extends StatelessWidget {
  const DriverCreateNewPasswordScreen({super.key});

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
                'Create new password',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your new password must be unique from those\npreviously used.',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),

              const CustomTextField(hintText: 'New Password', isPassword: true),
              const CustomTextField(
                hintText: 'Confirm Password',
                isPassword: true,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  // Handle password reset completion
                  // Usually route to a success screen or back to Login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/Driverlogin',
                    (route) => false,
                  );
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
