import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'package:my_app/Driver/welcome_screen.dart';
import '../services/auth_service.dart';

// 2. Changed from StatelessWidget to StatefulWidget
class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  // 3. Added controllers to grab the text from the UI
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Variable to control the loading spinner
  bool isLoading = false;

  // 4. The Firebase Login Function
  Future<void> loginUser() async {
    setState(() {
      isLoading = true; // Start loading spinner
    });

    try {
      // Use our Spring Boot AuthService
      final authService = AuthService();
      bool success = await authService.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
        "DRIVER",
      );

      if (success) {
        // If successful, navigate to your exact home screen route!
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/Driverhome');
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid email or password.')),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection Error. Please try again.')),
        );
      }
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
            // Keeping your exact back button logic!
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverWelcomeScreen(),
                ),
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

              // 5. Passed the controllers into your custom text fields
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
                    // Kept your exact route
                    Navigator.pushNamed(context, '/Driverforgot_password');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 6. Connected your button to the login function & added a spinner
              SizedBox(
                width:
                    double.infinity, // Ensures button is wide like your inputs
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
                    // Kept your exact route
                    onTap: () =>
                        Navigator.pushNamed(context, '/Driverregister'),
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
