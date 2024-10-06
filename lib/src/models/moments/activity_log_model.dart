import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLog {
  final String action;
  final String details;
  final Timestamp timestamp;

  ActivityLog(
      {required this.action, required this.details, required this.timestamp});

  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      action: map['action'],
      details: map['details'] ?? 'No Details',
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'details': details,
      'timestamp': timestamp,
    };
  }
}
