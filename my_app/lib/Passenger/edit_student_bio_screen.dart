import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../services/student_service.dart';

class EditStudentBioScreen extends StatefulWidget {
  final Student student;
  const EditStudentBioScreen({super.key, required this.student});

  @override
  State<EditStudentBioScreen> createState() => _EditStudentBioScreenState();
}

class _EditStudentBioScreenState extends State<EditStudentBioScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool isLoading = false;
  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.student.fullName;
    schoolNameController.text = widget.student.schoolName;
    ageController.text = widget.student.age.toString();
  }

  Future<void> updateBio() async {
    if (fullNameController.text.isEmpty || schoolNameController.text.isEmpty || ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => isLoading = true);
    int age = int.tryParse(ageController.text) ?? widget.student.age;

    Student? updatedStudent = await studentService.updateStudentBio(widget.student.id, fullNameController.text.trim(), schoolNameController.text.trim(), age);
    
    setState(() => isLoading = false);

    if (updatedStudent != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bio updated successfully!')));
      Navigator.pop(context, updatedStudent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update bio.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Bio', style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomTextField(hintText: 'Full Name', controller: fullNameController),
              CustomTextField(hintText: 'School Name', controller: schoolNameController),
              CustomTextField(hintText: 'Age', controller: ageController),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateBio,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0)),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
