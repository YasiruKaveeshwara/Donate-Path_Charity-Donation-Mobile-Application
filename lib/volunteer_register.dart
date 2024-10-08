import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerRegisterPage extends StatefulWidget {
  const VolunteerRegisterPage({super.key});

  @override
  _VolunteerRegisterPageState createState() => _VolunteerRegisterPageState();
}

class _VolunteerRegisterPageState extends State<VolunteerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers to hold user input
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  
  String _gender = 'Male'; // Default gender option

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to register as a volunteer
  Future<void> _registerVolunteer() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Get user's unique UID from Firebase
          String uid = user.uid;

          // Add user volunteer details to Firestore database
          await _firestore.collection('volunteers').doc(uid).set({
            'fullName': _fullNameController.text.trim(),
            'nic': _nicController.text.trim(),
            'age': int.parse(_ageController.text.trim()),
            'gender': _gender,
            'address': _addressController.text.trim(),
            'userType': 'volunteer', // upgrading user type
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registered as a Volunteer successfully!')),
          );

          // Navigate to another page or reset form (optional)
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register as a volunteer.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Volunteer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Full Name
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // NIC
              TextFormField(
                controller: _nicController,
                decoration: const InputDecoration(
                  labelText: 'NIC Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIC number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 18) {
                    return 'You must be at least 18 years old';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Register button
              ElevatedButton(
                onPressed: _registerVolunteer,
                child: const Text('Register as Volunteer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
