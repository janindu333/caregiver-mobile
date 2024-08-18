import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text('Patient needs'),
        centerTitle: true,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Call for help action
                },
                child: Text('Call for help'),
              ),
            ),
          ],
        ),
      ),
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
                color: Theme.of(context).primaryColor,
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey,
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
      // Create a notification record in Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'caregiverId': 'KhVyGEWErOVFe0uU4gehsdf6qVD3', // Replace with actual caregiver ID
        'patientId': 'patient2', // Replace with actual patient ID
        'title': 'Patient needs help',
        'body': 'The patient has requested $needType.',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request for $needType sent successfully.')),
      );

      // Optionally, trigger Firebase Cloud Messaging to send a push notification
      // Note: Firebase Cloud Messaging setup is required to use this feature.
      // await _sendPushNotification(needType);

    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
  }

  Future<void> _sendPushNotification(String needType) async {
    // Implement Firebase Cloud Messaging push notification logic here
    // You can send a message using Firebase Admin SDK on your server side
  }
}
