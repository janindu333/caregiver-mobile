import 'package:caregiver/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';
import 'package:caregiver/features/patient/presentation/pages/patient_home_page.dart';
import 'package:caregiver/features/splash/presentation/pages/splash_screen.dart';
import 'package:caregiver/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeSensory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner:
          false, // Add this line to remove the debug banner
      routes: {
        '/admin_dashboard': (context) => AdminDashboardPage(),
        '/caregiver_dashboard': (context) => CaregiverDashboardPage(),
        '/patient_dashboard': (context) => PatientHomePage(),
      },
    );
  }
}
