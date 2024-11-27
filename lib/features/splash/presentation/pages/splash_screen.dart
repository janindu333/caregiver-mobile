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
    await Future.delayed(const Duration(seconds: 3), () {}); // Simulate loading
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, navigate to Login Page
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // User is logged in, check their role
      _checkUserRole(user.uid);
    }
  }

  _checkUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          String? role = data['role']; // Safely access the 'role' field

          if (role == 'patient') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PatientHomePage()));
          } else if (role == 'caregiver') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CaregiverDashboardPage()));
          } else if (role == 'admin') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminDashboardPage()));
          } else {
            // Handle unrecognized role
            print("Unrecognized role: $role for user: $userId");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          }
        } else {
          // If data is null, navigate to LoginPage
          print("User data is null for user: $userId");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } else {
        // Handle the case where the document does not exist
        print("User document does not exist: $userId");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print("Error checking user role: $e");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(98, 106, 116, 1), // Grey Background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // "Care Giver" text with a beautiful style
            Text(
              'Care Giver',
              style: TextStyle(
                color: Color.fromRGBO(17, 179, 198, 1), // Blue Text
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
              color: Color.fromRGBO(17, 179, 198, 1), // Blue Loading Indicator
            ),
          ],
        ),
      ),
    );
  }
}
