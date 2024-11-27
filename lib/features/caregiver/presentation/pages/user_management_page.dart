import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  final VoidCallback onMenuPressed;

  const UserManagementPage({required this.onMenuPressed});

  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _allPatientsByCareGiverId = [];
  List<DocumentSnapshot> _filteredPatientsByCareGiverId = [];

  @override
  void initState() {
    super.initState();
    _fetchPatientsByCareGiverId();
  }

  void _fetchPatientsByCareGiverId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    QuerySnapshot querySnapshot =
        await patients.where('caregiverId', isEqualTo: currentUser?.uid).get();

    setState(() {
      _allPatientsByCareGiverId = querySnapshot.docs;
      _filteredPatientsByCareGiverId = querySnapshot.docs;
    });
  }

  void _showAssignPatientDialog() {
    TextEditingController patientIdController = TextEditingController();
    TextEditingController conditionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Assign Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientIdController,
                decoration: InputDecoration(
                  labelText: 'Enter Patient Unique ID',
                  filled: true,
                  fillColor: Color.fromRGBO(98, 106, 116, 0.2), // Grey
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: conditionController,
                decoration: InputDecoration(
                  labelText: 'Condition',
                  filled: true,
                  fillColor: Color.fromRGBO(98, 106, 116, 0.2), // Grey
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String patientUniqueId = patientIdController.text.trim();
                String condition = conditionController.text.trim();

                if (patientUniqueId.isNotEmpty && condition.isNotEmpty) {
                  await _addPatientByUniqueId(patientUniqueId, condition);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid ID and condition.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(17, 179, 198, 1), // Blue
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addPatientByUniqueId(
      String patientUniqueId, String condition) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      // Check if the unique ID exists in the users collection
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('patientUniqueId', isEqualTo: patientUniqueId)
          .get();

      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid Patient ID.')),
        );
        return;
      }

      DocumentSnapshot patientDoc = userSnapshot.docs.first;
      Map<String, dynamic> patientData =
          patientDoc.data() as Map<String, dynamic>;

      // Check if the patient already has a caregiver assigned
      QuerySnapshot assignedSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('id', isEqualTo: patientDoc.id)
          .get();

      if (assignedSnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This patient is already assigned.')),
        );
        return;
      }

      // Add the patient to the caregiver
      await FirebaseFirestore.instance.collection('patients').add({
        'id': patientDoc.id,
        'name': patientData['name'],
        'caregiverId': currentUser?.uid,
        'condition': condition,
        'lastActivity': DateTime.now().toString(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient assigned successfully.')),
      );

      _fetchPatientsByCareGiverId();
    } catch (e) {
      print('Error assigning patient: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign patient. Please try again.')),
      );
    }
  }

  void _deletePatient(String patientId) async {
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    await patients.doc(patientId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient deleted successfully')),
      );
      _fetchPatientsByCareGiverId();
    }).catchError((error) {
      print("Failed to delete patient: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(98, 106, 116, 1), // Grey
        elevation: 0,
        title: const Text(
          'Patient List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a patient',
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Color.fromRGBO(98, 106, 116, 0.2), // Grey
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showAssignPatientDialog,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Color.fromRGBO(17, 179, 198, 1), // Blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Assign Patient',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _filteredPatientsByCareGiverId.isEmpty
                  ? Center(
                      child: Text(
                        'No patients found',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredPatientsByCareGiverId.length,
                      itemBuilder: (context, index) {
                        var patientData = _filteredPatientsByCareGiverId[index]
                            .data() as Map<String, dynamic>;
                        String patientName = patientData['name'];
                        String patientCondition =
                            patientData['condition'] ?? '';
                        String patientId =
                            _filteredPatientsByCareGiverId[index].id;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          color: Color.fromRGBO(98, 106, 116, 1), // Grey
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              patientName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              'Condition: $patientCondition',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deletePatient(patientId);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
