import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';
import 'Driver/welcome_screen.dart';
import 'Passenger/welcome_screen.dart';

import 'Driver/login_screen.dart';
import 'Passenger/login_screen.dart';

import 'Driver/register_screen.dart';
import 'Passenger/register_screen.dart';

import 'Driver/forgot_password_screen.dart';
import 'Passenger/forgot_password_screen.dart';

import 'Driver/otp_screen.dart';
import 'Passenger/otp_screen.dart';



import 'Driver/create_password_screen.dart'; 
import 'Passenger/create_password_screen.dart'; 

import 'Passenger/home_screen.dart';
import 'Driver/home_screen.dart';

void main() async {
  // 1. Ensure Flutter is fully loaded before we start Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Start the Firebase engine
  await Firebase.initializeApp(); 
  
  // 3. Run your app (If your main widget isn't called MyApp, use your widget's name here)
  runApp(const SafeRideApp()); 
}

class SafeRideApp extends StatelessWidget {
  const SafeRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeRide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00C2E0), // The cyan color
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Replace with your exact font if different
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C2E0),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RoleSelectionScreen(),

        '/DriverWelcome': (context) => const DriverWelcomeScreen(),
        '/PassengerWelcome': (context) => const WelcomeScreen(),
        
        '/Driverlogin': (context) => const DriverLoginScreen(),
        '/Passengerlogin': (context) => const LoginScreen(),


        '/Driverregister': (context) => const DriverRegisterScreen(),
        '/Passengerregister': (context) => const RegisterScreen(),

        '/Driverforgot_password': (context) => const DriverForgotPasswordScreen(),
        '/Passengerforgot_password': (context) => const ForgotPasswordScreen(),

        '/Driverotp': (context) => const DriverOtpVerificationScreen(),
        '/otp': (context) => const OtpVerificationScreen(),



        '/Drivercreate_password': (context) => const DriverCreateNewPasswordScreen(),
        '/create_password': (context) => const CreateNewPasswordScreen(),
        
        '/Driverhome': (context) => const DriverHomeScreen(), 
        '/home': (context) => const HomeScreen(), 
      },
    );
  }
}
