// import 'package:flutter/material.dart';
// import '../widgets/custom_widgets.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   const ForgotPasswordScreen({super.key});

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
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               const Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00C2E0),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "Don't worry! It occurs. Please enter the email address linked with your account.",
//                 style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
//               ),
//               const SizedBox(height: 40),

//               const CustomTextField(hintText: 'Enter your email'),

//               const SizedBox(height: 30),

//               ElevatedButton(
//                 onPressed: () => Navigator.pushNamed(context, '/otp'),
//                 child: const Text('Send Code'),
//               ),

//               const Spacer(),

//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Remember Password? ",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     GestureDetector(
//                       onTap: () =>
//                           Navigator.pushNamed(context, '/Passengerlogin'),
//                       child: const Text(
//                         'Login',
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
