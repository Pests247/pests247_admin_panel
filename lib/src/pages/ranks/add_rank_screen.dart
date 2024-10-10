import 'package:admin_dashboard/src/models/rank_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class AddRankScreen extends StatefulWidget {
  const AddRankScreen({super.key});

  @override
  AddRankScreenState createState() => AddRankScreenState();
}

class AddRankScreenState extends State<AddRankScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;

  // Function to pick an image from the computer
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // For web: Using FilePicker for web, enabling the selection of files
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web to get file data
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes;
          _selectedImageName = result.files.first.name;
        });
      }
    } else {
      // For mobile: Using FilePicker for mobile
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          _selectedImageBytes = result.files.first.bytes; // mobile use case
          _selectedImageName = result.files.first.name;
        });
      }
    }
  }

  // Function to upload image to Firebase Storage and get the URL
  Future<String?> _uploadImage(Uint8List imageBytes, String rankId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('rank_badges/$rankId.jpg');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to save the rank to Firestore
  Future<void> _saveRank() async {
    if (_selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String rankId = const Uuid().v4();
      final imageUrl = await _uploadImage(_selectedImageBytes!, rankId);

      if (imageUrl != null) {
        final newRank = RankModel(
          id: rankId,
          badge: imageUrl, // Use the image URL as the badge
          benefits: _benefitsController.text.trim(),
          name: _nameController.text.trim(),
          points: double.tryParse(_pointsController.text.trim()) ?? 0.0,
        );

        // Use Firestore to add the rank
        await FirebaseFirestore.instance
            .collection('ranks')
            .doc(rankId)
            .set(newRank.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rank added successfully!')),
        );

        // Clear the fields and image
        _nameController.clear();
        _benefitsController.clear();
        _pointsController.clear();
        setState(() {
          _selectedImageBytes = null;
          _selectedImageName = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (e) {
      print('Error saving rank: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save rank: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Rank'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_selectedImageBytes != null)
                      Image.memory(
                        _selectedImageBytes!,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    else
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 50,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Add Badge Image',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Rank Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a rank name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _benefitsController,
                      decoration: const InputDecoration(
                        labelText: 'Benefits',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the benefits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _pointsController,
                      decoration: const InputDecoration(
                        labelText: 'Points Required',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter points required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveRank,
                        child: const Text('Save Rank'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
