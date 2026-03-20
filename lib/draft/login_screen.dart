// import 'package:flutter/material.dart';
// import '../widgets/custom_widgets.dart';
// import 'package:my_app/Passenger/welcome_screen.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//             size: 20,
//           ),
//           onPressed: () {
//   // 1. Check if there is actually a screen behind this one in the history
//             if (Navigator.canPop(context)) {
//               // If yes, safely go back to it
//               Navigator.pop(context);
//             } else {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//               );
  
//             }
//           }
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Welcome back! Glad\nto see you, Again!',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00C2E0),
//                   height: 1.3,
//                 ),
//               ),
//               const SizedBox(height: 40),

//               const CustomTextField(hintText: 'Enter your email'),
//               const CustomTextField(
//                 hintText: 'Enter your password',
//                 isPassword: true,
//               ),

//               Align(
//                 alignment: Alignment.centerRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/Passengerforgot_password');
//                   },
//                   child: const Text(
//                     'Forgot Password?',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               ElevatedButton(
//                 onPressed: () {
//                   // This command replaces the login screen with the home screen
//                   // so the user can't accidentally swipe back to the login page!
//                   Navigator.pushReplacementNamed(context, '/home');
//                 },
//                 child: const Text('Login'),
//               ),
//               const SizedBox(height: 40),

//               const Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.grey)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Or Login with',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: Colors.grey)),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               const SocialLoginRow(),

//               const SizedBox(height: 50),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have an account? ",
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                   GestureDetector(
//                     onTap: () =>
//                         Navigator.pushNamed(context, '/Passengerregister'),
//                     child: const Text(
//                       'Register Now',
//                       style: TextStyle(
//                         color: Color(0xFF00C2E0),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
