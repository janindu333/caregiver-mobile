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
  TextEditingController _conditionController = TextEditingController();
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
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

    QuerySnapshot querySnapshot = await patients.where('caregiverId', isEqualTo: currentUser?.uid).get();

    setState(() {
      _allPatientsByCareGiverId = querySnapshot.docs;
      _filteredPatientsByCareGiverId = querySnapshot.docs;
    });
  }

  void _fetchPatients() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    QuerySnapshot querySnapshot = await users.where('role', isEqualTo: 'patient').get();

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

  void _addNewPatient(String patientId, String patientName, String condition, VoidCallback onSuccess) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

    await patients.add({
      'name': patientName,
      'caregiverId': currentUser?.uid,
      'lastActivity': DateTime.now().toString(),
      'id': patientId,
      'condition': condition,
    }).then((value) {
      onSuccess();
    }).catchError((error) {
      print("Failed to add patient: $error");
    });

    _fetchPatientsByCareGiverId();
  }

  void _deletePatient(String patientId) async {
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');

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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePatient(patientId);
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPatientDialog() {
    _fetchPatients();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Assign Patient'),
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
                controller: _conditionController,
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedPatientId != null) {
                  var selectedPatient = _filteredPatients.firstWhere(
                      (patient) => patient.id == _selectedPatientId);
                  var patientData = selectedPatient.data() as Map<String, dynamic>;
                  _addNewPatient(
                    _selectedPatientId!,
                    patientData['name'],
                    _conditionController.text,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Patient assigned successfully')),
                      );
                    },
                  );
                  Navigator.of(context).pop();
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
        backgroundColor: Color(0xFF1E1E2E), // Updated to match login page color
        elevation: 0,
        title: const Text(
          'Patient List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Updated text color to white
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Updated icon color to white
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
                prefixIcon: Icon(Icons.search, color: Colors.white70), // Updated icon color
                filled: true,
                fillColor: Colors.black.withOpacity(0.2), // Updated to match login page color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _filterPatients(value);
              },
              style: TextStyle(color: Colors.white), // Updated text color
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _showAddPatientDialog,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Color(0xFF8E44AD), // Updated button color to match login page
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
                  ? Center(child: Text('No patients found', style: TextStyle(color: Colors.white70))) // Updated text color
                  : ListView.builder(
                      itemCount: _filteredPatientsByCareGiverId.length,
                      itemBuilder: (context, index) {
                        var patientData = _filteredPatientsByCareGiverId[index].data() as Map<String, dynamic>;
                        String patientName = patientData['name'];
                        String patientCondition = patientData['condition'] ?? '';
                        String patientId = _filteredPatientsByCareGiverId[index].id;

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          color: Color(0xFF1E1E2E), // Updated card background color to match login page
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              patientName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white, // Updated text color
                              ),
                            ),
                            subtitle: Text(
                              'Condition: $patientCondition',
                              style: TextStyle(color: Colors.white70), // Updated text color
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.white70), // Updated icon color
                                  onPressed: () {
                                    // Navigate to Edit Patient Page
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white70), // Updated icon color
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
            ),
          ],
        ),
      ),
    );
  }
}
