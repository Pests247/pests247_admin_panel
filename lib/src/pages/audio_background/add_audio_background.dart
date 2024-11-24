import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAudioBackground extends StatefulWidget {
  const AddAudioBackground({Key? key}) : super(key: key);

  @override
  State<AddAudioBackground> createState() =>
      _AddAudioBackgroundState();
}

class _AddAudioBackgroundState extends State<AddAudioBackground> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;

  /// Method to add the audio background to Firestore
  Future<void> _addAudioBackground() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String id = _idController.text.trim();
        final String url = _urlController.text.trim();
        final double price = double.parse(_priceController.text.trim());

        await FirebaseFirestore.instance.collection('audioBackground').doc(id).set({
          'id': id,
          'url': url,
          'price': price,
          'owners': [], // Initialize owners as an empty list
        });

        // Clear the form after saving
        _idController.clear();
        _urlController.clear();
        _priceController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Audio background added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add background: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Audio Background'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'Background ID',
                  hintText: 'Enter a unique ID for the background',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Background URL',
                  hintText: 'Enter the URL of the background',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter the price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addAudioBackground,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : const Text(
                        'Add Background',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
