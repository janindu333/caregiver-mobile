import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Patient Home Page'),
      ),
    );
  }
}
