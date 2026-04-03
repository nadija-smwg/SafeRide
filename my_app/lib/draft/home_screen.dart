// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Dashboard',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF00C2E0), // Cyan theme color
//         centerTitle: true,
//         automaticallyImplyLeading: false, // Hides the back button
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             onPressed: () {
//               // Logs the user out and sends them back to the Welcome screen
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 '/PassengerWelcome',
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image.asset(
//             //   'assets/images/mahi.png',
//             //   height: 250, // Set height similar to the previous icon size
//             //   width: 350, // Optional: keep it square
//             //   fit: BoxFit
//             //       .contain, // Ensures the image scales correctly within the box
//             // ),
//             SizedBox(height: 20),
//             Text(
//               'Welcome to SafeRide!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'You have successfully logged in.',
//               style: TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
