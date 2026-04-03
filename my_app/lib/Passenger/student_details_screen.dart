import 'package:flutter/material.dart';
import '../services/student_service.dart';
import 'edit_student_bio_screen.dart';
import 'edit_student_schedule_screen.dart';
import 'student_qr_card_screen.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student currentStudent;

  @override
  void initState() {
    super.initState();
    currentStudent = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentStudent.fullName, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.qr_code_2, size: 40, color: Color(0xFF00C2E0)),
              title: const Text("Student QR Identity", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("View and export your child's onboarding barcode.", style: TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StudentQrCardScreen(student: currentStudent))),
            )
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Bio Data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () async {
                          final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditStudentBioScreen(student: currentStudent)));
                          if (updated != null && updated is Student) {
                            setState(() => currentStudent = updated);
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text("School: ${currentStudent.schoolName}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text("Age: ${currentStudent.age}", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Driver Assignment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                  const SizedBox(height: 10),
                  if (currentStudent.assignedDriverId == null) ...[
                    const Text("No driver is currently assigned to your child.", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Assign a Driver"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Share this unique Student ID with your van driver so they can link your child directly to their route:"),
                                const SizedBox(height: 20),
                                SelectableText(currentStudent.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                              ],
                            ),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK", style: TextStyle(color: Color(0xFF00C2E0))))],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0)),
                      child: const Text("Assign a Driver", style: TextStyle(color: Colors.white)),
                    )
                  ] else ...[
                    const Text("A driver is currently assigned.", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
                        final details = await StudentService().getDriverDetails(currentStudent.assignedDriverId!);
                        if (context.mounted) Navigator.pop(context);
                        if (details != null && context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Driver Details"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${details['fullName'] ?? 'Unknown'}"),
                                  const SizedBox(height: 10),
                                  Text("Vehicle Number: ${details['vehicleNumber'] ?? 'Unknown'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Text("Phone: ${details['phoneNumber'] ?? 'Unknown'}"),
                                ],
                              ),
                              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close", style: TextStyle(color: Color(0xFF00C2E0))))],
                            ),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to load driver details.")));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.indigoAccent),
                      child: const Text("View Driver Details", style: TextStyle(color: Colors.white)),
                    )
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Weekly Schedule", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () async {
                          final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditStudentScheduleScreen(student: currentStudent)));
                          if (updated != null && updated is Student) {
                            setState(() => currentStudent = updated);
                          }
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...currentStudent.weeklySchedule.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 100, child: Text(s.day, style: const TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(
                          child: s.availabilityToPickup 
                            ? Text("${s.pickupLocation} ➔ ${s.dropoffLocation}")
                            : const Text("Not Needed", style: TextStyle(color: Colors.grey)),
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
