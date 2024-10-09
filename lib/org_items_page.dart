import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'org_request_form.dart'; // Import your org_request_form.dart

class MyItemsPage extends StatefulWidget {
  @override
  _MyItemsPageState createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> {
  bool _isDropdownVisible = false;
  String?
      _selectedCategory; // Add a variable to keep track of the selected category

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

  Future<List<Map<String, dynamic>>> _fetchDonationRequests() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('requests').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
                        'Requested Donation',
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
                        buildCategoryImage(
                            'assets/images/stationery.png', 'Stationery'),
                        buildCategoryImage('assets/images/shoes.png', 'Shoes'),
                        buildCategoryImage(
                            'assets/images/electronics.png', 'Electronics'),
                        buildCategoryImage('assets/images/bags.png', 'Bags'),
                        buildCategoryImage('assets/images/food.png', 'Food'),
                        buildCategoryImage(
                            'assets/images/furniture.png', 'Furniture'),
                        buildCategoryImage(
                            'assets/images/cloths.png', 'Clothes'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchDonationRequests(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text('No donation requests found.'));
                      }

                      final donationRequests = snapshot.data!;
                      // Filter the donation requests based on the selected category
                      final filteredRequests = _selectedCategory != null
                          ? donationRequests
                              .where((request) =>
                                  request['category'] == _selectedCategory)
                              .toList()
                          : donationRequests;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = filteredRequests[index];
                          final title = request['itemName'] ?? 'Unknown Item';
                          final imageUrl = request['imageUrl'] ??
                              'https://via.placeholder.com/150';
                          final category = request['category'] ?? 'Other';
                          final description =
                              request['description'] ?? 'No Description';
                          final quantity = request['quantity'] ??
                              0; // Fetch the quantity from the document

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: buildItemCard(title, imageUrl, category,
                                description, quantity),
                          );
                        },
                      );
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DonationRequestForm()), // Navigate to OrgRequestForm
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Request Donation',
      ),
    );
  }

  Widget buildCategoryImage(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label; // Set the selected category
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.lightGreen[200],
              backgroundImage: AssetImage(imagePath),
            ),
            SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget buildItemCard(String title, String imageUrl, String category,
      String description, int quantity) {
    // Add quantity as a parameter
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantity: $quantity', // Display the fetched quantity
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
