// lib/services/constants.dart

class ApiConstants {
  // IP address of the machine running the Spring Boot backend
  static const String baseUrl = "http://172.20.10.5:8085";

  // Authentication Endpoints
  static const String registerEndpoint = "$baseUrl/api/auth/register";
  static const String loginEndpoint = "$baseUrl/api/auth/login";
}