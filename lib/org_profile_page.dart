import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrgProfilePage extends StatefulWidget {
  @override
  _OrgProfilePageState createState() => _OrgProfilePageState();
}

class _OrgProfilePageState extends State<OrgProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _organizationName;
  String? _vision;
  String? _mission;
  bool _isDropdownVisible = false;

  // Form controllers for adding new details
  final TextEditingController _visionController = TextEditingController();
  final TextEditingController _missionController = TextEditingController();

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  Future<void> _fetchOrganizationDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('organizations').doc(user.uid).get();
      setState(() {
        _organizationName = doc['name'];
        _vision = doc['vision'];
        _mission = doc['mission'];
      });
    }
  }

  Future<void> _updateDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('organizations').doc(user.uid).update({
        'vision': _visionController.text,
        'mission': _missionController.text,
      });
      _fetchOrganizationDetails(); // Refresh details
      _visionController.clear();
      _missionController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrganizationDetails(); // Fetch initial organization details
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();
      _toggleDropdown(); // Close the dropdown after logout
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Display organization details
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: $_organizationName',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Vision: $_vision',
                              style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          Text('Mission: $_mission',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Form to add/update vision and mission
                  Text('Update Vision and Mission',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _visionController,
                    decoration: InputDecoration(labelText: 'New Vision'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _missionController,
                    decoration: InputDecoration(labelText: 'New Mission'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateDetails,
                    child: Text('Update'),
                  ),
                ],
              ),
            ),
          ),
          // Header
          Positioned(
            top: 22,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      // Handle menu action here
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          // Handle notifications action here
                        },
                      ),
                      GestureDetector(
                        onTap: _toggleDropdown,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage('https://via.placeholder.com/150'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Dropdown menu
          if (_isDropdownVisible)
            Positioned(
              top: 80,
              right: 16,
              child: Material(
                elevation: 5,
                child: Container(
                  width: 200,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Organization Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('organization@example.com',
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () {
                          _toggleDropdown();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          _toggleDropdown();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () {
                          _logout(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
