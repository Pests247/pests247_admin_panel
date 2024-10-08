import 'package:admin_dashboard/src/models/query_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueryDetailScreen extends StatelessWidget {
  final QueryModel query;

  const QueryDetailScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${query.name}', style: const TextStyle(fontSize: 20)),
            Text('Title: ${query.title}', style: const TextStyle(fontSize: 20)),
            Text('Details: ${query.details}',
                style: const TextStyle(fontSize: 16)),
            Text('User ID: ${query.userId}',
                style: const TextStyle(fontSize: 16)),
            Text('Submitted Time: ${query.submittedTime.toDate().toString()}',
                style: const TextStyle(fontSize: 16)),
            Text('Status: ${query.status}',
                style: const TextStyle(fontSize: 16)),
            Text('Reply: ${query.reply ?? 'No reply yet'}',
                style: const TextStyle(fontSize: 16)),
            Text('Reply Time: ${query.replyTime?.toDate().toString() ?? 'N/A'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Enter your reply here',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (replyController.text.isNotEmpty) {
                  // Call replyToQuery method with the reply text
                  await replyToQuery(query.id, replyController.text);
                  Navigator.of(context).pop(true); // Close the detail screen
                }
              },
              child: const Text('Submit Reply'),
            ),
          ],
        ),
      ),
    );
  }

  // Method to reply to a query
  Future<void> replyToQuery(String queryId, String reply) async {
    try {
      await FirebaseFirestore.instance
          .collection('queries')
          .doc(queryId)
          .update({
        'reply': reply,
        'replyTime': Timestamp.now(),
        'status': 'completed', // Update status to completed
      });
      print('Reply added successfully');
    } catch (e) {
      print('Error replying to query: $e');
    }
  }
}
