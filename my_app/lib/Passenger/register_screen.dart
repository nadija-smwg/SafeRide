import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- SECTION 1: Parent Details ---
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // --- SECTION 2: Confirmation Details ---
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  // Header Style Helper
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

  Future<void> registerParent() async {
    // 1. Validation
    if (emergencyContactController.text.isEmpty || 
        addressController.text.isEmpty || 
        emailController.text.isEmpty || 
        usernameController.text.isEmpty || 
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details for your child's safety.")),
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
      // 2. Create Auth User
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 3. SEND THE VERIFICATION LINK
      await userCredential.user!.sendEmailVerification();

      // 4. Save to 'parents' collection with DEFAULT ROLE
      await FirebaseFirestore.instance.collection('parents').doc(userCredential.user!.uid).set({
        'emergencyContact': emergencyContactController.text.trim(),
        'homeAddress': addressController.text.trim(),
        'email': emailController.text.trim(),
        'username': usernameController.text.trim(),
        'role': 'Parent', // Hardcoded default role
        'uid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() => isLoading = false);
        
        // 5. Success Dialog explaining the verification email
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("Verify Your Email", style: TextStyle(color: Color(0xFF00C2E0))),
            content: Text("Safety first! A verification link has been sent to ${emailController.text.trim()}.\n\nPlease click the link in your inbox to verify your account."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                  Navigator.pushNamed(context, '/Passengerlogin'); 
                },
                child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    }
  }

  @override
  void dispose() {
    emergencyContactController.dispose();
    addressController.dispose();
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
          physics: const BouncingScrollPhysics(), // High-quality bounce effect
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Parent Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C2E0),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // --- SECTION 1 ---
              _sectionHeader("Parent Details"),
              CustomTextField(hintText: 'Phone Number', controller: emergencyContactController),
              CustomTextField(hintText: 'Home Address', controller: addressController),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(thickness: 1),
              ),

              // --- SECTION 2 ---
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

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2E0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : registerParent,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/Passengerlogin'),
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}