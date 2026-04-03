import 'package:flutter/material.dart';
import '../services/student_service.dart';

class EditStudentScheduleScreen extends StatefulWidget {
  final Student student;
  const EditStudentScheduleScreen({super.key, required this.student});

  @override
  State<EditStudentScheduleScreen> createState() => _EditStudentScheduleScreenState();
}

class _EditStudentScheduleScreenState extends State<EditStudentScheduleScreen> {
  late List<ScheduleItem> schedule;
  bool isLoading = false;
  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    // create a deep copy so we don't mutate the original till saved
    schedule = widget.student.weeklySchedule.map((s) => ScheduleItem(
      day: s.day,
      pickupLocation: s.pickupLocation,
      dropoffLocation: s.dropoffLocation,
      availabilityToPickup: s.availabilityToPickup,
    )).toList();
  }

  Future<void> updateSchedule() async {
    setState(() => isLoading = true);
    Student? updatedStudent = await studentService.updateStudentSchedule(widget.student.id, schedule);
    setState(() => isLoading = false);

    if (updatedStudent != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule updated!')));
      Navigator.pop(context, updatedStudent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update schedule.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Schedule', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: schedule.length,
        itemBuilder: (context, index) {
          final item = schedule[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                  SwitchListTile(
                    title: const Text("Need Pickup?"),
                    value: item.availabilityToPickup,
                    onChanged: (val) => setState(() => item.availabilityToPickup = val),
                  ),
                  if (item.availabilityToPickup) ...[
                    TextField(
                      decoration: const InputDecoration(labelText: "Pickup Location"),
                      controller: TextEditingController(text: item.pickupLocation)..selection = TextSelection.collapsed(offset: item.pickupLocation.length),
                      onChanged: (val) => item.pickupLocation = val,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: "Drop-off Location"),
                      controller: TextEditingController(text: item.dropoffLocation)..selection = TextSelection.collapsed(offset: item.dropoffLocation.length),
                      onChanged: (val) => item.dropoffLocation = val,
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isLoading ? null : updateSchedule,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0), minimumSize: const Size(double.infinity, 50)),
            child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Schedule'),
          ),
        ),
      ),
    );
  }
}
