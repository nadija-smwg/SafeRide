import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable to hold the state of the toggle switch
  bool isPickUpMode = true;

  // Reusable function to build the thick grey dividers
  Widget _buildDivider() {
    return Container(height: 1.5, color: Colors.grey.shade300);
  }

  // Reusable function to build the menu rows
  Widget _buildListRow({required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C2E0), // Cyan theme color
        elevation: 0,
        // Custom Back Button mimicking your design
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ),
        // Centered Title with the Add Icon
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Colors.black, size: 22),
            SizedBox(width: 8),
            Text(
              'Student Saman',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // Profile picture that logs the user out when tapped
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                // Wait for Firebase to sign out
                await FirebaseAuth.instance.signOut();

                // Safely check if the screen is still active
                if (!context.mounted) return;

                // Ensure this matches your actual Welcome screen route!
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/PassengerWelcome',
                  (route) => false,
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // Generic avatar URL
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Pick up Mode Toggle
          _buildListRow(
            title: 'Pick up Mode',
            trailing: Switch(
              value: isPickUpMode,
              activeThumbColor: Colors.white, // FIX: Updated from activeColor
              activeTrackColor: Colors.greenAccent.shade400,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade400,
              onChanged: (val) {
                setState(() => isPickUpMode = val);
              },
            ),
          ),
          _buildDivider(),

          // 2. My QR Code Header
          _buildListRow(
            title: 'My QR code',
            trailing: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Colors.black87,
              ),
            ),
          ),

          // 3. Large QR Code Icon Placeholder
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Icon(
              Icons.qr_code_2, // Built-in Flutter QR icon
              size: 180,
              color: Colors.black87,
            ),
          ),
          _buildDivider(),

          // 4. Schedule Row
          _buildListRow(
            title: 'Schedule',
            trailing: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.black87,
              ),
            ),
          ),
          _buildDivider(),

          // 5. Location of the School Bus Row
          _buildListRow(
            title: 'Location of the School Bus',
            trailing: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Colors.black87,
              ),
            ),
          ),

          // 6. Map Placeholder (Fills the rest of the screen)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus,
                    size: 60,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Live Bus Tracking Map\n(To be implemented)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 7. Bottom Footer Text
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Protect your Child!',
              style: TextStyle(
                color: Color(0xFF00C2E0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
