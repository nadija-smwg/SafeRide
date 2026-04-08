import 'package:flutter/material.dart';
import '../services/driver_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'qr_scanner_screen.dart';

class AddStudentToDriverScreen extends StatefulWidget {
  const AddStudentToDriverScreen({super.key});

  @override
  State<AddStudentToDriverScreen> createState() => _AddStudentToDriverScreenState();
}

class _AddStudentToDriverScreenState extends State<AddStudentToDriverScreen> {
  final TextEditingController studentIdController = TextEditingController();
  final DriverService driverService = DriverService();
  bool isLoading = false;

  Future<void> linkStudent() async {
    if (studentIdController.text.isEmpty) return;
    setState(() => isLoading = true);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? driverId = prefs.getString('uid');
    
    if (driverId != null) {
      bool success = await driverService.linkStudent(driverId, studentIdController.text.trim());
      if (success) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student linked successfully!')));
        if (mounted) Navigator.pop(context, true);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to link. Check ID.')));
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student by ID', style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("Enter the unique Student ID provided by the Parent to link them to your route.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID', 
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    final scannedId = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                    );
                    if (scannedId != null && scannedId is String && scannedId.isNotEmpty) {
                      studentIdController.text = scannedId;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isLoading ? null : linkStudent,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0), minimumSize: const Size(double.infinity, 50)),
              child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Link Student', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
