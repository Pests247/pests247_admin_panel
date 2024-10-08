import 'package:admin_dashboard/src/services/firestore_service.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  FAQScreenState createState() => FAQScreenState();
}

class FAQScreenState extends State<FAQScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  List<Map<String, dynamic>> _faqs = []; // Changed to include 'id'
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFAQs();
  }

  // Method to load all FAQs from Firestore
  Future<void> _loadFAQs() async {
    final fetchedFAQs = await FirestoreService().fetchFAQs();
    setState(() {
      _faqs = fetchedFAQs;
      _isLoading = false;
    });
  }

  // Method to add a new FAQ
  Future<void> _addFAQ() async {
    if (_questionController.text.isNotEmpty &&
        _answerController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await FirestoreService()
          .addFAQ(_questionController.text, _answerController.text);
      _questionController.clear();
      _answerController.clear();

      // Reload FAQs after adding a new one
      await _loadFAQs();

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FAQ added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in both question and answer')),
      );
    }
  }

  // Method to delete an FAQ
  Future<void> _deleteFAQ(String docId) async {
    setState(() {
      _isLoading = true;
    });

    await FirestoreService().deleteFAQ(docId);

    // Reload FAQs after deletion
    await _loadFAQs();

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FAQ deleted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // List of FAQs
                  Expanded(
                    child: _faqs.isEmpty
                        ? const Center(child: Text('No FAQs available'))
                        : ListView.builder(
                            itemCount: _faqs.length,
                            itemBuilder: (context, index) {
                              final faq = _faqs[index];

                              print(faq['id']);
                              return Card(
                                child: ListTile(
                                  title: Text(faq['question'] ?? ''),
                                  subtitle: Text(faq['answer'] ?? ''),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _deleteFAQ(faq['id'] ?? ''),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  // Input fields and button to add a new FAQ
                  TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addFAQ,
                    child: const Text('Add FAQ'),
                  ),
                ],
              ),
            ),
    );
  }
}
