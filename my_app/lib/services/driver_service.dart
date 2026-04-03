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
}
