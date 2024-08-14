import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caregiver/my_drawer_controller.dart';

class MainScreen extends GetView<MyDrawerController> {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            controller.toggleDrawer();
          },
        ),
        backgroundColor: Colors.red, // Match the color with your screenshot
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Requests', '00'),
                _buildStatCard('Events', '00'),
              ],
            ),
            SizedBox(height: 20.0),
            _buildSectionTitle('Current Requests', 'View All'),
            SizedBox(height: 10.0),
            _buildPlaceholderCard(),
            SizedBox(height: 20.0),
            _buildSectionTitle('Featured Events', 'View All'),
            SizedBox(height: 10.0),
            _buildPlaceholderCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle "View All" action
          },
          child: Text(
            actionText,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      height: 120.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: Icon(
          Icons.image,
          size: 50.0,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
