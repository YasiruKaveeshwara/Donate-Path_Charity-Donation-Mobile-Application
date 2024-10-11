import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:donate_path/main_layout.dart';
import 'package:flutter/material.dart';

class MyItemsPage extends StatelessWidget {
  const MyItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 3,
      headerText: 'My Items',
      profileImage: '',
      child: MyItemsContent(),
    );
  }
}

class MyItemsContent extends StatefulWidget {
  @override
  _MyItemsContentState createState() => _MyItemsContentState();
}

class _MyItemsContentState extends State<MyItemsContent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    // if (user == null) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('My Items'),
    //     ),
    //     body: Center(child: Text('User not logged in!')),
    //   );
    // }

    if (user == null) {
      return const Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("User not signed in"),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('donations')
                  .doc(user.uid)
                  .collection('items')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No items found'));
                }

                List<QueryDocumentSnapshot> donationList = snapshot.data!.docs;

                // Filter the list based on the selected category
                if (_selectedCategory != 'All') {
                  donationList = donationList
                      .where((doc) => doc['category'] == _selectedCategory)
                      .toList();
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: buildPictureButton(
                          context,
                          'My Donations',
                          'assets/images/donate_items.jpg',
                          () {
                            // Navigate to Donate Items page or action
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => DonatePage()),
                            // );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
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
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: donationList.length,
                        itemBuilder: (context, index) {
                          final item = donationList[index].data()
                              as Map<String, dynamic>;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0)),
                                  child: Image.network(
                                    item['item_images'],
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "name: ${item['item_name']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['location'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    item['category'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ))
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('My Items'),
    //   ),
    //   body: StreamBuilder<QuerySnapshot>(
    //     stream: _firestore
    //         .collection('donations')
    //         .doc(user.uid)
    //         .collection('items')
    //         .orderBy('timestamp', descending: true)
    //         .snapshots(),
    //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }

    //       if (snapshot.hasError ||
    //           !snapshot.hasData ||
    //           snapshot.data!.docs.isEmpty) {
    //         return Center(child: Text('No items found'));
    //       }

    //       List<QueryDocumentSnapshot> donationList = snapshot.data!.docs;

    //       // Filter the list based on the selected category
    //       if (_selectedCategory != 'All') {
    //         donationList = donationList
    //             .where((doc) => doc['category'] == _selectedCategory)
    //             .toList();
    //       }

    //       return SingleChildScrollView(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: buildPictureButton(
    //                 context,
    //                 'My Donations',
    //                 'assets/images/donate_items.jpg',
    //                 () {
    //                   // Navigate to Donate Items page or action
    //                   // Navigator.push(
    //                   //   context,
    //                   //   MaterialPageRoute(builder: (context) => DonatePage()),
    //                   // );
    //                 },
    //               ),
    //             ),
    //             SizedBox(height: 10),
    //             SingleChildScrollView(
    //               scrollDirection: Axis.horizontal,
    //               child: Row(
    //                 children: [
    //                   _buildCategoryIcon('All', Icons.all_inclusive),
    //                   _buildCategoryIcon('Stationary', Icons.note),
    //                   _buildCategoryIcon('Shoes', Icons.directions_run),
    //                   _buildCategoryIcon('Electronics', Icons.devices),
    //                   _buildCategoryIcon('Bags', Icons.backpack),
    //                   _buildCategoryIcon('Food', Icons.fastfood),
    //                   _buildCategoryIcon('Furniture', Icons.chair),
    //                   _buildCategoryIcon('Clothes', Icons.checkroom),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(height: 20),
    //             GridView.builder(
    //               shrinkWrap: true,
    //               physics: NeverScrollableScrollPhysics(),
    //               padding: EdgeInsets.all(16.0),
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 2,
    //                 crossAxisSpacing: 10.0,
    //                 mainAxisSpacing: 10.0,
    //                 childAspectRatio: 3 / 4,
    //               ),
    //               itemCount: donationList.length,
    //               itemBuilder: (context, index) {
    //                 final item =
    //                     donationList[index].data() as Map<String, dynamic>;
    //                 return Container(
    //                   decoration: BoxDecoration(
    //                     color: Colors.grey[200],
    //                     borderRadius: BorderRadius.circular(10.0),
    //                   ),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       ClipRRect(
    //                         borderRadius: BorderRadius.vertical(
    //                             top: Radius.circular(10.0)),
    //                         child: Image.network(
    //                           item['item_images'],
    //                           height: 120,
    //                           width: double.infinity,
    //                           fit: BoxFit.cover,
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           "name: ${item['item_name']}",
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           item['location'],
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                       ),
    //                       Padding(
    //                         padding:
    //                             const EdgeInsets.symmetric(horizontal: 8.0),
    //                         child: Text(
    //                           item['category'],
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             color: Colors.grey[700],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 );
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  Widget buildPictureButton(BuildContext context, String label,
      String imagePath, VoidCallback onPressed) {
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
              color: Colors.white, // Ensure text is readable over the image
            ),
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
              backgroundColor: _selectedCategory == category
                  ? Colors.blue
                  : Colors.grey[300],
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
