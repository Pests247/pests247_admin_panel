import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDetail {
  final String userId;
  final String commentId;
  final String userName;
  final String userProfilePicture;
  final String comment;
  final Timestamp timestamp;
  final List<CommentDetail> replies;

  CommentDetail({
    required this.userId,
    required this.userName,
    required this.userProfilePicture,
    required this.comment,
    required this.commentId,
    required this.timestamp,
    this.replies = const [],
  });

  factory CommentDetail.fromMap(Map<String, dynamic> map) {
    return CommentDetail(
      commentId: map['commentId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userProfilePicture: map['userProfilePicture'] ?? '',
      comment: map['comment'] ?? '',
      timestamp: map['timestamp'] as Timestamp,
      replies: (map['replies'] as List<dynamic>?)
              ?.map((reply) =>
                  CommentDetail.fromMap(reply as Map<String, dynamic>))
              .toList() ??
          [], // Deserialize replies
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'commentId': commentId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'comment': comment,
      'timestamp': timestamp,
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }
}
