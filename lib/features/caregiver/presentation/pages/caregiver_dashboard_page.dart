import 'package:caregiver/features/caregiver/presentation/pages/caregiver_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:caregiver/menu_screen.dart';
import 'package:caregiver/features/caregiver/presentation/pages/caregiver_dashboard_page.dart';
import 'package:caregiver/features/caregiver/presentation/pages/user_management_page.dart'; 

class CaregiverDashboardPage extends StatefulWidget {
  @override
  _CaregiverDashboardPageState createState() => _CaregiverDashboardPageState();
}

class _CaregiverDashboardPageState extends State<CaregiverDashboardPage> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  // This variable will track which page is currently selected
  String _selectedPage = 'Dashboard';

  // A method to return the correct screen based on the selected page
  Widget _getScreen(String page) {
    switch (page) {
      case 'User Management':
       
           return UserManagementPage(
          onMenuPressed: () {
            _drawerController.toggle?.call();
          },
        );
      case 'Activity Log':
        // return ActivityLogPage();
      case 'Profile Management':
        // return ProfileManagementPage();
      default:
        return CaregiverMainScreen(
          onMenuPressed: () {
            _drawerController.toggle?.call();
          },
        );
    }
  }

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
        menuScreen: MenuScreen(
          onMenuItemSelected: (String page) {
            setState(() {
              _selectedPage = page;
            });
            _drawerController.toggle?.call(); // Close the drawer after selection
          },
        ),
        mainScreen: _getScreen(_selectedPage),
        borderRadius: 24.0,
        showShadow: true,
        angle: 0.0,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      ),
    );
  }
}
