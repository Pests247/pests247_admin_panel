import 'package:admin_dashboard/src/models/query_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueriesScreen extends StatefulWidget {
  const QueriesScreen({Key? key}) : super(key: key);

  @override
  QueriesScreenState createState() => QueriesScreenState();
}

class QueriesScreenState extends State<QueriesScreen> {
  late Future<List<QueryModel>> _queriesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch all queries from Firestore
    _queriesFuture = fetchAllQueries();
  }

  // Method to fetch all queries from Firestore, sorted by submission time (most recent first)
  Future<List<QueryModel>> fetchAllQueries() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('queries')
          .orderBy('submittedTime', descending: true) // Most recent first
          .get();

      return snapshot.docs
          .map((doc) => QueryModel.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error fetching queries: $e');
      return [];
    }
  }

  // Method to delete a query
  Future<void> deleteQuery(String queryId) async {
    try {
      await FirebaseFirestore.instance
          .collection('queries')
          .doc(queryId)
          .delete();
      print('Query deleted successfully');
      // Refresh the list after deletion
      setState(() {
        _queriesFuture = fetchAllQueries();
      });
    } catch (e) {
      print('Error deleting query: $e');
    }
  }

  // Method to reply to a query and update its status to "completed"
  Future<void> replyToQuery(String queryId, String reply) async {
    try {
      await FirebaseFirestore.instance
          .collection('queries')
          .doc(queryId)
          .update({
        'reply': reply,
        'replyTime': Timestamp.now(),
        'status': 'completed', // Change status to completed
      });
      print('Reply added successfully');
      // Refresh the list after reply
      setState(() {
        _queriesFuture = fetchAllQueries();
      });
    } catch (e) {
      print('Error replying to query: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<QueryModel>>(
          future: _queriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No queries available'),
              );
            } else {
              final queries = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: queries.map((query) {
                    return DataRow(
                      cells: [
                        DataCell(Text(query.name)),
                        DataCell(Text(query.title)),
                        DataCell(Text(query.status)),
                        DataCell(Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Navigate to the query detail page
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QueryDetailScreen(
                                      query: query,
                                      onReply: (reply) async {
                                        await replyToQuery(query.id, reply);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: const Text('View Details'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                // Call the delete method to delete this query
                                await deleteQuery(query.id);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class QueryDetailScreen extends StatelessWidget {
  final QueryModel query;
  final Function(String reply) onReply;

  const QueryDetailScreen({
    Key? key,
    required this.query,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Query Details: ${query.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${query.name}'),
            Text('Details: ${query.details}'),
            Text('Status: ${query.status}'),
            Text('User ID: ${query.userId}'),
            Text('Submitted Time: ${query.submittedTime.toDate()}'),
            Text('Reply: ${query.reply ?? 'No reply yet'}'),
            Text('Reply Time: ${query.replyTime?.toDate() ?? 'N/A'}'),
            const SizedBox(height: 20),
            TextField(
              controller: replyController,
              decoration: const InputDecoration(
                hintText: 'Enter your reply here',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                onReply(replyController.text); // Call the reply function
                Navigator.pop(context); // Close the dialog after replying
              },
              child: const Text('Submit Reply'),
            ),
          ],
        ),
      ),
    );
  }
}
