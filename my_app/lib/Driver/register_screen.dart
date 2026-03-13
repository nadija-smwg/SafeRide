import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController =
      TextEditingController(); // 1. Added Phone Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  // 2. Updated function to send the SMS instead of creating an email user
  Future<void> sendOtp() async {
    // Quick validation checks
    if (phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your phone number.")),
      );
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    setState(() {
      isLoading = true; // Start loading spinner
    });

    // 3. Tell Firebase to send the text message!
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(), // MUST include country code!
      verificationCompleted: (PhoneAuthCredential credential) {
        // Android sometimes auto-reads the SMS and logs in instantly.
      },
      verificationFailed: (FirebaseAuthException e) {
        // If the number is formatted wrong or Firebase blocks it
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                e.message ?? "Verification failed. Please try again.",
              ),
            ),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        // 4. Success! The SMS is flying through the air. Navigate to OTP screen.
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushNamed(
            context,
            '/RegisterDriverotp',
            arguments: verificationId, // Pass the secret ID to the next screen!
          );
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Hello! Register to get\nstarted',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),

              CustomTextField(
                hintText: 'Username',
                controller: usernameController,
              ),

              // 5. Added the Phone Number UI Field
              CustomTextField(
                hintText: 'Phone Number (e.g. +94771234567)',
                controller: phoneController,
              ),

              CustomTextField(hintText: 'Email', controller: emailController),
              CustomTextField(
                hintText: 'Password',
                isPassword: true,
                controller: passwordController,
              ),
              CustomTextField(
                hintText: 'Confirm password',
                isPassword: true,
                controller: confirmPasswordController,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : sendOtp, // Connects to the new SMS function
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Register & Send OTP'),
                ),
              ),

              const SizedBox(height: 40),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or Register with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),

              const SocialLoginRow(),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/Driverlogin'),
                      child: const Text(
                        'Login Now',
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
