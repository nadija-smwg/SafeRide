import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/student_service.dart';
import 'location_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class EditStudentScheduleScreen extends StatefulWidget {
  final Student student;
  const EditStudentScheduleScreen({super.key, required this.student});

  @override
  State<EditStudentScheduleScreen> createState() => _EditStudentScheduleScreenState();
}

class _EditStudentScheduleScreenState extends State<EditStudentScheduleScreen> {
  late List<ScheduleItem> schedule;
  List<LocationObject> savedLocations = [];
  bool isLoading = true;

  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    // Deep copy for mutation isolation
    schedule = widget.student.weeklySchedule.map((s) => ScheduleItem(
      day: s.day,
      morningPickup: LocationObject.fromJson(s.morningPickup.toJson()),
      morningDropoff: LocationObject.fromJson(s.morningDropoff.toJson()),
      needMorningPickup: s.needMorningPickup,
      eveningPickup: LocationObject.fromJson(s.eveningPickup.toJson()),
      eveningDropoff: LocationObject.fromJson(s.eveningDropoff.toJson()),
      needEveningPickup: s.needEveningPickup,
    )).toList();

    _loadParentLocations();
  }

  Future<void> _loadParentLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pId = prefs.getString('uid');
    if (pId != null) {
      ParentProfile? profile = await studentService.getParentProfile(pId);
      if (profile != null && profile.savedLocations != null) {
        setState(() {
          savedLocations = profile.savedLocations!;
          // Pre-seed any defaults if missing
          if (savedLocations.isEmpty) {
            savedLocations.add(LocationObject(id: 'home', name: 'Home', lat: 0, lng: 0, address: ''));
            savedLocations.add(LocationObject(id: 'school', name: 'School', lat: 0, lng: 0, address: ''));
          }
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> updateSchedule() async {
    setState(() => isLoading = true);
    Student? updatedStudent = await studentService.updateStudentSchedule(widget.student.id, schedule);
    setState(() => isLoading = false);

    if (updatedStudent != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schedule updated!')));
        Navigator.pop(context, updatedStudent);
      }
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to update schedule.')));
    }
  }

  Future<LocationObject> _selectLocationInteractive(LocationObject currentVal) async {
    return await showModalBottomSheet<LocationObject>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Choose Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...savedLocations.map((loc) => ListTile(
                leading: const Icon(Icons.star, color: Colors.orangeAccent),
                title: Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: loc.address.isNotEmpty ? Text(loc.address) : null,
                onTap: () => Navigator.pop(context, loc),
              )),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.map, color: Color(0xFF00C2E0)),
                title: const Text("Select on Map..."),
                onTap: () async {
                  LatLng? picked = await Navigator.push(context, MaterialPageRoute(
                    builder: (_) => LocationPickerScreen(
                      initialCenter: LatLng(currentVal.lat, currentVal.lng)
                    )
                  ));
                  if (picked != null && mounted) {
                    Navigator.pop(context, LocationObject(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      name: 'Custom Location',
                      lat: picked.latitude,
                      lng: picked.longitude,
                      address: ''
                    ));
                  } else {
                    if (mounted) Navigator.pop(context, currentVal); // fallback
                  }
                },
              )
            ],
          ),
        );
      }
    ) ?? currentVal;
  }

  Widget _buildLocationTile(String title, LocationObject location, Function(LocationObject) onChanged) {
    return InkWell(
      onTap: () async {
        LocationObject updated = await _selectLocationInteractive(location);
        onChanged(updated);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F8FF),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(location.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Schedule', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black)
      ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C2E0)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final item = schedule[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.day, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00C2E0))),
                      const Divider(height: 30),
                      
                      // Morning Segment
                      const Row(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text("Morning Transit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Need Morning Route?"),
                        value: item.needMorningPickup,
                        activeColor: const Color(0xFF00C2E0),
                        onChanged: (val) => setState(() => item.needMorningPickup = val),
                      ),
                      if (item.needMorningPickup) ...[
                        _buildLocationTile("Pickup From", item.morningPickup, (loc) => setState(() => item.morningPickup = loc)),
                        const Center(child: Icon(Icons.arrow_downward, color: Colors.grey, size: 20)),
                        _buildLocationTile("Drop-off At", item.morningDropoff, (loc) => setState(() => item.morningDropoff = loc)),
                      ],

                      const Divider(height: 40),
                      
                      // Evening Segment
                      const Row(
                        children: [
                          Icon(Icons.nights_stay, color: Colors.indigo, size: 20),
                          SizedBox(width: 8),
                          Text("Evening Transit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Need Evening Route?"),
                        value: item.needEveningPickup,
                        activeColor: const Color(0xFF00C2E0),
                        onChanged: (val) => setState(() => item.needEveningPickup = val),
                      ),
                      if (item.needEveningPickup) ...[
                        _buildLocationTile("Pickup From", item.eveningPickup, (loc) => setState(() => item.eveningPickup = loc)),
                        const Center(child: Icon(Icons.arrow_downward, color: Colors.grey, size: 20)),
                        _buildLocationTile("Drop-off At", item.eveningDropoff, (loc) => setState(() => item.eveningDropoff = loc)),
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: isLoading ? const SizedBox(height:20, width:20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save Schedule', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
