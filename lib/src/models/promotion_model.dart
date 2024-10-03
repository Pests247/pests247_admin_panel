import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Promotion {
  String id; // Unique ID for the promotion
  String picture; // Required picture URL
  Timestamp dateAdded; // Date added as a timestamp, defaults to current time
  Timestamp? dateExpired; // Date expired as a timestamp
  String? text; // Text content for the promotion
  String? description; // Description of the promotion

  Promotion({
    String? id,
    required this.picture,
    Timestamp? dateAdded,
    this.dateExpired,
    this.text,
    this.description,
  })  : id = id ?? Uuid().v4(), // Set a new UUID if id is not provided
        dateAdded = dateAdded ??
            Timestamp.now(); // Set dateAdded to now if not provided

  // Convert a Promotion object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'picture': picture,
      'dateAdded': dateAdded,
      'dateExpired': dateExpired,
      'text': text,
      'description': description,
    };
  }

  // Create a Promotion object from a JSON map
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      picture: json['picture'],
      dateAdded: json['dateAdded'],
      dateExpired: json['dateExpired'],
      text: json['text'],
      description: json['description'],
    );
  }

  // Copy with method for cloning the object with new values
  Promotion copyWith({
    String? id,
    String? picture,
    Timestamp? dateAdded,
    Timestamp? dateExpired,
    String? text,
    String? description,
  }) {
    return Promotion(
      id: id ?? this.id,
      picture: picture ?? this.picture,
      dateAdded: dateAdded ?? this.dateAdded,
      dateExpired: dateExpired ?? this.dateExpired,
      text: text ?? this.text,
      description: description ?? this.description,
    );
  }
}
