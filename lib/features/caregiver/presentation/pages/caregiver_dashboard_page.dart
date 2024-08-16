import 'package:caregiver/features/caregiver/presentation/pages/caregiver_main_screen.dart';
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
        menuScreen: MenuScreen(),
        mainScreen: CaregiverMainScreen(
          onMenuPressed: () {
            _drawerController.toggle?.call();
          },
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
}
