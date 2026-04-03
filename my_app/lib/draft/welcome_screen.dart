// import 'package:flutter/material.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: Container(
//                     width: double.infinity,
//                     color: const Color(0xFFE8F4F8), // Light sky blue background
//                     child: Center(
//                       // Put your image asset here like we discussed!
//                       child: Image.asset(
//                         'assets/images/bus_illustration.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(24.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const Text(
//                           'Welcome To\nSAFERIDE',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF00C2E0),
//                           ),
//                         ),
//                         const SizedBox(height: 10),

//                         // Connected Button Block
//                         Container(
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF00C2E0),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             children: [
//                               TextButton(
//                                 onPressed: () => Navigator.pushNamed(
//                                   context,
//                                   '/Passengerlogin',
//                                 ),
//                                 style: TextButton.styleFrom(
//                                   minimumSize: const Size(double.infinity, 50),
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 child: const Text('Login'),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0,
//                                 ),
//                                 child: LayoutBuilder(
//                                   builder: (context, constraints) {
//                                     return Flex(
//                                       direction: Axis.horizontal,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: List.generate(
//                                         (constraints.constrainWidth() / 5)
//                                             .floor(),
//                                         (index) => const SizedBox(
//                                           width: 2,
//                                           height: 1,
//                                           child: DecoratedBox(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white54,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               TextButton(
//                                 onPressed: () => Navigator.pushNamed(
//                                   context,
//                                   '/Passengerregister',
//                                 ),
//                                 style: TextButton.styleFrom(
//                                   minimumSize: const Size(double.infinity, 50),
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 child: const Text('Register'),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const Text(
//                           'Protect your Child!',
//                           style: TextStyle(color: Color(0xFF00C2E0)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // LAYER 2: The Floating Back Button
//             Positioned(
//               top: 8, // Adjust this number to move it up or down
//               left: 8, // Adjust this number to move it left or right
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.black,
//                   size: 20,
//                 ),
//                 onPressed: () => Navigator.pushNamed(context, '/'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
