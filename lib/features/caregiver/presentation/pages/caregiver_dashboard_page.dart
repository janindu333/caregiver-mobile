import 'package:caregiver/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class CaregiverDashboardPage extends StatefulWidget {
  CaregiverDashboardPage({super.key});

  @override
  _CaregiverDashboardPageState createState() => _CaregiverDashboardPageState();
}

class _CaregiverDashboardPageState extends State<CaregiverDashboardPage> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      // style: DrawerStyle.defaultStyle,
      menuScreen: MenuScreen(),

      mainScreen: Scaffold(
        appBar: AppBar(
          title: const Text('Caregiver Dashboard'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _drawerController.toggle?.call();
            },
          ),
        ),
        body: GestureDetector(
          onTap: () async {
            bool? isDrawerOpen = await _drawerController.isOpen!();
            if (isDrawerOpen == true) {
              _drawerController.close?.call();
            }
          },
          child: const Center(
            child: Text('Welcome to the Caregiver Dashboard'),
          ),
        ),
      ),

      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      menuBackgroundColor: Colors.yellow[300]!,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
