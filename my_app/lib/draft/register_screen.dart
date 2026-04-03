// import 'package:flutter/material.dart';
// import '../widgets/custom_widgets.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.black,
//             size: 20,
//           ),
//           onPressed: () =>
//               Navigator.pop(context), // Goes back to the previous screen
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               const Text(
//                 'Hello! Register to get\nstarted',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00C2E0),
//                   height: 1.3,
//                 ),
//               ),
//               const SizedBox(height: 40),

//               // Input Fields
//               const CustomTextField(hintText: 'Username'),
//               const CustomTextField(hintText: 'Email'),
//               const CustomTextField(hintText: 'Password', isPassword: true),
//               const CustomTextField(
//                 hintText: 'Confirm password',
//                 isPassword: true,
//               ),

//               const SizedBox(height: 20),

//               // Register Button
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/Registerotp');
//                 },
//                 child: const Text('Register'),
//               ),
//               const SizedBox(height: 40),

//               // Divider
//               const Row(
//                 children: [
//                   Expanded(child: Divider(color: Colors.grey)),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       'Or Register with',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   Expanded(child: Divider(color: Colors.grey)),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // Social Login
//               const SocialLoginRow(),

//               const SizedBox(height: 40),

//               // Login Redirection
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account? ",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     GestureDetector(
//                       onTap: () =>
//                           Navigator.pushNamed(context, '/Passengerlogin'),
//                       child: const Text(
//                         'Login Now',
//                         style: TextStyle(
//                           color: Color(0xFF00C2E0),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
