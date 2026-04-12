import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/student_service.dart';
import 'add_student_screen.dart';
import 'student_details_screen.dart';
import 'live_tracking_screen.dart';
import 'package:flutter/services.dart';
import 'parent_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentService studentService = StudentService();
  List<Student> students = [];
  bool isLoading = true;
  String? parentId;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parentId = prefs.getString('uid');
    
    if (parentId != null) {
      students = await studentService.getStudentsByParent(parentId!);
    }
    setState(() => isLoading = false);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'IN_TRANSIT': return Colors.blue;
      case 'IN_SCHOOL': return Colors.green;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        automaticallyImplyLeading: false, // Prevents back navigation
        title: const Text('My Dashboard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, color: Colors.black, size: 28),
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentProfileScreen()));
              } else if (value == 'logout') {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('uid');
                await prefs.remove('role');
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/Passengerlogin', (route) => false);
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
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : RefreshIndicator(
            onRefresh: loadStudents,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('My Students', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                const SizedBox(height: 16),
                if (students.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('No students found. Click + to add your child.'),
                    ),
                  ),
                ...students.map((student) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F4F8),
                      child: Icon(Icons.person, color: Color(0xFF00C2E0)),
                    ),
                    title: Text(student.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${student.schoolName} • Age ${student.age}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(student.status).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(student.status.replaceAll('_', ' '), style: TextStyle(color: _getStatusColor(student.status), fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            if (student.status == 'IN_TRANSIT') ...[
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveTrackingScreen(student: student))),
                                child: const Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                                    Text(" Track Bus", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                                  ],
                                ),
                              )
                            ]
                          ],
                        )
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      bool? updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentDetailsScreen(student: student)),
                      );
                      if (updated == true) {
                        loadStudents(); // Refresh data if edited
                      }
                    },
                  ),
                )),
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C2E0),
        onPressed: () async {
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentScreen()),
          );
          if (added == true) {
            loadStudents(); 
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      ),
    );
  }
}