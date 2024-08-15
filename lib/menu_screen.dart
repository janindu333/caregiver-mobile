import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:caregiver/features/auth/data/data_sources/auth_service.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';

class MenuScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  final widthBox = SizedBox(
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    final TextStyle androidStyle = const TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
    final TextStyle iosStyle = const TextStyle(
        fontSize: 18, fontWeight: FontWeight.normal, color: Colors.white);
    final style = kIsWeb
        ? androidStyle
        : Platform.isAndroid
            ? androidStyle
            : iosStyle;

    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to see gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFb71c1c),
              Color(0xFF880e4f),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 20.0, horizontal: 10.0), // Reduced horizontal padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome",
                  style: style.copyWith(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 0.0), // Move the text more to the left
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Dashboard",
                    style: style,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaregiverDashboardPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 0.0), // Move the text more to the left
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Real-Time Monitoring",
                    style: style,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaregiverDashboardPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 0.0), // Move the text more to the left
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Activity Log",
                    style: style,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaregiverDashboardPage()),
                    );
                  },
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.only(
                      left: 0.0), // Move the text more to the left
                  leading: Icon(Icons.home, color: Colors.white),
                  title: Text(
                    "Profile Management",
                    style: style,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaregiverDashboardPage()),
                    );
                  },
                ),
                SizedBox(
                    height:
                        40), // Adds some space between the menu items and the logout button
                Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      await _authService.signOut(); // Perform logout
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      ); // Navigate to LoginPage after logout
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      backgroundColor: Colors.transparent, // Transparent background
                    ),
                    child: Text(
                      "Logout",
                      style: style.copyWith(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
