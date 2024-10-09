import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File

class DonationRequestForm extends StatefulWidget {
  @override
  _DonationRequestFormState createState() => _DonationRequestFormState();
}

class _DonationRequestFormState extends State<DonationRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Variable to store the selected image file
  XFile? _imageFile;

  // List of categories for the dropdown
  final List<String> _categories = [
    'Food',
    'Clothes',
    'Furniture',
    'Electronics',
    'Shoes',
    'Stationary',
    'Other'
  ];

  int _quantity = 1; // Default quantity
  String? _selectedCategory; // Variable to store the selected category

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Get the form data
      String itemName = _itemNameController.text;
      String category = _selectedCategory!;
      String description = _descriptionController.text;

      // Upload image and get the URL
      String imageUrl = await _uploadImage();

      // Create a map of the data
      Map<String, dynamic> requestData = {
        'itemName': itemName,
        'category': category,
        'description': description,
        'quantity': _quantity,
        'imageUrl': imageUrl, // Add image URL to the data
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('requests').add(requestData);

      // Optionally, clear the form or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Donation request submitted successfully!')),
      );

      // Clear the form
      _itemNameController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
        _quantity = 1;
        _imageFile = null; // Reset the image
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_imageFile == null) return '';

    // Create a unique file name for the image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

    // Create a reference to the Firebase Storage
    Reference ref =
        FirebaseStorage.instance.ref().child('donation_images/$fileName');

    // Upload the image to Firebase Storage
    await ref.putFile(File(_imageFile!.path));

    // Get the download URL
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _pickImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image; // Store the selected image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Donations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the item name';
                  }
                  return null;
                },
              ),
              // Dropdown for Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue; // Update selected category
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the item description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Quantity Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity: $_quantity',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) {
                              _quantity--; // Decrease quantity
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _quantity++; // Increase quantity
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Button to pick an image
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              // Display the selected image
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.file(File(_imageFile!.path), height: 100),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Request'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
                child: Text('Request More'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
