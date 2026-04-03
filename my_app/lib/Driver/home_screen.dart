import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // For Clipboard
// Map & Location Imports
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // 1. State Variables
  bool isDriverMode = true; // Controls Live Tracking
  bool isStudentsExpanded = true;
  bool isScheduleExpanded = false;

  // Dummy Student Data
  List<Map<String, dynamic>> students = [
    {'name': 'Amal', 'morning': true, 'afternoon': false},
    {'name': 'Saman', 'morning': true, 'afternoon': true},
    {'name': 'Kamal', 'morning': false, 'afternoon': true},
  ];

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

  // Show a popup for the Invitation Link
  void _showInvitePopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invite Student"),
        content: const Text("Copy this link to invite a student to your bus: \nsaferide.app/invite/bus123"),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(const ClipboardData(text: "saferide.app/invite/bus123"));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link copied!")));
            },
            child: const Text("Copy Link"),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1.5, color: Colors.grey.shade300);
  }

  Widget _buildListRow({required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
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
        backgroundColor: const Color(0xFF00C2E0),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Driver Sanath', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // 1. Driver Mode (Controls Live Tracking)
          _buildListRow(
            title: 'Driver Mode',
            trailing: Switch(
              value: isDriverMode,
              activeTrackColor: Colors.greenAccent.shade400,
              onChanged: (val) => setState(() => isDriverMode = val),
            ),
          ),
          _buildDivider(),

          // 2. Attendance (QR Scanner Placeholder)
          InkWell(
            onTap: () {
              // This is where you'd trigger the Camera Scanner
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening QR Scanner...")));
            },
            child: _buildListRow(
              title: 'Attendance',
              trailing: const Icon(Icons.qr_code_scanner, size: 28, color: Colors.black87),
            ),
          ),
          _buildDivider(),

          // 3. Students List
          InkWell(
            onTap: () => setState(() => isStudentsExpanded = !isStudentsExpanded),
            child: _buildListRow(
              title: 'Students',
              trailing: Row(
                children: [
                  Icon(isStudentsExpanded ? Icons.keyboard_arrow_down : Icons.arrow_back_ios_new, size: 16),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _showInvitePopup,
                    icon: const Icon(Icons.add_circle, size: 26, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          if (isStudentsExpanded)
            ...students.map((s) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4.0),
              child: Row(children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(s['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
              ]),
            )).toList(),
          _buildDivider(),

          // 4. Schedule Table
          InkWell(
            onTap: () => setState(() => isScheduleExpanded = !isScheduleExpanded),
            child: _buildListRow(
              title: 'Schedule',
              trailing: Icon(isScheduleExpanded ? Icons.keyboard_arrow_down : Icons.arrow_back_ios_new, size: 16),
            ),
          ),
          if (isScheduleExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                children: [
                  const TableRow(children: [
                    TableCell(child: Center(child: Text('Student', style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Center(child: Text('Morning', style: TextStyle(fontWeight: FontWeight.bold)))),
                    TableCell(child: Center(child: Text('Afternoon', style: TextStyle(fontWeight: FontWeight.bold)))),
                  ]),
                  ...students.map((s) => TableRow(children: [
                    TableCell(child: Center(child: Text(s['name']))),
                    TableCell(child: Icon(s['morning'] ? Icons.check_circle : Icons.cancel, color: s['morning'] ? Colors.green : Colors.red, size: 20)),
                    TableCell(child: Icon(s['afternoon'] ? Icons.check_circle : Icons.cancel, color: s['afternoon'] ? Colors.green : Colors.red, size: 20)),
                  ])).toList(),
                ],
              ),
            ),
          _buildDivider(),

          // 5. Map (Always Visible)
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(6.9271, 79.8612),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                // Live Location Layer - Only "Follows" and "Rotates" if Driver Mode is ON
                CurrentLocationLayer(
                  alignPositionOnUpdate: isDriverMode ? AlignOnUpdate.always : AlignOnUpdate.never,
                  alignDirectionOnUpdate: isDriverMode ? AlignOnUpdate.always : AlignOnUpdate.never,
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(
                      color: Colors.amber,
                      child: Icon(Icons.directions_bus, color: Colors.black, size: 20),
                    ),
                    markerSize: Size(40, 40),
                    markerDirection: MarkerDirection.heading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}