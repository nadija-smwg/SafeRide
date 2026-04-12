import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/driver_service.dart';
import '../services/student_service.dart';
import 'qr_scanner_screen.dart';

class RouteListScreen extends StatefulWidget {
  final bool isPickup;
  const RouteListScreen({super.key, required this.isPickup});

  @override
  State<RouteListScreen> createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  final DriverService driverService = DriverService();
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRoute();
  }

  Future<void> loadRoute() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? driverId = prefs.getString('uid');
    
    if (driverId != null) {
      driverService.updateDriverLocation(driverId, 6.9271, 79.8612);
      students = await driverService.getAssignedStudents(driverId);
    }
    setState(() => isLoading = false);
  }

  Future<void> scanQR() async {
    final String? scannedStudentId = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScannerScreen()),
    );

    if (scannedStudentId != null && scannedStudentId.isNotEmpty) {
      Student? targetStudent;
      try {
        targetStudent = students.firstWhere((s) => s.id == scannedStudentId);
      } catch (e) {}

      if (targetStudent != null) {
        bool isCompleted = widget.isPickup ? targetStudent.status == "IN_SCHOOL" : targetStudent.status == "AT_HOME";
        if (isCompleted) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                title: const Text("Already Dropped Off", style: TextStyle(color: Colors.redAccent)),
                content: const Text("The student has been already dropped off."),
                actions: [
                  TextButton(
                    child: const Text("OK", style: TextStyle(color: Color(0xFF00C2E0))),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            }
          );
          return;
        }
      }

      setState(() => isLoading = true);
      bool success = await driverService.scanStudent(scannedStudentId, widget.isPickup);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student scanned successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update status. Check ID.")));
      }
      loadRoute();
    }
  }

  String _getTodayName() {
    switch (DateTime.now().weekday) {
      case 1: return "Monday";
      case 2: return "Tuesday";
      case 3: return "Wednesday";
      case 4: return "Thursday";
      case 5: return "Friday";
      case 6: return "Saturday";
      case 7: return "Sunday";
      default: return "Monday";
    }
  }

  bool _isStudentScheduledForToday(Student s) {
    String today = _getTodayName();
    ScheduleItem? todaySchedule;
    try {
      todaySchedule = s.weeklySchedule.firstWhere((item) => item.day == today);
    } catch (e) {}

    if (todaySchedule == null) return false;

    if (widget.isPickup) {
      return todaySchedule.needMorningPickup;
    } else {
      return todaySchedule.needEveningPickup;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.isPickup ? "Morning Pickup" : "Afternoon Dropoff";

    final scheduledStudents = students.where((s) => _isStudentScheduledForToday(s)).toList();

    final pending = scheduledStudents.where((s) => widget.isPickup ? s.status == "AT_HOME" : s.status == "IN_SCHOOL").toList();
    final inTransit = scheduledStudents.where((s) => s.status == "IN_TRANSIT").toList();
    final completed = scheduledStudents.where((s) => widget.isPickup ? s.status == "IN_SCHOOL" : s.status == "AT_HOME").toList();

    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: scanQR,
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  label: const Text('Scan Student QR', style: TextStyle(color: Colors.white, fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C2E0),
                    minimumSize: const Size(double.infinity, 60)
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSection("Pending (${pending.length})", pending, Colors.orange),
                    const SizedBox(height: 20),
                    _buildSection("In Transit (${inTransit.length})", inTransit, Colors.blue),
                    const SizedBox(height: 20),
                    _buildSection("Completed (${completed.length})", completed, Colors.green),
                  ],
                ),
              )
            ],
          ),
    );
  }

  Widget _buildSection(String header, List<Student> list, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const Divider(),
        ...list.map((s) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(s.fullName),
          subtitle: Text("Status: ${s.status}"),
          trailing: const IconButton(
            icon: Icon(Icons.check_circle_outline),
            tooltip: 'Please use the QR Scanner to update status',
            onPressed: null, // disabled: enforce QR scanning
          ),
        ))
      ],
    );
  }
}

