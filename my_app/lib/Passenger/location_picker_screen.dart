import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng initialCenter;
  
  const LocationPickerScreen({super.key, required this.initialCenter});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late LatLng _selectedLocation;
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialCenter.latitude == 0 && widget.initialCenter.longitude == 0 
      ? const LatLng(6.9271, 79.8612) // Default Colombo City Center if empty
      : widget.initialCenter;
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
            child: const Text('Select', style: TextStyle(color: Color(0xFF00C2E0), fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _selectedLocation,
          initialZoom: 14.0,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.saferide.my_app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedLocation,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, size: 40, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.move(_selectedLocation, 16.0);
        },
        backgroundColor: const Color(0xFF00C2E0),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
