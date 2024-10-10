import 'package:cloud_firestore/cloud_firestore.dart';

class RankModel {
  final String id;
  final String badge;
  final String benefits;
  final String name;
  final double points;

  RankModel({
    required this.id,
    required this.badge,
    required this.benefits,
    required this.name,
    required this.points,
  });

  // Convert a Rank instance into a map to store in Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'badge': badge,
      'benefits': benefits,
      'name': name,
      'points': points,
    };
  }

  // Create a Rank instance from a Firestore document.
  factory RankModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RankModel(
      id: data['id'],
      badge: data['badge'],
      benefits: data['benefits'],
      name: data['name'],
      points: (data['points'] as num).toDouble(),
    );
  }
}
