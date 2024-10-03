import 'package:admin_dashboard/src/models/moments/comment_model.dart';
import 'package:admin_dashboard/src/models/moments/like_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MomentModel {
  String momentId;
  String userId;
  String userName;
  String userProfilePicture;
  String content;
  String mediaUrl;
  String mediaType;
  int likesCount;
  List<LikeDetail> likes;
  int commentsCount;
  List<CommentDetail> comments;
  Timestamp timestamp;

  MomentModel({
    required this.momentId,
    required this.userId,
    required this.userName,
    required this.userProfilePicture,
    required this.content,
    required this.mediaUrl,
    required this.mediaType,
    required this.likesCount,
    required this.likes,
    required this.commentsCount,
    required this.comments,
    required this.timestamp,
  });

  factory MomentModel.fromMap(Map<String, dynamic> map) {
    return MomentModel(
      momentId: map['postId'],
      userId: map['userId'],
      userName: map['userName'],
      userProfilePicture: map['userProfilePicture'],
      content: map['content'],
      mediaUrl: map['mediaUrl'],
      mediaType: map['mediaType'],
      likesCount: map['likesCount'],
      likes: (map['likes'] as List<dynamic>?)
              ?.map((like) => LikeDetail.fromMap(like as Map<String, dynamic>))
              .toList() ??
          [],
      commentsCount: map['commentsCount'] ?? 0,
      comments: (map['comments'] as List<dynamic>?)
              ?.map((comment) =>
                  CommentDetail.fromMap(comment as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: map['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': momentId,
      'userId': userId,
      'userName': userName,
      'userProfilePicture': userProfilePicture,
      'content': content,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'likesCount': likesCount,
      'likes': likes.map((like) => like.toMap()).toList(),
      'commentsCount': commentsCount,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'timestamp': timestamp,
    };
  }

  DateTime get dateTime => timestamp.toDate();
}
