import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:caregiver/menu_screen.dart';
import 'package:caregiver/my_drawer_controller.dart';
import 'package:caregiver/main_screen.dart';

class CaregiverDashboardPage extends GetView<MyDrawerController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDrawerController>(
      builder: (_) => ZoomDrawer(
        controller: _.zoomDrawerController,
        menuScreen: MenuScreen(), // Updated MenuScreen with menu items
        mainScreen: MainScreen(), // Main screen with your content
        borderRadius: 24.0,
        showShadow: true,
        angle: -12.0,
        menuBackgroundColor: Colors.yellow,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
      ),
    );
  }
}
