import 'package:flutter/material.dart';
import '../widgets/custom_widgets.dart';
import '../services/student_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});
  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController schoolAddressController = TextEditingController();

  LatLng? homeLocation;
  LatLng? schoolLocation;

  bool isLoading = false;
  final StudentService studentService = StudentService();

  Future<void> pickLocation(bool isHome) async {
    final initialPos = isHome ? (homeLocation ?? const LatLng(6.9271, 79.8612)) : (schoolLocation ?? const LatLng(6.9271, 79.8612));
    final LatLng? picked = await Navigator.push(context, MaterialPageRoute(builder: (_) => MapPickerScreen(initialPosition: initialPos)));
    
    if (picked != null) {
      setState(() {
        if (isHome) {
          homeLocation = picked;
          homeAddressController.text = "${picked.latitude.toStringAsFixed(4)}, ${picked.longitude.toStringAsFixed(4)}";
        } else {
          schoolLocation = picked;
          schoolAddressController.text = "${picked.latitude.toStringAsFixed(4)}, ${picked.longitude.toStringAsFixed(4)}";
        }
      });
    }
  }

  Future<void> saveStudent() async {
    if (fullNameController.text.isEmpty || schoolNameController.text.isEmpty || ageController.text.isEmpty || homeLocation == null || schoolLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and pick locations')));
      return;
    }

    setState(() => isLoading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentId = prefs.getString('uid');

    if (parentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Not logged in.')));
      setState(() => isLoading = false);
      return;
    }

    int age = int.tryParse(ageController.text) ?? 5;

    Student? student = await studentService.addStudentWithLocation(
      parentId, 
      fullNameController.text.trim(), 
      schoolNameController.text.trim(), 
      age,
      homeLocation!.latitude,
      homeLocation!.longitude,
      schoolLocation!.latitude,
      schoolLocation!.longitude,
      homeAddressController.text.trim(),
      schoolAddressController.text.trim(),
    );
    
    setState(() => isLoading = false);

    if (student != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Student added successfully!')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add student. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Student Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
              const SizedBox(height: 20),
              CustomTextField(hintText: 'Full Name', controller: fullNameController),
              CustomTextField(hintText: 'School Name', controller: schoolNameController),
              CustomTextField(hintText: 'Age (Years)', controller: ageController),
              const SizedBox(height: 20),
              const Text('Locations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(
                title: Text(homeLocation == null ? "Pick Home Location" : "Home Location Set"),
                subtitle: Text(homeAddressController.text.isEmpty ? "Tap icon to map" : homeAddressController.text),
                trailing: IconButton(icon: const Icon(Icons.map, color: Color(0xFF00C2E0)), onPressed: () => pickLocation(true)),
              ),
              ListTile(
                title: Text(schoolLocation == null ? "Pick School Location" : "School Location Set"),
                subtitle: Text(schoolAddressController.text.isEmpty ? "Tap icon to map" : schoolAddressController.text),
                trailing: IconButton(icon: const Icon(Icons.map, color: Color(0xFF00C2E0)), onPressed: () => pickLocation(false)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveStudent,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0)),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
