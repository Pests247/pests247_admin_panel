import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CreditPackagesScreen extends StatefulWidget {
  const CreditPackagesScreen({super.key});

  @override
  CreditPackagesScreenState createState() => CreditPackagesScreenState();
}

class CreditPackagesScreenState extends State<CreditPackagesScreen> {
  final TextEditingController _creditsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isPopular = false;

  // Fetch packages from Firestore
  Stream<QuerySnapshot> _fetchPackages() {
    return FirebaseFirestore.instance.collection('creditsPackages').snapshots();
  }

  // Add a new package
  Future<void> _addPackage() async {
    try {
      int credits = int.tryParse(_creditsController.text) ?? 0;
      double price = double.tryParse(_priceController.text) ?? 0;

      if (credits == 0 || price == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credits or price!')),
        );
        return;
      }

      String id = const Uuid().v4();

      await FirebaseFirestore.instance.collection('creditsPackages').doc(id).set({
        'credits': credits,
        'description': _descriptionController.text,
        'id': id,
        'isPopular': _isPopular,
        'price': price,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package added successfully!')),
      );

      _creditsController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() => _isPopular = false);
    } catch (e) {
      print('Error adding package: $e');
    }
  }

  // Delete a package
  Future<void> _deletePackage(String id) async {
    try {
      await FirebaseFirestore.instance.collection('creditsPackages').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Package deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting package: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete package')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credit Packages')),
      body: Column(
        children: [
          // Input form for adding a package
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _creditsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Credits'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _isPopular,
                      onChanged: (value) {
                        setState(() {
                          _isPopular = value ?? false;
                        });
                      },
                    ),
                    const Text('Is Popular?'),
                  ],
                ),
                ElevatedButton(
                  onPressed: _addPackage,
                  child: const Text('Add Package'),
                ),
              ],
            ),
          ),

          // Display credit packages
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _fetchPackages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No packages available.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Credits: ${data['credits']} '),
                            Text('Price: ${data['price']}')
                          ],
                        ),
                        subtitle: Text(data['description'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletePackage(data['id']),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
