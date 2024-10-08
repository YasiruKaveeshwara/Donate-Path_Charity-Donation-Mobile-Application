import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_items_page.dart';
import 'side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages corresponding to each bottom navigation bar item
  final List<Widget> _pages = [
    const HomeContent(),
    const Center(child: Text('Orphanage Page Content')),
    const Center(child: Text('Events Page Content')),
    const MyItemsPage(),
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
      drawer: SideMenu(),
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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

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
      _toggleDropdown(); // Close the dropdown after logout
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content with space for the sticky header
        Padding(
          padding: const EdgeInsets.only(top: 80.0), // Space for sticky header
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildPictureButton(
                  context,
                  'DONATE ITEMS',
                  'assets/images/donate_items.jpg',
                  () {
                    // Navigate to Donate Items page or action
                  },
                ),
                const SizedBox(height: 20),
                buildPictureButton(
                  context,
                  'ITEMS',
                  'assets/images/stationery.png',
                  () {
                    // Navigate to Items page or action
                  },
                ),
                const SizedBox(height: 20),
                Section(
                  title: 'Orphanages',
                  items: [
                    SectionCard(
                      title: 'Caring Hearts',
                      imagePath: 'assets/images/orphanage.png',
                      onTap: () {
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
                const SizedBox(height: 20),
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
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    const Text(
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
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Notifications functionality
                      },
                    ),
                    GestureDetector(
                      onTap: _toggleDropdown,
                      child: const CircleAvatar(
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('John Doe',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('john.doe@example.com',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        // Navigate to Profile Page
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        // Navigate to Settings Page
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
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
  }
}

// Reusable Widget for Picture Button
Widget buildPictureButton(
    BuildContext context, String label, String imagePath, VoidCallback onPressed) {
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
          style: const TextStyle(
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

  const Section({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
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

  const SectionCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

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
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
