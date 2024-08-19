import 'package:caregiver/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';
import 'package:caregiver/features/patient/presentation/pages/patient_home_page.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, navigate to Login Page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // User is logged in, check their role
      _checkUserRole(user.uid);
    }
  }

  _checkUserRole(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      String role = userDoc['role'];

      if (role == 'patient') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PatientHomePage()));
      } else if (role == 'caregiver') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CaregiverDashboardPage()));
      } else if (role == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
      }
    } else {
      // Handle the case where the user does not have a role assigned
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E), // Updated background color to match login page
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // "Care Giver" text with a beautiful style
            Text(
              'Care Giver',
              style: TextStyle(
                color: Color(0xFF8E44AD), // Purple color to match the theme
                fontSize: 36, // Large font size
                fontWeight: FontWeight.bold, // Bold text
                letterSpacing: 2, // Spacing between letters for a modern look
                shadows: [
                  Shadow(
                    blurRadius: 10.0, // Soft shadow
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(5.0, 5.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Color(0xFF8E44AD), // Updated color of the loading indicator to match login page
            ),
          ],
        ),
      ),
    );
  }
}
