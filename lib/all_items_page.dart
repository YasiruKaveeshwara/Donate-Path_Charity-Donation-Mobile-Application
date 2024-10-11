import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_layout.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  _AllItemsPageState createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      headerText: "All Items",
      profileImage: "",
      selectedIndex: 3,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryIcon('All', Icons.all_inclusive),
                    _buildCategoryIcon('Stationary', Icons.note),
                    _buildCategoryIcon('Shoes', Icons.directions_run),
                    _buildCategoryIcon('Electronics', Icons.devices),
                    _buildCategoryIcon('Bags', Icons.backpack),
                    _buildCategoryIcon('Food', Icons.fastfood),
                    _buildCategoryIcon('Furniture', Icons.chair),
                    _buildCategoryIcon('Clothes', Icons.checkroom),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collectionGroup('items')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      print("error :${snapshot.error}");
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No items found'));
                    }

                    List<QueryDocumentSnapshot> allItems = snapshot.data!.docs;

                    if (_selectedCategory != 'All') {
                      allItems = allItems.where((doc) => doc['category'] == _selectedCategory).toList();
                    }

                    return GridView.builder(
                      padding: EdgeInsets.all(16.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: allItems.length,
                      itemBuilder: (context, index) {
                        final item = allItems[index].data() as Map<String, dynamic>;
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
                                  child: Image.network(
                                    item['item_images'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(child: Icon(Icons.error));
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${item['item_name']}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item['location'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      item['category'],
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(String category, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _selectedCategory == category ? Colors.blue : Colors.grey[300],
              child: Icon(
                icon,
                size: 30,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(category),
          ],
        ),
      ),
    );
  }
}