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
    CollectionReference patients =
        FirebaseFirestore.instance.collection('patients');

    QuerySnapshot querySnapshot =
        await patients.where('caregiverId', isEqualTo: currentUser?.uid).get();

    setState(() {
      _allPatientsByCareGiverId = querySnapshot.docs;
      _filteredPatientsByCareGiverId = querySnapshot.docs;
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
        backgroundColor: Color(0xFF1E1E2E), // Dark Gray Background
        elevation: 0,
        title: const Text(
          'Patient List',
          style: TextStyle(
            color: Colors.white, // White Text
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
                fillColor:
                    Colors.black.withOpacity(0.2), // Match Login Page Style
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                _filterPatients(value);
              },
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _fetchPatientsByCareGiverId,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Color(0xFF11B3C6), // Blue Button Color
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
                          color: Color(0xFF1E1E2E), // Dark Gray Card Background
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
