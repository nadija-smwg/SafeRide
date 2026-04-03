import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ─────────────────────────────────────────────────────────────────────────
  // TODO: Change this to your actual Spring Boot server URL.
  //   • Running on a physical device / production → use your server's IP or domain
  //   • Running on Android emulator              → use http://10.0.2.2:8080
  //   • Running on iOS simulator                 → use http://localhost:8080
  // ─────────────────────────────────────────────────────────────────────────
  static const String _baseUrl = 'http://172.20.10.5:8080';

  // ---------------------------------------------------------------------------
  // notifyBackend
  //
  // Call this immediately after Firebase Auth succeeds (login OR register).
  // It fetches the user's Firebase ID Token (a signed JWT) and POSTs it to
  // your Spring Boot endpoint at POST /api/auth/login.
  //
  // The Spring Boot backend should verify the token with the Firebase Admin SDK
  // and extract the UID from it — see the implementation plan for the guide.
  // ---------------------------------------------------------------------------
  static Future<void> notifyBackend() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('[ApiService] No authenticated user — skipping backend call.');
        return;
      }

      // Get a fresh ID Token (Firebase auto-refreshes if expired)
      final idToken = await user.getIdToken();

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        print('[ApiService] ✅ Backend notified. UID: ${user.uid}');
      } else {
        print('[ApiService] ⚠️ Backend returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      // A network error should never block the user from entering the app.
      // Log it and move on.
      print('[ApiService] ❌ Could not reach backend: $e');
    }
  }
}
