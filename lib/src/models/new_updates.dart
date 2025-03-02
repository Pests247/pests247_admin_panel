import 'package:cloud_firestore/cloud_firestore.dart';

class NewUpdate {
  final String updateTitle;
  final String updateDescription;
  final String updateNumber;
  final DateTime updateTime;

  NewUpdate({
    required this.updateTitle,
    required this.updateDescription,
    required this.updateNumber,
    required this.updateTime,
  });

  // Convert Firestore document to NewUpdate object
  factory NewUpdate.fromMap(Map<String, dynamic> data) {
    return NewUpdate(
      updateTitle: data['updateTitle'] ?? '',
      updateDescription: data['updateDescription'] ?? '',
      updateNumber: data['updateNumber'] ?? '',
      updateTime: (data['updateTime'] as Timestamp).toDate(),
    );
  }

  // Convert NewUpdate object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'updateTitle': updateTitle,
      'updateDescription': updateDescription,
      'updateNumber': updateNumber,
      'updateTime': updateTime,
    };
  }
}
