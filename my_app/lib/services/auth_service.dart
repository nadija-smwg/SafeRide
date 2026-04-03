import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart'; 

class AuthService {
  
  // UPDATED REGISTER FUNCTION
  // We now accept all the fields your Spring Boot 'RegisterRequest.java' requires
  Future<bool> registerUser({
    required String email,
    required String password,
    required String role,
    required String username,
    String? fullName,
    String? phoneNumber,
    String? licenseNumber,
    String? vehicleNumber,
    String? homeAddress,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": role,
          "username": username,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "licenseNumber": licenseNumber,
          "vehicleNumber": vehicleNumber,
          "homeAddress": homeAddress,
          "confirmPassword": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // You may want to parse UID from response if it returns it.
        // If register auto logs out, they login manually anyway.
        print("Registration Successful");
        return true;
      } else {
        print("Registration Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // LOGIN FUNCTION
  Future<bool> loginUser(String email, String password, String expectedRole) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "expectedRole": expectedRole,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String uid = data['uid'] ?? '';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', uid);
        await prefs.setString('role', expectedRole);
        print("Login Successful");
        return true;
      } else {
        print("Login Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }
}