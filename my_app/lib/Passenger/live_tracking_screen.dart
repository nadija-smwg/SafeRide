import 'package:flutter/material.dart';
import '../services/driver_service.dart';
import '../services/student_service.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Student student;
  const LiveTrackingScreen({super.key, required this.student});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final DriverService driverService = DriverService();
  Map<String, dynamic>? driverLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => isLoading = true);
    if (widget.student.assignedDriverId != null) {
      final loc = await driverService.getDriverLocation(widget.student.assignedDriverId!);
      if (mounted) {
        setState(() {
          driverLocation = loc;
          isLoading = false;
        });
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Bus Tracking', style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : driverLocation == null
            ? const Center(child: Text("Location unavailable or driver not assigned."))
            : Column(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.map, size: 100, color: Colors.white),
                        const Positioned(
                          top: 10, left: 10,
                          child: Text("Google/Apple Map Interface", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                        ),
                        // Mock pin
                        Positioned(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_bus, size: 40, color: Colors.blueAccent),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                                child: Text("Lat: ${driverLocation!['latitude']}\nLng: ${driverLocation!['longitude']}", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status: En Route", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                          const SizedBox(height: 10),
                          Text("${widget.student.fullName} is currently on the school van.", style: const TextStyle(fontSize: 16)),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _fetchLocation,
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label: const Text("Refresh Location", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00C2E0)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
    );
  }
}
