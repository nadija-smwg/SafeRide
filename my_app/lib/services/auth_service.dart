import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart'; 

class AuthService {
  
  // UPDATED REGISTER FUNCTION
  // We now accept all the fields your Spring Boot 'RegisterRequest.java' requires
  Future<bool> registerUser({
    required String email,
    required String password,
    required String role,
    required String fullName,
    required String phoneNumber,
    required String licenseNumber,
    required String vehicleNumber,
    required String username,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.registerEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
          "role": role,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "licenseNumber": licenseNumber,
          "vehicleNumber": vehicleNumber,
          "username": username,
          "confirmPassword": password, // Backend DTO expects this field
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
  Future<bool> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.loginEndpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
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