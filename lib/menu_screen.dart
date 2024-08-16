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
          child: SingleChildScrollView(
            // Wrapping the Column with SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0), // Reduced horizontal padding
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
                    style: style.copyWith(
                        fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 20),

                  // Dashboard
                  ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 0.0), // Move the text more to the left
                    leading: Icon(Icons.dashboard, color: Colors.white),
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

                  // Real-Time Monitoring
                  ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 0.0), // Move the text more to the left
                    leading: Icon(Icons.timeline, color: Colors.white),
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

                  // Activity Log
                  ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 0.0), // Move the text more to the left
                    leading: Icon(Icons.history, color: Colors.white),
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

                  // User Management
                  ExpansionTile(
                    leading: Icon(Icons.people, color: Colors.white),
                    title: Text(
                      "User Management",
                      style: style,
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "View Users",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to View Users Page
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Add New User",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Add New User Page
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Edit User",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Edit User Page
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Remove User",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Remove User Page
                        },
                      ),
                    ],
                  ),

                  // Profile Management
                  ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 0.0), // Move the text more to the left
                    leading: Icon(Icons.person, color: Colors.white),
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

                  // Help & Support
                  ExpansionTile(
                    leading: Icon(Icons.help, color: Colors.white),
                    title: Text(
                      "Help & Support",
                      style: style,
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Documentation",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Documentation Page
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Support Contact",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Support Contact Page
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Feedback",
                          style: style,
                        ),
                        onTap: () {
                          // Navigate to Feedback Page
                        },
                      ),
                    ],
                  ),

                  // Emergency Contact
                  ListTile(
                    contentPadding: EdgeInsets.only(
                        left: 0.0), // Move the text more to the left
                    leading: Icon(Icons.phone_in_talk, color: Colors.white),
                    title: Text(
                      "Emergency Contact",
                      style: style,
                    ),
                    onTap: () {
                      // Navigate to Emergency Contact Page
                    },
                  ),

                  SizedBox(
                      height:
                          40), // Adds some space between the menu items and the logout button

                  // Logout Button
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        backgroundColor:
                            Colors.transparent, // Transparent background
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
      ),
    );
  }
}
