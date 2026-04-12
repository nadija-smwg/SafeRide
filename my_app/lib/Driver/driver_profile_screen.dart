import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/driver_service.dart';
import '../services/student_service.dart';
import 'edit_driver_profile_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final DriverService driverService = DriverService();
  
  bool isLoading = true;
  String? driverId;
  DriverProfile? profile;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    setState(() => isLoading = true);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverId = prefs.getString('uid');
    
    if (driverId != null) {
      profile = await driverService.getDriverProfile(driverId!);
      students = await driverService.getAssignedStudents(driverId!);
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          if (profile != null)
            TextButton.icon(
              onPressed: () async {
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditDriverProfileScreen(
                      profile: profile!, 
                      driverId: driverId!
                    )
                  )
                );
                if (updated == true) {
                  loadProfileData();
                }
              },
              icon: const Icon(Icons.edit, color: Color(0xFF00C2E0)),
              label: const Text('Edit', style: TextStyle(color: Color(0xFF00C2E0))),
            )
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C2E0)))
        : profile == null 
          ? const Center(child: Text("Could not load profile data."))
          : RefreshIndicator(
              onRefresh: loadProfileData,
              color: const Color(0xFF00C2E0),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                children: [
                  // Profile Header Section
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFE8F4F8),
                          child: Icon(Icons.person, size: 50, color: Color(0xFF00C2E0)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profile?.fullName ?? 'No Name Provided',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C2E0).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Vehicle: ${profile?.vehicleNumber ?? "Not Set"}',
                            style: const TextStyle(color: Color(0xFF00C2E0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Contact Details Section
                  const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.phone, color: Colors.black54),
                              const SizedBox(width: 15),
                              Text(profile?.phoneNumber ?? 'Not Set', style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const Icon(Icons.badge, color: Colors.black54),
                              const SizedBox(width: 15),
                              Text(profile?.licenseNumber ?? 'Not Set', style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Registered Students Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Registered Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFE8F4F8), shape: BoxShape.circle),
                        child: Text('${students.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  if (students.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(child: Text("No students currently assigned to your route.", style: TextStyle(color: Colors.black54))),
                    )
                  else
                    ...students.map((student) => Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F4F8),
                          child: Icon(Icons.school, color: Color(0xFF00C2E0), size: 20),
                        ),
                        title: Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${student.schoolName} • Status: ${student.status.replaceAll('_', ' ')}'),
                      ),
                    )),
                ],
              ),
            ),
    );
  }
}
