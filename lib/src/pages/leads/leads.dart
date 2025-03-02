import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date/time

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  LeadsScreenState createState() => LeadsScreenState();
}

class LeadsScreenState extends State<LeadsScreen> {
  // Fetch leads from Firestore
  Stream<QuerySnapshot> _fetchLeads() {
    return FirebaseFirestore.instance.collection('leads').snapshots();
  }

  // Function to delete a lead
  Future<void> _deleteLead(String leadId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Lead"),
        content: const Text("Are you sure you want to delete this lead?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance.collection('leads').doc(leadId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead deleted successfully!')),
        );
      } catch (e) {
        print('Error deleting lead: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete lead')),
        );
      }
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "N/A";

    if (timestamp is Timestamp) {
      // Convert Firestore Timestamp to DateTime
      return DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate());
    } else if (timestamp is String) {
      // Parse string date format
      try {
        DateTime parsedDate = DateTime.parse(timestamp);
        return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
      } catch (e) {
        return "Invalid Date"; // Handle invalid date strings
      }
    }

    return "N/A"; // Fallback case
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leads')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fetchLeads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No leads available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var leadData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lead Title & Status
                      Text(leadData['name'] ?? 'No Title',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text('Status: ${leadData['status'] ?? 'N/A'}', style: const TextStyle(color: Colors.blue)),

                      // General Lead Details
                      Text('Email: ${leadData['email'] ?? 'N/A'}'),
                      Text('Location: ${leadData['location'] ?? 'N/A'}'),
                      Text('Hiring Decision: ${leadData['hiringDecision'] ?? 'N/A'}'),
                      Text('Property Type: ${leadData['propertyType'] ?? 'N/A'}'),
                      Text('Sighting Frequency: ${leadData['sightingsFrequency'] ?? 'N/A'}'),
                      Text('Additional Details: ${leadData['additionalDetails'] ?? 'N/A'}'),
                      Text('Credits: ${leadData['credits'] ?? 0}'),
                      Text('Submitted At: ${_formatTimestamp(leadData['submittedAt'])}'),

                      // Buyers List
                      if (leadData['buyers'] != null && leadData['buyers'].isNotEmpty) ...[
                        const SizedBox(height: 5),
                        const Text('Buyers:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Column(
                          children: List.generate(leadData['buyers'].length, (i) {
                            var buyer = leadData['buyers'][i];

                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('🆔 Buyer ID: ${buyer['userId'] ?? 'N/A'}',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('📌 Status: ${buyer['status'] ?? 'N/A'}'),


                                  // Quotes Section
                                  if (buyer['quotes'] != null && buyer['quotes'].isNotEmpty) ...[
                                    const SizedBox(height: 5),
                                    const Text('💵 Quotes:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(buyer['quotes'].length, (qIndex) {
                                        var quote = buyer['quotes'][qIndex];
                                        return Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('💰 Price: \$${quote['price'] ?? 0}'),
                                              Text('📄 Fee Type: ${quote['feeType'] ?? 'N/A'}'),
                                              Text('📜 Details: ${quote['additionalDetails'] ?? 'N/A'}'),
                                              Text('🕒 Timestamp: ${_formatTimestamp(quote['timestamp'])}'),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ],

                                  // Activity Logs Section
                                  if (buyer['activityLogs'] != null && buyer['activityLogs'].isNotEmpty) ...[
                                    const SizedBox(height: 5),
                                    const Text('📝 Activity Logs:', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: List.generate(buyer['activityLogs'].length, (aIndex) {
                                        var log = buyer['activityLogs'][aIndex];
                                        return Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('📌 Title: ${log['title'] ?? 'N/A'}'),
                                              Text('📜 Description: ${log['description'] ?? 'N/A'}'),
                                              Text('🕒 Timestamp: ${_formatTimestamp(log['timestamp'])}'),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                        ),
                      ],

                      // Delete Button
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteLead(snapshot.data!.docs[index].id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
