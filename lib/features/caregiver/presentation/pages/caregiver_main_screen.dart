import 'package:flutter/material.dart';

class CaregiverMainScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const CaregiverMainScreen({required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: onMenuPressed,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Overview Section
            Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.red[50],
              child: ListTile(
                title: Text(
                  'Summary of assigned users and recent activities',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.person, color: Colors.red),
              ),
            ),
            SizedBox(height: 20),

            // Recent Notifications Section
            Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.yellow[50],
              child: ListTile(
                title: Text(
                  'Quick access to the latest notifications and alerts',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.notifications, color: Colors.yellow[700]),
              ),
            ),
            SizedBox(height: 20),

            // User Summary Section
            Text(
              'User Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.blue[50],
              child: ListTile(
                title: Text(
                  'Overview of all users assigned to the caregiver',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.group, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
