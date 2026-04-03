import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class Student {
  final String id;
  final String parentId;
  final String fullName;
  final String schoolName;
  final int age;
  final List<ScheduleItem> weeklySchedule;
  final String? assignedDriverId;
  final String status;

  Student({required this.id, required this.parentId, required this.fullName, required this.schoolName, required this.age, required this.weeklySchedule, this.assignedDriverId, this.status = "AT_HOME"});

  factory Student.fromJson(Map<String, dynamic> json) {
    var list = json['weeklySchedule'] as List? ?? [];
    List<ScheduleItem> scheduleList = list.map((i) => ScheduleItem.fromJson(i)).toList();
    return Student(
      id: json['id'] ?? '',
      parentId: json['parentId'] ?? '',
      fullName: json['fullName'] ?? '',
      schoolName: json['schoolName'] ?? '',
      age: json['age'] ?? 0,
      weeklySchedule: scheduleList,
      assignedDriverId: json['assignedDriverId'],
      status: json['status'] ?? 'AT_HOME',
    );
  }
}

class ScheduleItem {
  String day;
  String pickupLocation;
  String dropoffLocation;
  bool availabilityToPickup;

  ScheduleItem({required this.day, required this.pickupLocation, required this.dropoffLocation, required this.availabilityToPickup});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      day: json['day'] ?? '',
      pickupLocation: json['pickupLocation'] ?? 'Home',
      dropoffLocation: json['dropoffLocation'] ?? 'Home',
      availabilityToPickup: json['availabilityToPickup'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "pickupLocation": pickupLocation,
      "dropoffLocation": dropoffLocation,
      "availabilityToPickup": availabilityToPickup,
    };
  }
}

class StudentService {
  static const String endpoint = "${ApiConstants.baseUrl}/api/parent/students";

  Future<Student?> addStudent(String parentId, String fullName, String schoolName, int age) async {
    try {
      final response = await http.post(
        Uri.parse("$endpoint/parent/$parentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fullName": fullName, "schoolName": schoolName, "age": age}),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      }
    } catch (e) { print(e); } return null;
  }

  Future<Student?> addStudentWithLocation(String parentId, String fullName, String schoolName, int age, double hLat, double hLng, double sLat, double sLng, String hAddr, String sAddr) async {
    try {
      final response = await http.post(
        Uri.parse("$endpoint/parent/$parentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": fullName, "schoolName": schoolName, "age": age,
          "homeLat": hLat, "homeLng": hLng, "schoolLat": sLat, "schoolLng": sLng,
          "homeAddress": hAddr, "schoolAddress": sAddr
        }),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<List<Student>> getStudentsByParent(String parentId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/parent/$parentId"));
      if (response.statusCode == 200) {
        Iterable l = jsonDecode(response.body);
        return List<Student>.from(l.map((model) => Student.fromJson(model)));
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<Student?> updateStudentBio(String studentId, String fullName, String schoolName, int age) async {
    try {
      final response = await http.put(
        Uri.parse("$endpoint/$studentId/bio"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"fullName": fullName, "schoolName": schoolName, "age": age}),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getDriverDetails(String driverId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/driver/$driverId"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Student?> updateStudentSchedule(String studentId, List<ScheduleItem> schedule) async {
    try {
      List<Map<String, dynamic>> jsonList = schedule.map((item) => item.toJson()).toList();
      final response = await http.put(
        Uri.parse("$endpoint/$studentId/schedule"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonList),
      );
      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
