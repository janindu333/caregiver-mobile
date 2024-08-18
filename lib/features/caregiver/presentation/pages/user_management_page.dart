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

  void _filterPatients(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPatientsByCareGiverId = _allPatientsByCareGiverId;
      });
    } else {
      setState(() {
        _filteredPatientsByCareGiverId = _allPatientsByCareGiverId.where((patient) {
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
    // Implement logic to show add patient dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Patient List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: widget.onMenuPressed,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a patient',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _filterPatients(value);
              },
            ),
            SizedBox(height: 20),
            // Assign Patient Button
            Center(
              child: ElevatedButton(
                onPressed: _showAddPatientDialog,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blue,
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
            // List of patients
            Expanded(
              child: _filteredPatientsByCareGiverId.isEmpty
                  ? Center(child: Text('No patients found'))
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
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              patientName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text('Condition: $patientCondition, Status: Good'), // Update the status field accordingly
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Handle view details action
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('View details'),
                                ),
                                SizedBox(width: 8),
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
            ),
          ],
        ),
      ),
    );
  }
}
