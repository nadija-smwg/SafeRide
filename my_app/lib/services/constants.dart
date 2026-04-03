// lib/services/constants.dart

class ApiConstants {
  // 10.0.2.2 is the special IP address that allows the 
  // Android Emulator to connect to your computer's localhost.
  static const String baseUrl = "http://10.0.2.2:8085";

  // Authentication Endpoints
  static const String registerEndpoint = "$baseUrl/api/auth/register";
  static const String loginEndpoint = "$baseUrl/api/auth/login";
}