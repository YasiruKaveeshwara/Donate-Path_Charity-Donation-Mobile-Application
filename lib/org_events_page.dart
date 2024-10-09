import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'org_request_form.dart'; // Import your org_request_form.dart
import 'org_event_request_page.dart'; // Import your Events Page
import 'org_topVolunteers_page.dart'; // Import your Top Volunteers Page

class OrgEventsPage extends StatefulWidget {
  @override
  _OrgEventsPageState createState() => _OrgEventsPageState();
}

class _OrgEventsPageState extends State<OrgEventsPage> {
  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
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
                children: [
                  // Organized Events Container
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Organized Events',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Space between sections

                  // Picture buttons for Events and Top Volunteers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EventRequestsPage(), // Navigate to Events Page
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://via.placeholder.com/150?text=Events'), // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Events', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Space between buttons
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TopVolunteersPage(), // Navigate to Top Volunteers Page
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://via.placeholder.com/150?text=Top+Volunteers'), // Replace with your image
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Top Volunteers',
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // More content...
                ],
              ),
            ),
          ),
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
                        child: Text('John Doe',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('john.doe@example.com',
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
