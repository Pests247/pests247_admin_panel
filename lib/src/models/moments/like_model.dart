class LikeDetail {
  final String userId;
  final bool status;

  LikeDetail({required this.userId, required this.status});

  factory LikeDetail.fromMap(Map<String, dynamic> map) {
    return LikeDetail(
      userId: map['userId'] ?? '',
      status: map['status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
    };
  }
}
