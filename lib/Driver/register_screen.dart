import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../services/auth_service.dart'; 

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  // --- SECTION 1: Personal Details ---
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();

  // --- SECTION 2: Confirmation Details ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  
  final AuthService _authService = AuthService();

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // --- UPDATED REGISTER FUNCTION FOR SPRING BOOT ---
  Future<void> registerDriver() async {
    // 1. Validations
    if (fullNameController.text.isEmpty || 
        phoneController.text.isEmpty || 
        licenseController.text.isEmpty || 
        vehicleController.text.isEmpty || 
        emailController.text.isEmpty || 
        usernameController.text.isEmpty || 
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details to register.")),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 2. Send ALL Data to Spring Boot Backend
      // This matches the updated registerUser parameters in your AuthService
      bool success = await _authService.registerUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: "DRIVER", 
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        licenseNumber: licenseController.text.trim(),
        vehicleNumber: vehicleController.text.trim(),
        username: usernameController.text.trim(),
      );

      if (mounted) {
        setState(() => isLoading = false);
        
        if (success) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Success!", style: TextStyle(color: Color(0xFF00C2E0))),
              content: const Text("Account created successfully on the SafeRide server! You can now log in."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pushNamed(context, '/Driverlogin'); 
                  },
                  child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration failed. Please check your details or server connection.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Connection Error: Could not connect to the server.")),
        );
      }
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    licenseController.dispose();
    vehicleController.dispose();
    emailController.dispose();
    usernameController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Registration',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              _sectionHeader("Personal Details"),
              CustomTextField(hintText: 'Full Name', controller: fullNameController),
              CustomTextField(hintText: 'Phone Number', controller: phoneController),
              CustomTextField(hintText: 'License Number', controller: licenseController),
              CustomTextField(hintText: 'Vehicle Number', controller: vehicleController),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1),
              ),

              _sectionHeader("Confirmation Details"),
              CustomTextField(hintText: 'Email', controller: emailController),
              CustomTextField(hintText: 'Username', controller: usernameController),
              CustomTextField(
                hintText: 'Password', 
                isPassword: true, 
                controller: passwordController
              ),
              CustomTextField(
                hintText: 'Confirm password', 
                isPassword: true, 
                controller: confirmPasswordController
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2E0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : registerDriver,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a Driver? ", style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/Driverlogin'),
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                        color: Color(0xFF00C2E0), 
                        fontWeight: FontWeight.bold
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
    );
  }
}