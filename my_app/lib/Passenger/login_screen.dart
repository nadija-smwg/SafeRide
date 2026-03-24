import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'package:my_app/Passenger/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart'; // For Spring Boot backend calls

// Changed from StatelessWidget to StatefulWidget to support Firebase Auth
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to grab the text from the UI
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable to control the loading spinner
  bool isLoading = false;

  // The Firebase Login Function
  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Call Firebase to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Notify the Spring Boot backend with the Firebase ID Token
      await ApiService.notifyBackend();

      // If successful, navigate to Passenger home screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      // Show an error pop-up if the password is wrong or email doesn't exist
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      print(e.toString());
    } finally {
      // Stop the loading spinner
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Dispose of controllers when done to save memory
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome back! Glad\nto see you, Again!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),

              // Connected controllers to text fields
              CustomTextField(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              CustomTextField(
                hintText: 'Enter your password',
                isPassword: true,
                controller: passwordController,
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/Passengerforgot_password');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Connected button to the login function & added a spinner
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : loginUser,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 40),

              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or Login with',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),

              const SocialLoginRow(),

              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/Passengerregister'),
                    child: const Text(
                      'Register Now',
                      style: TextStyle(
                        color: Color(0xFF00C2E0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
