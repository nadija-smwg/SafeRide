import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/student_service.dart';
import 'edit_parent_profile_screen.dart';

class ParentProfileScreen extends StatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  final StudentService studentService = StudentService();
  
  bool isLoading = true;
  String? parentId;
  ParentProfile? profile;
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    setState(() => isLoading = true);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    parentId = prefs.getString('uid');
    
    if (parentId != null) {
      profile = await studentService.getParentProfile(parentId!);
      students = await studentService.getStudentsByParent(parentId!);
    }
    
    setState(() => isLoading = false);
  }

  Future<void> confirmAndDeleteStudent(String studentId, String studentName) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Student?'),
          content: Text('Are you sure you want to remove $studentName from your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() => isLoading = true);
      bool success = await studentService.deleteStudent(studentId);
      if (success) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student removed successfully.')));
        await loadProfileData();
      } else {
        setState(() => isLoading = false);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to remove student.')));
      }
    }
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
                    builder: (_) => EditParentProfileScreen(
                      profile: profile!, 
                      parentId: parentId!
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
                              const Icon(Icons.home, color: Colors.black54),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(profile?.homeAddress ?? 'Not Set', style: const TextStyle(fontSize: 16)),
                              )
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
                      child: Center(child: Text("No students currently registered to your account.", style: TextStyle(color: Colors.black54))),
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
                        subtitle: Text('${student.schoolName}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => confirmAndDeleteStudent(student.id, student.fullName),
                        ),
                      ),
                    )),
                ],
              ),
            ),
    );
  }
}
