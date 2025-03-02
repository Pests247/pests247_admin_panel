import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/new_updates.dart';

class NewUpdatesScreen extends StatefulWidget {
  const NewUpdatesScreen({super.key});

  @override
  NewUpdatesScreenState createState() => NewUpdatesScreenState();
}

class NewUpdatesScreenState extends State<NewUpdatesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _versionController = TextEditingController();

  // Fetch updates from Firestore (sorted by time)
  Stream<List<NewUpdate>> _fetchUpdates() {
    return FirebaseFirestore.instance
        .collection('newUpdates')
        .orderBy('updateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NewUpdate.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  // Add a new update
  Future<void> _addUpdate() async {
    try {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _versionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      NewUpdate newUpdate = NewUpdate(
        updateTitle: _titleController.text,
        updateDescription: _descriptionController.text,
        updateNumber: _versionController.text,
        updateTime: DateTime.now(),
      );

      await FirebaseFirestore.instance.collection('newUpdates').add(newUpdate.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update added successfully!')),
      );

      _titleController.clear();
      _descriptionController.clear();
      _versionController.clear();
    } catch (e) {
      print('Error adding update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest Updates')),
      body: Column(
        children: [
          // Form to add a new update
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Update Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _versionController,
                  decoration: const InputDecoration(labelText: 'Version Number'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addUpdate,
                  child: const Text('Add Update'),
                ),
              ],
            ),
          ),

          // Display the updates list
          Expanded(
            child: StreamBuilder<List<NewUpdate>>(
              stream: _fetchUpdates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No updates available.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final update = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(
                          update.updateTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(update.updateDescription),
                            const SizedBox(height: 4),
                            Text('Version: ${update.updateNumber}'),
                            Text('Date: ${update.updateTime.toString().split(' ')[0]}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
