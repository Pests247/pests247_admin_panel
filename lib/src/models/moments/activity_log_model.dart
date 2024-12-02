import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String action;
  final String details;
  final String userId;
  final Timestamp timestamp;

  ActivityLog(
      {required this.action,
      required this.userId,
      required this.details,
      required this.timestamp});

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      action: map['action'],
      userId: map['userId'],
      details: map['details'] ?? 'No Details',
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'details': details,
      'userId': userId,
      'timestamp': timestamp
    };
  }
}
