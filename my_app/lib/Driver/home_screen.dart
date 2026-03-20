import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Map & Location Imports
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart'; // ADDED: Geolocator for permissions

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // Variables to hold the state of our toggles and checkboxes
  bool isDriverMode = true;
  bool isAmalPresent = true;
  bool isSamanPresent = false;

  // ADDED: Request location permission as soon as the screen opens
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  // Reusable function to build the thick grey dividers from your mockup
  Widget _buildDivider() {
    return Container(height: 1.5, color: Colors.grey.shade300);
  }

  // Reusable function to build the rows (Driver Mode, Attendance, Schedule, etc.)
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
              fontStyle:
                  FontStyle.italic, // Matches the slanted text in your mockup
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
        // Title row with name and profile picture
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Driver Sanath',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 10),
            // Profile picture that logs out when tapped!
            GestureDetector(
              onTap: () async {
                // 1. Wait for Firebase to sign out
                await FirebaseAuth.instance.signOut();

                // 2. Safely check if the screen is still active
                if (!context.mounted) return;

                // 3. Navigate back to Welcome screen
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/Driverwelcome',
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
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Driver Mode
          _buildListRow(
            title: 'Driver Mode',
            trailing: Switch(
              value: isDriverMode,
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.greenAccent.shade400,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade400,
              onChanged: (val) {
                setState(() => isDriverMode = val);
              },
            ),
          ),
          _buildDivider(),

          // 2. Attendance
          _buildListRow(
            title: 'Attendance',
            trailing: const Icon(
              Icons.qr_code_scanner,
              size: 28,
              color: Colors.black87,
            ),
          ),
          _buildDivider(),

          // 3. Students Header
          _buildListRow(
            title: 'Students',
            trailing: Row(
              children: [
                Container(
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
                const SizedBox(width: 12),
                const Icon(Icons.add_circle, size: 26, color: Colors.black),
              ],
            ),
          ),

          // 4. Student Checkboxes
          CheckboxListTile(
            title: const Text(
              'Amal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            value: isAmalPresent,
            onChanged: (val) => setState(() => isAmalPresent = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.grey.shade800,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            dense: true,
          ),
          CheckboxListTile(
            title: const Text(
              'Saman',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            value: isSamanPresent,
            onChanged: (val) => setState(() => isSamanPresent = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.grey.shade800,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            dense: true,
          ),
          _buildDivider(),

          // 5. Schedule
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

          // 6. Map Header
          _buildListRow(
            title: 'Map',
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

          // 7. Live Map Area
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(6.9271, 79.8612), // Default to Colombo
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.codex.saferide',
                  retinaMode:
                      true, // IMPORTANT: This forces high-resolution images to stop the blurriness!
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [
                        // Example coordinates drawing a short line in Colombo
                        const LatLng(6.9271, 79.8612),
                        const LatLng(6.9285, 79.8625),
                        const LatLng(6.9300, 79.8640),
                      ],
                      color: Colors.blueAccent, // That classic Google Maps blue
                      strokeWidth: 6.0, // Make it thick!
                      strokeCap:
                          StrokeCap.round, // Rounds the edges of the line
                    ),
                  ],
                ),
                // UPDATED: School Bus Live Location Marker
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.always,
                  alignDirectionOnUpdate:
                      AlignOnUpdate.always, // Rotates bus based on movement
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      color: Colors.amber, // Classic school bus yellow
                      child: Icon(
                        Icons.directions_bus, // Bus icon instead of an arrow
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
              ],
            ),
          ),

          // 8. Bottom Footer Text
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