import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. State Variables to track what is open/closed
  bool isPickUpMode = true;
  bool isQrExpanded = true;
  bool isScheduleExpanded = false;
  bool isMapExpanded = false;

  // Reusable function for the dividers
  Widget _buildDivider() {
    return Container(height: 1.5, color: Colors.grey.shade300);
  }

  // Reusable function for the header rows
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
              color: Colors.black87
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  // Helper for the dynamic arrows
  Widget _buildArrow(bool isExpanded) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_back_ios_new,
        size: 14,
        color: Colors.black87,
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
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
            ),
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: Colors.black, size: 22),
            SizedBox(width: 8),
            Text(
              'Student Saman',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/PassengerWelcome', (route) => false);
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
              ),
            ),
          ),
        ],
      ),
      // We use SingleChildScrollView so the screen can scroll when sections open
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- SECTION 1: PICK UP MODE ---
            _buildListRow(
              title: 'Pick up Mode',
              trailing: Switch(
                value: isPickUpMode,
                activeTrackColor: Colors.greenAccent.shade400,
                onChanged: (val) => setState(() => isPickUpMode = val),
              ),
            ),
            _buildDivider(),

            // --- SECTION 2: QR CODE ---
            InkWell(
              onTap: () => setState(() => isQrExpanded = !isQrExpanded),
              child: _buildListRow(title: 'My QR code', trailing: _buildArrow(isQrExpanded)),
            ),
            if (isQrExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Icon(Icons.qr_code_2, size: 180, color: Colors.black87),
              ),
              _buildDivider(),
            ],

            // --- SECTION 3: SCHEDULE ---
            InkWell(
              onTap: () => setState(() => isScheduleExpanded = !isScheduleExpanded),
              child: _buildListRow(title: 'Schedule', trailing: _buildArrow(isScheduleExpanded)),
            ),
            if (isScheduleExpanded) ...[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                  columnWidths: const {
                    0: FlexColumnWidth(1.5), // Time column is slightly wider
                  },
                  children: [
                    // Header Row
                    const TableRow(
                      decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                      children: [
                        TableCell(child: Center(child: Padding(padding: EdgeInsets.all(4), child: Text('Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))))),
                        TableCell(child: Center(child: Text('Mon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                        TableCell(child: Center(child: Text('Tue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                        TableCell(child: Center(child: Text('Wed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                        TableCell(child: Center(child: Text('Thu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                        TableCell(child: Center(child: Text('Fri', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)))),
                      ],
                    ),
                    // Schedule Rows
                    for (var time in [
                      '6-7', '7-8', '8-9', '9-10', '10-11', '11-12', 
                      '12-13', '13-14', '14-15', '15-16', '16-17', '17-18'
                    ])
                      TableRow(
                        children: [
                          TableCell(child: Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(time, style: const TextStyle(fontSize: 10))))),
                          const TableCell(child: SizedBox()), // Monday
                          const TableCell(child: SizedBox()), // Tuesday
                          const TableCell(child: SizedBox()), // Wednesday
                          const TableCell(child: SizedBox()), // Thursday
                          const TableCell(child: SizedBox()), // Friday
                        ],
                      ),
                  ],
                ),
              ),
              _buildDivider(),
            ],

            // --- SECTION 4: LOCATION ---
            InkWell(
              onTap: () => setState(() => isMapExpanded = !isMapExpanded),
              child: _buildListRow(title: 'Location of the School Bus', trailing: _buildArrow(isMapExpanded)),
            ),
            if (isMapExpanded) ...[
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_bus_outlined, size: 50, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    const Text(
                      "Bus Tracking Map Active\n(Map implementation pending)",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildDivider(),
            ],

            // --- FOOTER ---
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
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
      ),
    );
  }
}