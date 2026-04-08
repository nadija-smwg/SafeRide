import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_student_to_driver_screen.dart';
import 'route_list_screen.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents Flutter from automatically adding a back button
        title: const Text('Driver Dashboard', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('uid');
              prefs.remove('role');
              Navigator.pushReplacementNamed(context, '/Driverlogin');
            },
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