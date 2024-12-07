import 'package:cloud_firestore/cloud_firestore.dart';

class GifModel {
  final String id;
  final String gifUrl;

  GifModel({
    required this.id,
    required this.gifUrl,
  });

  toJson() {
    return {
      'id': id,
      'gifUrl': gifUrl,
    };
  }

  factory GifModel.fromDocument(DocumentSnapshot doc) {
    return GifModel(
      id: doc['id'],
      gifUrl: doc['gifUrl'],
    );
  }
}
