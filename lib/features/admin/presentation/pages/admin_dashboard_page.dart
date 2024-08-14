import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to the Caregiver Dashboard'),
      ),
    );
  }
}
