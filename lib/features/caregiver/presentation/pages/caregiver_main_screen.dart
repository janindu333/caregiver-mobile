import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class CaregiverMainScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const CaregiverMainScreen({required this.onMenuPressed});

  // Function to format timestamps into readable dates
  String formatDate(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return timestamp; // If parsing fails, return the original string
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E), // Dark Gray Background
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white, // White Text
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // White Icon
          onPressed: onMenuPressed,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Overview Section
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E44AD), // Purple Accent
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: patients
                    .where('caregiverId', isEqualTo: currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Card(
                      color: Color(0xFF1E1E2E), // Dark Gray Background
                      child: ListTile(
                        title: Text(
                          'No assigned patients found.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        leading: Icon(Icons.person_off,
                            color: Color(0xFF8E44AD)), // Purple Accent Icon
                      ),
                    );
                  }
                  var patientsList = snapshot.data!.docs;
                  return Column(
                    children: patientsList.map((patient) {
                      var patientData = patient.data() as Map<String, dynamic>;
                      return Card(
                        color: Color(0xFF1E1E2E), // Dark Gray Background
                        child: ListTile(
                          title: Text(
                            '${patientData['name']}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            'Condition: ${patientData['condition']}\nLast Activity: ${formatDate(patientData['lastActivity'])}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          leading: Icon(Icons.person,
                              color: Color(0xFF8E44AD)), // Purple Accent Icon
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),

              // Recent Notifications Section
              Text(
                'Recent Notifications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8E44AD), // Purple Accent
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('caregiverId', isEqualTo: currentUser?.uid)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Card(
                      color: Color(0xFF1E1E2E), // Dark Gray Background
                      child: ListTile(
                        title: Text(
                          'No recent notifications found.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        leading: Icon(Icons.notifications_off,
                            color: Color(0xFF8E44AD)), // Purple Accent Icon
                      ),
                    );
                  }
                  var notifications = snapshot.data!.docs;
                  return Column(
                    children: notifications.map((notification) {
                      var notificationData =
                          notification.data() as Map<String, dynamic>;
                      return Card(
                        color: Color(0xFF1E1E2E), // Dark Gray Background
                        child: ListTile(
                          title: Text(
                            '${notificationData['title']}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            '${notificationData['body']}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          leading: Icon(Icons.notifications,
                              color: Color(0xFF8E44AD)), // Purple Accent Icon
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
