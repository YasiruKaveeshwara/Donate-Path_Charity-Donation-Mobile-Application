import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_items_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages corresponding to each bottom navigation bar item
  final List<Widget> _pages = [
    HomeContent(),
    const Center(child: Text('Orphanage Page Content')),
    const Center(child: Text('Events Page Content')),
    MyItemsPage(),
    const Center(child: Text('Profile Page Content')),
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
            icon: Icon(Icons.house_siding), // Orphanage
            label: 'Orphanages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory), // My Items
            label: 'My Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// class HomeContent extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Content below the sticky header
//         Padding(
//           padding: const EdgeInsets.only(top: 80.0), // Space for the sticky header
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 buildPictureButton(
//                   context,
//                   'DONATE ITEMS',
//                   'assets/images/donate_items.png',
//                       () {
//                     // Navigate to Donate Items page or action
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 buildPictureButton(
//                   context,
//                   'ITEMS',
//                   'assets/images/items.png',
//                       () {
//                     // Navigate to Items page or action
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 Section(
//                   title: 'Orphanages',
//                   items: [
//                     SectionCard(
//                       title: 'Caring Hearts',
//                       imagePath: 'assets/images/orphanage.png',
//                       onTap: () {
//                         // Navigate to Caring Hearts details or page
//                       },
//                     ),
//                     SectionCard(
//                       title: 'Tender Care',
//                       imagePath: 'assets/images/orphanage2.png',
//                       onTap: () {
//                         // Navigate to Tender Care details or page
//                       },
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Section(
//                   title: 'Elderly Homes',
//                   items: [
//                     SectionCard(
//                       title: 'Golden Age',
//                       imagePath: 'assets/images/elderly_home1.png',
//                       onTap: () {
//                         // Navigate to Golden Age details or page
//                       },
//                     ),
//                     SectionCard(
//                       title: 'Silver Care',
//                       imagePath: 'assets/images/elderly_home2.png',
//                       onTap: () {
//                         // Navigate to Silver Care details or page
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Sticky header
//         Positioned(
//           top: 22,
//           left: 0,
//           right: 0,
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.menu),
//                       onPressed: () {},
//                     ),
//                     Text(
//                       'WELCOME',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.notifications),
//                       onPressed: () {},
//                     ),
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundImage: NetworkImage('https://via.placeholder.com/150'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isDropdownVisible = false;

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // The AuthWrapper will handle navigation after sign out
      _toggleDropdown(); // Close the dropdown after logout
    } catch (e) {
      print("Error signing out: $e");
      // Optionally show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Content below the sticky header
        Padding(
          padding:
              const EdgeInsets.only(top: 80.0), // Space for the sticky header
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                buildPictureButton(
                  context,
                  'DONATE ITEMS',
                  'assets/images/donate_items.jpg',
                  () {
                    // Navigate to Donate Items page or action
                  },
                ),
                SizedBox(height: 20),
                buildPictureButton(
                  context,
                  'ITEMS',
                  'assets/images/stationery.png',
                  () {
                    // Navigate to Items page or action
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
        // Sticky header with profile icon
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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    ),
                    Text(
                      'WELCOME',
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
        // Dropdown menu when profile icon is tapped
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
                        // Handle Logout Action
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
            color: Colors.white, // Ensure text is readable over image
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
