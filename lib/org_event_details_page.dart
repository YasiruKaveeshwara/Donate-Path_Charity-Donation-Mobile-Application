import 'package:flutter/material.dart';
import 'org_home_page.dart'; // Import OrgHomePage if it's in another file

class OrgEventDetailsPage extends StatelessWidget {
  final String title;
  final String imagePath;
  final String date;
  final String description;
  final int completion;
  final String organizerPhone;
  final List<String> contributors;
  final List<Map<String, dynamic>> items; // New field for event items

  // Constructor to pass event details
  OrgEventDetailsPage({
    required this.title,
    required this.imagePath,
    required this.date,
    required this.description,
    required this.completion,
    required this.organizerPhone,
    required this.contributors,
    required this.items, // Add items as a parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to OrgHomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrgHomePage()),
            );
          },
        ),
        title: Text('Event Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),

            // Event Title
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // Event Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  date,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Event Description
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16.0),

            // Completion Status
            Text(
              'Completion: $completion%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),

            // Organizer's Phone Number
            Text(
              'Organizer Contact:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.phone, size: 20, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  organizerPhone,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Contributors
            Text(
              'Contributors:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contributors.map((contributor) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 20, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text(
                        contributor,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),

            // Items
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Text(
                        '${item['name']} - ${item['category']} (Quantity: ${item['quantity']})',
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
