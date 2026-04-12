import 'package:flutter/material.dart';
import '../services/student_service.dart';

class EditParentProfileScreen extends StatefulWidget {
  final ParentProfile profile;
  final String parentId;

  const EditParentProfileScreen({
    super.key,
    required this.profile,
    required this.parentId,
  });

  @override
  State<EditParentProfileScreen> createState() => _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  bool isSaving = false;
  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.fullName);
    phoneController = TextEditingController(text: widget.profile.phoneNumber);
    addressController = TextEditingController(text: widget.profile.homeAddress);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    setState(() => isSaving = true);
    
    ParentProfile updatedProfile = ParentProfile(
      fullName: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      homeAddress: addressController.text.trim(),
    );

    bool success = await studentService.updateParentProfile(widget.parentId, updatedProfile);

    if (mounted) {
      setState(() => isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
        Navigator.pop(context, true); // Return true to indicate change
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update profile.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFE8F4F8),
                    child: Icon(Icons.person, size: 50, color: Color(0xFF00C2E0)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C2E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Home Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home_outlined),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C2E0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isSaving ? null : saveProfile,
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
