import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrgSignupPage extends StatefulWidget {
  @override
  _OrgSignupPageState createState() => _OrgSignupPageState();
}

class _OrgSignupPageState extends State<OrgSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _visionController = TextEditingController();
  final _missionController = TextEditingController();
  final _communityEngagementController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _selectedLogo;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedLogo = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadLogo(User user) async {
    if (_selectedLogo == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('organization_logos/${user.uid}.png');
      UploadTask uploadTask = storageRef.putFile(_selectedLogo!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading logo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading logo. Please try again.')),
      );
      return null;
    }
  }

  Future<void> _orgSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update user profile with name
        await userCredential.user!.updateDisplayName(_nameController.text);

        // Upload the organization logo
        String? logoUrl = await _uploadLogo(userCredential.user!);

        // Save user information in Firestore
        await FirebaseFirestore.instance
            .collection('organizations')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'name': _nameController.text,
          'vision': _visionController.text.trim(),
          'mission': _missionController.text.trim(),
          'communityEngagement': _communityEngagementController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'logoUrl': logoUrl, // Save logo URL in Firestore
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful! Please sign in.')),
        );

        // Navigate to sign-in page
        Navigator.of(context).pushReplacementNamed('/signin');
      } on FirebaseAuthException catch (e) {
        // Display error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Organization Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Organization Name'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization name'
                      : null,
                ),
                SizedBox(height: 20),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Organization Email'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization email'
                      : null,
                ),
                SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      InputDecoration(labelText: 'Organization Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization password'
                      : null,
                ),
                SizedBox(height: 20),

                // Vision field
                TextFormField(
                  controller: _visionController,
                  decoration: InputDecoration(labelText: 'Organization Vision'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization vision'
                      : null,
                ),
                SizedBox(height: 20),

                // Mission field
                TextFormField(
                  controller: _missionController,
                  decoration:
                      InputDecoration(labelText: 'Organization Mission'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization mission'
                      : null,
                ),
                SizedBox(height: 20),

                // Community Engagement field
                TextFormField(
                  controller: _communityEngagementController,
                  decoration:
                      InputDecoration(labelText: 'Community Engagement'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your community engagement activities'
                      : null,
                ),
                SizedBox(height: 20),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a phone number' : null,
                ),
                SizedBox(height: 20),

                // Address field
                TextFormField(
                  controller: _addressController,
                  decoration:
                      InputDecoration(labelText: 'Organization Address'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your Organization address'
                      : null,
                ),
                SizedBox(height: 20),

                // Organization Logo field
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickLogo,
                      child: Text('Select Logo'),
                    ),
                    SizedBox(width: 10),
                    if (_selectedLogo != null)
                      Text('Logo selected',
                          style: TextStyle(color: Colors.green))
                    else
                      Text('No logo selected',
                          style: TextStyle(color: Colors.red)),
                  ],
                ),
                SizedBox(height: 20),

                // Sign Up button
                ElevatedButton(
                  onPressed: _orgSignUp,
                  child: Text('Sign Up as an Organization'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
