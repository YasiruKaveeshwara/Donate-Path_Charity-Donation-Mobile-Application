import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({super.key});

  @override
  _MyItemsPageState createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
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
    return Scaffold(
      body: Stack(
        children: [
          // Content below the sticky header
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'My Donations',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildCategoryImage('assets/images/stationery.png', 'Stationary'),
                        buildCategoryImage('assets/images/shoes.png', 'Shoes'),
                        buildCategoryImage('assets/images/electronics.png', 'Electronics'),
                        buildCategoryImage('assets/images/bags.png', 'Bags'),
                        buildCategoryImage('assets/images/food.png', 'Food'),
                        buildCategoryImage('assets/images/furniture.png', 'Furniture'),
                        buildCategoryImage('assets/images/cloths.png', 'Clothes'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return buildItemCard(
                        '4th Canal Road Negombo',
                        'https://via.placeholder.com/150',
                        'Cloth',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Sticky header
          Positioned(
            top: 22,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
                        child: Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('john.doe@example.com', style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Profile'),
                        onTap: () {
                          // Navigate to Profile Page
                          _toggleDropdown();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('Settings'),
                        onTap: () {
                          // Navigate to Settings Page
                          _toggleDropdown();
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
      ),
    );
  }

  Widget buildCategoryImage(String imagePath, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.lightGreen[200],
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget buildItemCard(String title, String imageUrl, String category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(category),
              ],
            ),
          ),
        ],
      ),
    );
  }
}