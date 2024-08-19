import 'package:caregiver/features/auth/data/data_sources/auth_service.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientHomePage extends StatelessWidget {
  final AuthService _authService = AuthService(); // Initialize AuthService

  PatientHomePage({Key? key}) : super(key: key);

  // Method to fetch the logged-in user's username
  Future<String?> _getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users') // Assuming user data is stored in 'users' collection
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['email']; // Replace 'username' with the actual field name
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E), // Match the dark gradient from the login screen
        leading: null, // Remove the back button by setting leading to null
        title: FutureBuilder<String?>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text('Error', style: TextStyle(color: Colors.white));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('Patient Needs', style: TextStyle(color: Colors.white));
            } else {
              return Text('Welcome, ${snapshot.data}', style: TextStyle(color: Colors.white));
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // Update icon color to white
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What do you need?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Updated text color to white
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildOptionCard(
                    context,
                    icon: Icons.restaurant,
                    title: 'Food',
                    subtitle: 'Have a meal',
                    needType: 'food',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.local_drink,
                    title: 'Drink',
                    subtitle: 'Stay hydrated',
                    needType: 'drink',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.wc,
                    title: 'Bathroom',
                    subtitle: 'Use the bathroom',
                    needType: 'bathroom',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: 'Feelings',
                    subtitle: 'Need to talk',
                    needType: 'feelings',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.healing,
                    title: 'Pain',
                    subtitle: 'I\'m in pain',
                    needType: 'pain',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.medication,
                    title: 'Medicine',
                    subtitle: 'Need medicine',
                    needType: 'medicine',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Handle Call for help action
            //     },
            //     child: Text('Call for help'),
            //   ),
            // ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF1E1E2E), // Match the background color to the login screen's dark gradient
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String needType}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Color(0xFF1E1E2E), // Match the card background color to the login screen's dark gradient
      child: InkWell(
        onTap: () async {
          await _handleNeedSelection(context, needType);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Color(0xFF8E44AD), // Use the purple color for the icons
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Updated text color to white
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70, // Updated subtitle color to a lighter shade of white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleNeedSelection(BuildContext context, String needType) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final patientId = user.uid;

        final patientQuerySnapshot = await FirebaseFirestore.instance
            .collection('patients')
            .where('id', isEqualTo: patientId)
            .limit(1)
            .get();

        if (patientQuerySnapshot.docs.isNotEmpty) {
          final patientDoc = patientQuerySnapshot.docs.first;
          final caregiverId = patientDoc.data()['caregiverId'];

          await FirebaseFirestore.instance.collection('notifications').add({
            'caregiverId': caregiverId,
            'patientId': patientId,
            'title': 'Patient needs help',
            'body': 'The patient has requested $needType.',
            'timestamp': FieldValue.serverTimestamp(),
          });

          await _sendPushNotification(caregiverId, needType);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request for $needType sent successfully.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to find caregiver information.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  Future<void> _sendPushNotification(String caregiverId, String needType) async {
    try {
      // Retrieve the caregiver's FCM token from Firestore
      final tokenSnapshot = await FirebaseFirestore.instance
          .collection('users') // Assuming there's a 'users' collection with FCM tokens
          .doc(caregiverId)
          .get();

      if (tokenSnapshot.exists) {
        final fcmToken = tokenSnapshot.data()?['fcmToken'];

        if (fcmToken != null) {
          // Construct the notification payload
          final data = {
            'to': fcmToken,
            'notification': {
              'title': 'Patient Needs Help',
              'body': 'The patient has requested $needType.',
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'need_type': needType,
            },
          };

          // Send the notification using HTTP POST to FCM endpoint
          final response = await http.post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'key=AIzaSyCJ_g2UrZoeRiC1Xb6QPykbyuD-q-tZBZc',  // Replace with your FCM server key
            },
            body: jsonEncode(data),
          );

          if (response.statusCode == 200) {
            print('Notification sent successfully');
          } else {
            print('Failed to send notification: ${response.statusCode}');
            print('Response body: ${response.body}');
          }
        } else {
          print('No FCM token found for caregiver');
        }
      } else {
        print('No such document exists!');
      }
    } catch (e) {
      print('Failed to send push notification: $e');
    }
  }
}
