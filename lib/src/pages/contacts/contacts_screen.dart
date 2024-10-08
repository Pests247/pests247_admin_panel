import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  ContactScreenState createState() => ContactScreenState();
}

class ContactScreenState extends State<ContactScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  // Method to fetch contact info from Firestore
  Future<void> _fetchContactInfo() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('contacts')
          .doc('contact_info')
          .get();

      if (documentSnapshot.exists) {
        // Set the fetched values to the controllers
        _emailController.text = documentSnapshot.get('email') ?? '';
        _phoneController.text = documentSnapshot.get('phone') ?? '';
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error fetching contact info: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to update contact info in Firestore
  Future<void> _updateContactInfo() async {
    try {
      await FirebaseFirestore.instance
          .collection('contacts')
          .doc('contact_info')
          .update({
        'email': _emailController.text,
        'phone': _phoneController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact info updated successfully!')),
      );
    } catch (e) {
      print('Error updating contact info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update contact info')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _updateContactInfo,
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
    );
  }
}
