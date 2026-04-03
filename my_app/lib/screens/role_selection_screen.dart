import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Placeholder for the illustration
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                color: const Color(0xFFE8F4F8),
                // 👇 Here is your new image widget! 👇
                child: Center(
                  child: Image.asset(
                    'assets/images/bus_illustration.png',
                    fit: BoxFit.contain, // This keeps the image from stretching
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Welcome To\nSAFERIDE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C2E0),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Are you ?',
                        style: TextStyle(color: Color(0xFF00C2E0)),
                      ),
                    ),

                    // Connected Button Block
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C2E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/DriverWelcome'),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Driver'),
                          ),
                          // Dotted line effect
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    (constraints.constrainWidth() / 5).floor(),
                                    (index) => const SizedBox(
                                      width: 2,
                                      height: 1,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/PassengerWelcome'),
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Parent'),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Protect your Child!',
                      style: TextStyle(color: Color(0xFF00C2E0)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
