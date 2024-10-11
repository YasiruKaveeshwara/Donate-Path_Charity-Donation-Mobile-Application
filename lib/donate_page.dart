import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main_layout.dart';

class DonatePage extends StatefulWidget {
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _donatorNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _categoryValue;
  XFile? _pickedImage;

  final List<String> _categories = [
    'Stationary', 'Shoes', 'Electronics', 'Bags', 'Food', 'Furniture', 'Clothes'
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = image;
    });
  }

  Future<void> _addDonation() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in!'))
      );
      return;
    }

    if (_pickedImage != null && _categoryValue != null) {
      try {
        // Step 1: Upload image to Firebase Storage
        final Reference storageRef = _storage.ref().child('donations/${DateTime.now().millisecondsSinceEpoch}_${_pickedImage!.name}');
        final UploadTask uploadTask = storageRef.putFile(File(_pickedImage!.path));
        final TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        // Step 2: Store item data in Firestore
        await _firestore.collection('donations').doc(user.uid).collection('items').add({
          'item_name': _itemNameController.text,
          'location': _locationController.text,
          'category': _categoryValue,
          'donator_name': _donatorNameController.text,
          'contact_number': _contactNumberController.text,
          'item_images': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Donation added successfully!'))
        );
        _resetFields();
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add donation!'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image and category!'))
      );
    }
  }

  void _resetFields() {
    setState(() {
      _itemNameController.clear();
      _locationController.clear();
      _donatorNameController.clear();
      _contactNumberController.clear();
      _categoryValue = null;
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
        headerText: 'Add Donation',
        profileImage: '',
        selectedIndex: 0,
        child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _itemNameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: _donatorNameController,
                decoration: InputDecoration(labelText: 'Donator Name'),
              ),
              TextField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _categoryValue,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryValue = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 20),
              _pickedImage == null
                  ? Text('No image selected')
                  : Image.file(File(_pickedImage!.path)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _addDonation,
                    child: Text('Add Donation'),
                  ),
                  ElevatedButton(
                    onPressed: _resetFields,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}