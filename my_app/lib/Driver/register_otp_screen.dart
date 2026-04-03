import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Added Firebase import

// 2. Upgraded to StatefulWidget to handle loading states
class RegisterDriverOtpVerificationScreen extends StatefulWidget {
  const RegisterDriverOtpVerificationScreen({super.key});

  @override
  State<RegisterDriverOtpVerificationScreen> createState() =>
      _RegisterDriverOtpVerificationScreenState();
}

class _RegisterDriverOtpVerificationScreenState
    extends State<RegisterDriverOtpVerificationScreen> {
  String currentText = "";
  bool isLoading = false;

  // 3. The Firebase OTP Verification Function
  Future<void> verifyOTP(String verificationId) async {
    // Make sure they typed all 6 digits
    if (currentText.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the full 6-digit code.")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Start spinner
    });

    try {
      // Create the credential using the ID from the previous screen and the code they typed
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: currentText,
      );

      // Sign the user in!
      await FirebaseAuth.instance.signInWithCredential(credential);

      print("Success! Phone verified and user logged in.");

      // Navigate directly to the Dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/Driverhome');
      }
    } on FirebaseAuthException catch (e) {
      // Handle wrong codes
      String errorMessage = "Invalid OTP code. Please try again.";
      if (e.code == 'invalid-verification-code') {
        errorMessage = "The code you entered is incorrect.";
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
  Widget build(BuildContext context) {
    // 4. This magically catches the verification ID we will pass from the Register screen!
    final String verificationId =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';

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
                'OTP Verification',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                // Updated text to mention phone number!
                'Enter the 6-digit verification code we just sent to your phone number.',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),

              // OTP Input Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6, // Firebase SMS codes are ALWAYS 6 digits!
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50, // Slightly smaller to fit 6 boxes
                    fieldWidth: 45,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: const Color(0xFF00C2E0),
                    inactiveColor: Colors.grey.shade300,
                    selectedColor: const Color(0xFF00C2E0),
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    // Automatically trigger verification when they type the last digit!
                    verifyOTP(verificationId);
                  },
                  onChanged: (value) {
                    setState(() {
                      currentText = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => verifyOTP(verificationId),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Verify'),
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive code? ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Quick way to let them go back and try their number again
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Going back to retry..."),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Resend',
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
