// import 'package:caregiver/features/admin/presentation/pages/admin_dashboard_page.dart';
// import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';
// import 'package:caregiver/features/auth/presentation/pages/loginpage.dart';
import 'package:caregiver/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
          // ignore: use_build_context_synchronously
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
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const PatientHomePage()));
      } else if (role == 'caregiver') {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context, MaterialPageRoute(builder: (context) =>  CaregiverDashboardPage()));
      } else if (role == 'admin') {
        Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
      }
    } else {
      // Handle the case where the user does not have a role assigned
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: const Center(
//         child: Text('Login Page'),
//       ),
//     );
//   }
// }

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Patient Home Page'),
      ),
    );
  }
}
