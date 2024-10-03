import 'package:admin_dashboard/src/models/promotion_model.dart';
import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'package:uuid/uuid.dart'; // For working with selected files in web

class AddPromotionScreen extends StatefulWidget {
  const AddPromotionScreen({super.key});

  @override
  AddPromotionScreenState createState() => AddPromotionScreenState();
}

class AddPromotionScreenState extends State<AddPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateExpiredController = TextEditingController();

  Uint8List? _selectedImageBytes;
  String? _selectedImageName;
  bool _isLoading = false;

  // Function to pick an image from the computer
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedImageBytes = result.files.first.bytes;
        _selectedImageName = result.files.first.name;
      });
    }
  }

  // Function to upload image to Firebase Storage and get the URL
  Future<String?> _uploadImage(Uint8List imageBytes, String promotionId) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('promotions/$promotionId');
      final uploadTask = storageRef.putData(imageBytes);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Function to save the promotion to Firestore
  Future<void> _savePromotion() async {
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
      final String promotionId = const Uuid().v4();
      final imageUrl = await _uploadImage(_selectedImageBytes!, promotionId);

      if (imageUrl != null) {
        final newPromotion = Promotion(
          id: promotionId,
          picture: imageUrl,
          text: _textController.text.trim(),
          description: _descriptionController.text.trim(),
          dateAdded: Timestamp.now(),
          dateExpired: _dateExpiredController.text.isNotEmpty
              ? Timestamp.fromDate(
                  DateTime.parse(_dateExpiredController.text.trim()))
              : null,
        );

        // Use FirestoreService to add the promotion
        await FirestoreService().addPromotion(newPromotion);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Promotion added successfully!')),
        );

        // Clear the fields and image
        _textController.clear();
        _descriptionController.clear();
        _dateExpiredController.clear();
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
      print('Error saving promotion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save promotion: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to show date picker
  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year, now.month + 1, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        // Update the date controller with the selected date in YYYY-MM-DD format
        _dateExpiredController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Promotion'),
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
                                'Add Picture',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Promotion Text (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateExpiredController,
                          decoration: const InputDecoration(
                            labelText: 'Date Expired (YYYY-MM-DD) (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              try {
                                DateTime.parse(value.trim());
                              } catch (e) {
                                return 'Please enter a valid date';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _savePromotion,
                        child: const Text('Save Promotion'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
