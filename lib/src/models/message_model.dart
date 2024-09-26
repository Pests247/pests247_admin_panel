import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String senderId;
  final String message;
  final Timestamp timeStamp;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.timeStamp,
  });

  toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'message': message,
      'timeStamp': timeStamp
    };
  }

  factory MessageModel.fromDocument(DocumentSnapshot doc) {
    return MessageModel(
      messageId: doc['messageId'],
      senderId: doc['senderId'],
      message: doc['message'],
      timeStamp: (doc['timeStamp']),
    );
  }
}
