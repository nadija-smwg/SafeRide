import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? role = prefs.getString('role');

    if (uid != null && uid.isNotEmpty) {
      if (role == 'Parent') {
        Navigator.pushReplacementNamed(context, '/home');
      } else if (role == 'DRIVER') {
        Navigator.pushReplacementNamed(context, '/Driverhome');
      } else {
        Navigator.pushReplacementNamed(context, '/RoleSelection');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/RoleSelection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFF00C2E0)),
      ),
    );
  }
}
