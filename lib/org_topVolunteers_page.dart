import 'package:flutter/material.dart';

class TopVolunteersPage extends StatelessWidget {
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
                  // Add your content for top volunteers here
                  Text(
                    'Top Volunteers',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  // Example list of top volunteers
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        10, // Change this to the actual number of volunteers
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('Volunteer ${index + 1}'),
                          subtitle:
                              Text('Details about Volunteer ${index + 1}'),
                          onTap: () {
                            // Handle volunteer tap
                          },
                        ),
                      );
                    },
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
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
