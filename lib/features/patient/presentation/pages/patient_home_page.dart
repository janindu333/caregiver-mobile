import 'package:caregiver/features/auth/data/data_sources/auth_service.dart';
import 'package:caregiver/features/auth/presentation/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientHomePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  PatientHomePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getPatientInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF626A74), // Updated to Gray
        leading: null,
        title: FutureBuilder<Map<String, dynamic>?>(
          future: _getPatientInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error', style: TextStyle(color: Colors.white));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('Patient Needs',
                  style: TextStyle(color: Colors.white));
            } else {
              final patientData = snapshot.data!;
              final patientUniqueId = patientData['patientUniqueId'] ?? 'N/A';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, ${patientData['name'] ?? 'Patient'}',
                      style: TextStyle(color: Colors.white)),
                  Text('Unique ID: $patientUniqueId',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      )),
                ],
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
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
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.7,
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
          ],
        ),
      ),
      backgroundColor: Color(0xFF626A74), // Updated to Gray
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required String needType}) {
    return SizedBox(
      height: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color(0xFF1E1E2E),
        child: InkWell(
          onTap: () async {
            await _handleNeedSelection(context, needType);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 100,
                  color: Color(0xFF11B3C6),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleNeedSelection(
      BuildContext context, String needType) async {
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

  Future<void> _sendPushNotification(
      String caregiverId, String needType) async {
    try {
      final tokenSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(caregiverId)
          .get();

      if (tokenSnapshot.exists) {
        final fcmToken = tokenSnapshot.data()?['fcmToken'];

        if (fcmToken != null) {
          final String apiUrl =
              'https://sleepy-earth-25719-ff687c3d2faa.herokuapp.com/send-notification';

          final Map<String, dynamic> data = {
            "token": fcmToken,
            "title": "Patient Needs Help",
            "body": "The patient has requested $needType.",
            "data": {
              "click_action": "CAREGIVE NOTIFICATION",
              "need_type": needType
            }
          };

          final response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
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
