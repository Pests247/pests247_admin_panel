class RoomModel {
  String title;
  String roomType;
  String tag;
  String createdBy;
  List<String> participants;
  String videoId;
  String roomID;
  int views;

  RoomModel(
      {required this.title,
      required this.roomType,
      required this.tag,
      required this.createdBy,
      required this.participants,
      required this.videoId,
      required this.roomID,
      required this.views});

  // Convert a RoomModel instance into a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'roomType': roomType,
      'tag': tag,
      'createdBy': createdBy,
      'participants': participants,
      'videoId': videoId,
      'roomId': roomID,
      'views': views
    };
  }

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
        title: json['title'],
        roomType: json['roomType'],
        tag: json['tag'],
        createdBy: json['createdBy'],
        participants: List<String>.from(json['participants']),
        videoId: json['videoId'],
        roomID: json['roomId'],
        views: json['views']);
  }
}
