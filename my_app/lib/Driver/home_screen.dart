import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_student_to_driver_screen.dart';
import 'route_list_screen.dart';
import 'driver_profile_screen.dart'; // newly added import
import 'package:flutter/services.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents Flutter from automatically adding a back button
        title: const Text('Driver Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverProfileScreen()));
              } else if (value == 'logout') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('uid');
                await prefs.remove('role');
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/Driverlogin', (route) => false);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildModeCard(
              context,
              title: "Pickup Mode",
              description: "Start morning route to school",
              icon: Icons.wb_sunny,
              color: Colors.orangeAccent,
              isPickup: true,
            ),
            const SizedBox(height: 20),
            _buildModeCard(
              context,
              title: "Dropoff Mode",
              description: "Start afternoon route to home",
              icon: Icons.nights_stay,
              color: Colors.indigoAccent,
              isPickup: false,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentToDriverScreen()));
        },
        backgroundColor: const Color(0xFF00C2E0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Link Student', style: TextStyle(color: Colors.white)),
      ),
      ),
    );
  }

  Widget _buildModeCard(BuildContext context, {required String title, required String description, required IconData icon, required Color color, required bool isPickup}) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RouteListScreen(isPickup: isPickup)));
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color, radius: 30, child: Icon(icon, color: Colors.white, size: 30)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 5),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}