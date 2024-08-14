import 'package:caregiver/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caregiver/my_drawer_controller.dart';

class MenuScreen extends GetView<MyDrawerController> {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      // Add Material widget here
      child: Container(
        color: Colors.yellow, // Background color of the menu
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage(
                          'assets/profile_picture.png'), // Replace with your asset
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'User Name', // Replace with the actual user name
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'user@example.com', // Replace with the actual email
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.black54),
              _buildMenuItem(Icons.home, 'Home', () {
                controller.toggleDrawer();
                Get.to(() => MainScreen());
              }),
              _buildMenuItem(Icons.bloodtype, 'Request Blood', () {
                controller.toggleDrawer();
                // Implement navigation here
              }),
              _buildMenuItem(Icons.event, 'Post an Event', () {
                controller.toggleDrawer();
                // Implement navigation here
              }),
              _buildMenuItem(Icons.help, 'Help', () {
                controller.toggleDrawer();
                // Implement navigation here
              }),
              _buildMenuItem(Icons.settings, 'Settings', () {
                controller.toggleDrawer();
                // Implement navigation here
              }),
              Spacer(),
              _buildMenuItem(Icons.logout, 'Logout', () {
                controller.toggleDrawer();
                // Implement logout here
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }
}
