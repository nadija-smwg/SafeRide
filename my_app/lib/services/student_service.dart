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
  LocationObject morningPickup;
  LocationObject morningDropoff;
  bool needMorningPickup;
  LocationObject eveningPickup;
  LocationObject eveningDropoff;
  bool needEveningPickup;

  ScheduleItem({
    required this.day, 
    required this.morningPickup, 
    required this.morningDropoff, 
    required this.needMorningPickup, 
    required this.eveningPickup, 
    required this.eveningDropoff, 
    required this.needEveningPickup
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      day: json['day'] ?? '',
      morningPickup: json['morningPickup'] != null ? LocationObject.fromJson(json['morningPickup']) : LocationObject(id: '', name: 'Home', lat: 0.0, lng: 0.0, address: ''),
      morningDropoff: json['morningDropoff'] != null ? LocationObject.fromJson(json['morningDropoff']) : LocationObject(id: '', name: 'School', lat: 0.0, lng: 0.0, address: ''),
      needMorningPickup: json['needMorningPickup'] ?? true,
      eveningPickup: json['eveningPickup'] != null ? LocationObject.fromJson(json['eveningPickup']) : LocationObject(id: '', name: 'School', lat: 0.0, lng: 0.0, address: ''),
      eveningDropoff: json['eveningDropoff'] != null ? LocationObject.fromJson(json['eveningDropoff']) : LocationObject(id: '', name: 'Home', lat: 0.0, lng: 0.0, address: ''),
      needEveningPickup: json['needEveningPickup'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "morningPickup": morningPickup.toJson(),
      "morningDropoff": morningDropoff.toJson(),
      "needMorningPickup": needMorningPickup,
      "eveningPickup": eveningPickup.toJson(),
      "eveningDropoff": eveningDropoff.toJson(),
      "needEveningPickup": needEveningPickup,
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
  Future<bool> deleteStudent(String studentId) async {
    try {
      final response = await http.delete(Uri.parse("$endpoint/$studentId"));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<ParentProfile?> getParentProfile(String parentId) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/profile/$parentId"));
      if (response.statusCode == 200) {
        return ParentProfile.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> updateParentProfile(String parentId, ParentProfile data) async {
    try {
      final response = await http.put(
        Uri.parse("$endpoint/profile/$parentId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

class LocationObject {
  String id;
  String name;
  double lat;
  double lng;
  String address;

  LocationObject({required this.id, required this.name, required this.lat, required this.lng, required this.address});

  factory LocationObject.fromJson(Map<String, dynamic> json) {
    return LocationObject(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "lat": lat,
      "lng": lng,
      "address": address,
    };
  }
}

class ParentProfile {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? homeAddress;
  final List<LocationObject>? savedLocations;

  ParentProfile({this.id, this.fullName, this.phoneNumber, this.homeAddress, this.savedLocations});

  factory ParentProfile.fromJson(Map<String, dynamic> json) {
    List<LocationObject> locs = [];
    if (json['savedLocations'] != null) {
      locs = (json['savedLocations'] as List).map((i) => LocationObject.fromJson(i)).toList();
    }
    return ParentProfile(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      homeAddress: json['homeAddress'],
      savedLocations: locs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (homeAddress != null) 'homeAddress': homeAddress,
      if (savedLocations != null) 'savedLocations': savedLocations!.map((v) => v.toJson()).toList(),
    };
  }
}
