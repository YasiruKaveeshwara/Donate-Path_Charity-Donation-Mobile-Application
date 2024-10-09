import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore
import 'org_items_page.dart';
import 'org_events_page.dart';
import 'org_profile_page.dart';
import 'org_request_form.dart';

class OrgHomePage extends StatefulWidget {
  @override
  _OrgHomePageState createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  int _selectedIndex = 0;

  // List of pages corresponding to each bottom navigation bar item
  final List<Widget> _pages = [
    HomeContent(),
    MyItemsPage(),
    OrgEventsPage(),
    OrgProfilePage(),
  ];

  // Handler for bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory), // Orphanage
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), // Events
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Profile
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isDropdownVisible = false;
  User? user;
  Future<Map<String, dynamic>?>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _userDataFuture = fetchUserData();
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (snapshot.exists) {
          return snapshot.data() as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data.')),
      );
    }
    return null;
  }

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
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else if (snapshot.hasData && snapshot.data != null) {
          Map<String, dynamic> userData = snapshot.data!;
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      buildPictureButton(
                        context,
                        'REQUEST DONATIONS',
                        'assets/images/donate_items.jpg',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DonationRequestForm()),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Section(
                        title: 'Orphanages',
                        items: [
                          SectionCard(
                            title: 'Caring Hearts',
                            imagePath: 'assets/images/orphanage.png',
                            onTap: () {
                              // Navigate to Caring Hearts details or page
                            },
                          ),
                          SectionCard(
                            title: 'Tender Care',
                            imagePath: 'assets/images/orphanage.png',
                            onTap: () {
                              // Navigate to Tender Care details or page
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Section(
                        title: 'Elderly Homes',
                        items: [
                          SectionCard(
                            title: 'Golden Age',
                            imagePath: 'assets/images/orphanage.png',
                            onTap: () {
                              // Navigate to Golden Age details or page
                            },
                          ),
                          SectionCard(
                            title: 'Silver Care',
                            imagePath: 'assets/images/orphanage.png',
                            onTap: () {
                              // Navigate to Silver Care details or page
                            },
                          ),
                        ],
                      ),
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {},
                          ),
                          Text(
                            'WELCOME ${userData['name'] ?? 'User'}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.notifications),
                            onPressed: () {},
                          ),
                          GestureDetector(
                            onTap: _toggleDropdown,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: userData['profilePictureUrl'] !=
                                      null
                                  ? NetworkImage(userData['profilePictureUrl'])
                                  : AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
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
                            child: Text(userData['name'] ?? 'John Doe',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                userData['email'] ?? 'john.doe@example.com',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Profile'),
                            onTap: () {
                              // Navigate to Profile Page
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text('Settings'),
                            onTap: () {
                              // Navigate to Settings Page
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
          );
        } else {
          return Center(child: Text('No user data available'));
        }
      },
    );
  }
}

// Reusable Widget for Picture Button
Widget buildPictureButton(BuildContext context, String label, String imagePath,
    VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.lightGreen[100],
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

class Section extends StatelessWidget {
  final String title;
  final List<SectionCard> items;

  Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items,
        ),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  SectionCard(
      {required this.title, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
