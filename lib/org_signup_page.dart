import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure you import Firestore
import 'package:flutter/material.dart';

class OrgSignupPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<OrgSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _orgsignUp() async {
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

        // Save user information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _emailController.text.trim(),
          'name': _nameController.text,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                decoration: InputDecoration(labelText: 'Organization Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Please enter your Organization password'
                    : null,
              ),
              SizedBox(height: 20),

              // Sign Up button
              ElevatedButton(
                onPressed: _orgsignUp,
                child: Text('Sign Up as a Organization'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
