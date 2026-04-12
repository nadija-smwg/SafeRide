import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'student_service.dart';

class DriverService {
  static const String endpoint = "${ApiConstants.baseUrl}/api/driver-dashboard";

  Future<bool> linkStudent(String driverId, String studentId) async {
    try {
      final response = await http.post(Uri.parse("$endpoint/drivers/$driverId/students/$studentId"));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Student>> getAssignedStudents(String driverId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/drivers/$driverId/students"));
      if (response.statusCode == 200) {
        Iterable l = jsonDecode(response.body);
        return List<Student>.from(l.map((model) => Student.fromJson(model)));
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<bool> updateStudentStatus(String studentId, String status) async {
    try {
      final response = await http.put(Uri.parse("$endpoint/students/$studentId/status?status=$status"));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> scanStudent(String studentId, bool isPickup) async {
    try {
      final response = await http.post(
        Uri.parse("$endpoint/scan/$studentId?isPickup=$isPickup")
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateDriverLocation(String driverId, double lat, double lng) async {
    try {
      final response = await http.put(Uri.parse("$endpoint/drivers/$driverId/location?latitude=$lat&longitude=$lng"));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getDriverLocation(String driverId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/drivers/$driverId/location"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
  Future<DriverProfile?> getDriverProfile(String driverId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/drivers/$driverId/profile"));
      if (response.statusCode == 200) {
        return DriverProfile.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateDriverProfile(String driverId, DriverProfile profileData) async {
    try {
      final response = await http.put(
        Uri.parse("$endpoint/drivers/$driverId/profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profileData.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class DriverProfile {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? licenseNumber;
  final String? vehicleNumber;

  DriverProfile({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.licenseNumber,
    this.vehicleNumber,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      licenseNumber: json['licenseNumber'],
      vehicleNumber: json['vehicleNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (licenseNumber != null) 'licenseNumber': licenseNumber,
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
    };
  }
}
