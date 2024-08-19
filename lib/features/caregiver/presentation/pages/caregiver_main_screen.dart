import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CaregiverMainScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const CaregiverMainScreen({required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E), // Same background color as before
        elevation: 0,
        title: const Text('Dashboard',
            style:
                TextStyle(color: Colors.white)), // Set the title color to white
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: Colors.white), // Set the hamburger icon color to white
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
                  color: Color(0xFF8E44AD), // Updated to match login page color
                ),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: patients
                    .where('caregiverId', isEqualTo: currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  print('User UID: ${currentUser?.uid}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Card(
                      color: Color(0xFF1E1E2E), // Updated background color
                      child: ListTile(
                        title: Text(
                          'No assigned patients found.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        leading: Icon(Icons.person_off,
                            color: Color(0xFF8E44AD)), // Updated icon color
                      ),
                    );
                  }
                  var patientsList = snapshot.data!.docs;
                  return Column(
                    children: patientsList.map((patient) {
                      var patientData = patient.data() as Map<String, dynamic>;
                      return Card(
                        color: Color(0xFF1E1E2E), // Updated background color
                        child: ListTile(
                          title: Text(
                            '${patientData['name']}',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          subtitle: Text(
                            'Condition: ${patientData['condition']}\nLast Activity: ${patientData['lastActivity']}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          leading: Icon(Icons.person,
                              color: Color(0xFF8E44AD)), // Updated icon color
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
                  color: Color(0xFF8E44AD), // Updated to match login page color
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
                  print('Current user UID: ${currentUser?.uid}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Card(
                      color: Color(0xFF1E1E2E), // Updated background color
                      child: ListTile(
                        title: Text(
                          'No recent notifications found.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        leading: Icon(Icons.notifications_off,
                            color: Color(0xFF8E44AD)), // Updated icon color
                      ),
                    );
                  }
                  var notifications = snapshot.data!.docs;
                  return Column(
                    children: notifications.map((notification) {
                      var notificationData =
                          notification.data() as Map<String, dynamic>;
                      String patientId = notificationData['patientId'];

                      // Fetch the patient's name based on the patient `id` field, not the document ID
                      return FutureBuilder<QuerySnapshot>(
                        future:
                            patients.where('id', isEqualTo: patientId).get(),
                        builder: (context, patientSnapshot) {
                          if (patientSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!patientSnapshot.hasData ||
                              patientSnapshot.data!.docs.isEmpty) {
                            print(
                                'Patient document does not exist for ID: $patientId');
                            return Card(
                              color:
                                  Color(0xFF1E1E2E), // Updated background color
                              child: ListTile(
                                title: Text(
                                  '${notificationData['title']}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Patient not found',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white70),
                                ),
                                leading: Icon(Icons.notifications,
                                    color: Color(
                                        0xFF8E44AD)), // Updated icon color
                              ),
                            );
                          }
                          var patientData = patientSnapshot.data!.docs.first
                              .data() as Map<String, dynamic>;
                          String patientName = patientData['name'];

                          return Card(
                            color:
                                Color(0xFF1E1E2E), // Updated background color
                            child: ListTile(
                              title: Text(
                                '${notificationData['title']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              subtitle: Text(
                                '${notificationData['body']} - Patient: $patientName',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white70),
                              ),
                              leading: Icon(Icons.notifications,
                                  color:
                                      Color(0xFF8E44AD)), // Updated icon color
                            ),
                          );
                        },
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
