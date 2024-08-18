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
  TextEditingController _conditionController =
      TextEditingController(); // Add a controller for the condition field
  List<DocumentSnapshot> _allPatientsByCareGiverId = [];
  List<DocumentSnapshot> _filteredPatientsByCareGiverId = [];

  List<DocumentSnapshot> _allPatients = [];
  List<DocumentSnapshot> _filteredPatients = [];
  String? _selectedPatientId;

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

  void _fetchPatients() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Fetch all users where the role is "patient"
    QuerySnapshot querySnapshot =
        await users.where('role', isEqualTo: 'patient').get();

    setState(() {
      _allPatients = querySnapshot.docs;
      _filteredPatients = querySnapshot.docs;
    });
  }

  void _filterPatients(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPatients = _allPatients;
      });
    } else {
      setState(() {
        _filteredPatients = _allPatients.where((patient) {
          String name = (patient.data() as Map<String, dynamic>)['name'];
          return name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _addNewPatient(String patientId, String patientName, String condition,
      VoidCallback onSuccess) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    await patients.add({
      'name': patientName,
      'caregiverId': currentUser?.uid,
      'lastActivity': DateTime.now().toString(), // Example field
      'id': patientId, // Use the selected patient's ID
      'condition': condition, // Assign the condition here
    }).then((value) {
      // Call the onSuccess callback after successfully adding the patient
      onSuccess();
    }).catchError((error) {
      // Handle errors if needed
      print("Failed to add patient: $error");
    });

    _fetchPatientsByCareGiverId(); // Refresh the list of patients after adding a new one
  }

  void _deletePatient(String patientId) async {
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    await patients.doc(patientId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient deleted successfully')),
      );
      _fetchPatientsByCareGiverId(); // Refresh the list after deletion
    }).catchError((error) {
      print("Failed to delete patient: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient')),
      );
    });
  }

  void _showDeleteConfirmationDialog(String patientId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Patient'),
          content: Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog on Cancel
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePatient(patientId); // Delete the patient
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPatientDialog() {
    _fetchPatients(); // Fetch all patients when the dialog is opened

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Patient'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedPatientId,
                items: _filteredPatients.map((patient) {
                  var patientData = patient.data() as Map<String, dynamic>;
                  return DropdownMenuItem<String>(
                    value: patient.id,
                    child: Text(patientData['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPatientId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Select Patient',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller:
                    _conditionController, // Use the controller for condition input
                decoration: InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog on Cancel
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedPatientId != null) {
                  var selectedPatient = _filteredPatients.firstWhere(
                      (patient) => patient.id == _selectedPatientId);
                  var patientData =
                      selectedPatient.data() as Map<String, dynamic>;
                  _addNewPatient(
                    _selectedPatientId!,
                    patientData['name'],
                    _conditionController
                        .text, // Pass the condition to _addNewPatient
                    () {
                      // Callback function after success
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient added successfully')),
                      );
                    },
                  );
                  Navigator.of(context).pop(); // Close the dialog after saving
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.red,
      elevation: 0,
      title: const Text('User Management'),
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: widget.onMenuPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: _showAddPatientDialog, // Show the add patient form
        ),
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // Make the content scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Patients',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _filterPatients(value);
              },
            ),
            SizedBox(height: 20),

            // List of patients
            _filteredPatientsByCareGiverId.isEmpty
                ? Center(child: Text('No patients found'))
                : ListView.builder(
                    shrinkWrap: true, // Shrink the ListView to fit the content
                    physics: NeverScrollableScrollPhysics(), // Disable ListView's scrolling
                    itemCount: _filteredPatientsByCareGiverId.length,
                    itemBuilder: (context, index) {
                      var patientData = _filteredPatientsByCareGiverId[index]
                          .data() as Map<String, dynamic>;
                      String patientName = patientData['name'];
                      String patientId =
                          _filteredPatientsByCareGiverId[index].id;

                      return Card(
                        child: ListTile(
                          title: Text(patientName),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Navigate to Edit Patient Page
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(patientId);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    ),
  );
}



}
