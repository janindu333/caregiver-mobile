import 'package:caregiver/features/caregiver/presentation/pages/caregiver_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:caregiver/menu_screen.dart';
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
        return Center(
          child: Text(
            'Activity Log Page Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
      case 'Profile Management':
        return Center(
          child: Text(
            'Profile Management Page Coming Soon',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
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
        color: Color(0xFF1E1E2E), // Dark Gray Background (same as MenuScreen)
      ),
      child: ZoomDrawer(
        controller: _drawerController,
        menuScreen: MenuScreen(
          onMenuItemSelected: (String page) {
            setState(() {
              _selectedPage = page;
            });
            _drawerController.toggle
                ?.call(); // Close the drawer after selection
          },
        ),
        mainScreen: _getScreen(_selectedPage),
        borderRadius: 24.0,
        showShadow: true,
        shadowLayer1Color: Colors.black.withOpacity(0.3),
        shadowLayer2Color: Colors.black.withOpacity(0.1),
        angle: 0.0,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.fastOutSlowIn,
      ),
    );
  }
}
