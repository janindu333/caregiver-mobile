import 'package:flutter/material.dart';

class PatientHomePage extends StatelessWidget {
  const PatientHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        title: Text('Patient needs'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What do you need?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildOptionCard(
                    context,
                    icon: Icons.restaurant,
                    title: 'Food',
                    subtitle: 'Have a meal',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.local_drink,
                    title: 'Drink',
                    subtitle: 'Stay hydrated',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.wc,
                    title: 'Bathroom',
                    subtitle: 'Use the bathroom',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.chat_bubble_outline,
                    title: 'Feelings',
                    subtitle: 'Need to talk',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.healing,
                    title: 'Pain',
                    subtitle: 'I\'m in pain',
                  ),
                  _buildOptionCard(
                    context,
                    icon: Icons.medication,
                    title: 'Medicine',
                    subtitle: 'Need medicine',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Call for help action
                },
                child: Text('Call for help'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context,
      {required IconData icon, required String title, required String subtitle}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // Handle option selection
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
