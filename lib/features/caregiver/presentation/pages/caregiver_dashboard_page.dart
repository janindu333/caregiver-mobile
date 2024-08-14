import 'package:caregiver/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class CaregiverDashboardPage extends StatefulWidget {
  @override
  _CaregiverDashboardPageState createState() => _CaregiverDashboardPageState();
}

class _CaregiverDashboardPageState extends State<CaregiverDashboardPage> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: ZoomDrawer(
        controller: _drawerController,
        menuScreen: MenuScreen(), // This contains the menu items
        mainScreen: Scaffold(
          backgroundColor: Colors.red, // Transparent background
          appBar: AppBar(
            backgroundColor: Colors.red,
            elevation: 0,
            title: const Text('Home'),
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _drawerController.toggle?.call();
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDashboardCard('00', 'Requests'),
                    _buildDashboardCard('0', 'Events'),
                  ],
                ),
                SizedBox(height: 20),
                _buildSectionHeader('Current Requests', () {
                  // Handle "View All" tap
                }),
                // Add a list or GridView for Current Requests here
                SizedBox(height: 20),
                _buildSectionHeader('Featured Events', () {
                  // Handle "View All" tap
                }),
                // Add a list or GridView for Featured Events here
              ],
            ),
          ),
        ),
        borderRadius: 24.0,
        showShadow: true,
        angle: 0.0,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      ),
    );
  }

  Widget _buildDashboardCard(String value, String label) {
    return Card(
      color: Colors.white, // Set a light color for contrast with the gradient
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text("View All"),
        ),
      ],
    );
  }
}
