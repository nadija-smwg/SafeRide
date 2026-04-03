// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class RegisterOtpVerificationScreen extends StatelessWidget {
//   const RegisterOtpVerificationScreen({super.key});

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
//                 'OTP Verification',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00C2E0),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Enter the verification code we just sent on your\nemail address.',
//                 style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
//               ),
//               const SizedBox(height: 40),

//               // 4-Digit OTP Input Fields
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: PinCodeTextField(
//                   appContext: context,
//                   length: 4,
//                   obscureText: false,
//                   animationType: AnimationType.fade,
//                   keyboardType: TextInputType.number,
//                   pinTheme: PinTheme(
//                     shape: PinCodeFieldShape.box,
//                     borderRadius: BorderRadius.circular(8),
//                     fieldHeight: 60,
//                     fieldWidth: 55,
//                     // Colors based on your UI
//                     activeFillColor: Colors.white,
//                     inactiveFillColor: Colors.white,
//                     selectedFillColor: Colors.white,
//                     activeColor: const Color(
//                       0xFF00C2E0,
//                     ), // Cyan border when done
//                     inactiveColor:
//                         Colors.grey.shade300, // Light grey border normally
//                     selectedColor: const Color(
//                       0xFF00C2E0,
//                     ), // Cyan border when typing
//                   ),
//                   animationDuration: const Duration(milliseconds: 300),
//                   enableActiveFill: true,
//                   onCompleted: (v) {
//                     // Trigger your verification logic here
//                     print("Completed OTP: $v");
//                   },
//                   onChanged: (value) {
//                     // Handle changes
//                   },
//                 ),
//               ),

//               const SizedBox(height: 30),

//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/Passengerlogin');
//                   // Navigate to "Create new password" screen or Dashboard
//                 },
//                 child: const Text('Verify'),
//               ),

//               const Spacer(), // Pushes the bottom text to the bottom of the screen

//               Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Didn't received code? ",
//                       style: TextStyle(color: Colors.black54),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         // Resend OTP logic
//                       },
//                       child: const Text(
//                         'Resend',
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
