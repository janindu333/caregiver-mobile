import 'dart:io';
import 'package:caregiver/features/auth/data/data_sources/auth_service.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  final Function(String) onMenuItemSelected;

  MenuScreen({required this.onMenuItemSelected});

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

    // Get the current user's email
    final email = _authService.getCurrentUser()?.email ?? 'No email available';

    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E), // Dark Gray Background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Profile Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/user.png'),
                  backgroundColor:
                      Colors.grey.shade800, // Consistent with grayscale
                ),
                SizedBox(height: 20),
                // Welcome Text
                Text(
                  "Welcome",
                  style: style.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                // Email Text
                Text(
                  email,
                  style: style.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white70),
                ),
                SizedBox(height: 20),

                // Dashboard Menu Item
                ListTile(
                  contentPadding: EdgeInsets.only(left: 0.0),
                  leading: Icon(Icons.dashboard,
                      color: Color(0xFF11B3C6)), // Blue Icon
                  title: Text(
                    "Dashboard",
                    style: style,
                  ),
                  onTap: () {
                    onMenuItemSelected('Dashboard');
                  },
                ),

                // User Management Menu Item
                ListTile(
                  contentPadding: EdgeInsets.only(left: 0.0),
                  leading:
                      Icon(Icons.people, color: Color(0xFF11B3C6)), // Blue Icon
                  title: Text(
                    "User Management",
                    style: style,
                  ),
                  onTap: () {
                    onMenuItemSelected('User Management');
                  },
                ),

                // Logout Button
                Center(
                  child: OutlinedButton(
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Color(0xFF11B3C6), width: 2.0), // Blue Outline
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      "Logout",
                      style: style.copyWith(
                        fontSize: 18,
                        color: Color(0xFF11B3C6), // Blue Text
                      ),
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
