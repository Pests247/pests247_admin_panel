import 'package:cloud_firestore/cloud_firestore.dart';

class QueryModel {
  final String id; // Document ID
  final String name;
  final String details;
  final String status;
  final String title;
  final String userId;
  final Timestamp submittedTime;
  final String? reply; // Nullable because it may not exist initially
  final Timestamp? replyTime; // Nullable because it may not exist initially

  QueryModel({
    required this.id,
    required this.name,
    required this.details,
    required this.status,
    required this.title,
    required this.userId,
    required this.submittedTime,
    this.reply,
    this.replyTime,
  });

  // Convert a QueryModel into a map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'status': status,
      'title': title,
      'userId': userId,
      'submittedTime': submittedTime,
      'reply': reply,
      'replyTime': replyTime,
    };
  }

  // Create a QueryModel from a Firestore document snapshot
  factory QueryModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QueryModel(
      id: doc.id,
      name: data['name'],
      details: data['details'],
      status: data['status'],
      title: data['title'],
      userId: data['userId'],
      submittedTime: data['submittedTime'],
      reply: data['reply'],
      replyTime: data['replyTime'],
    );
  }
}
