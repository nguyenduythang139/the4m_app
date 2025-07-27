import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String id;
  final String image;
  final String title;
  final String midImageUrl;
  final List<String> hashtags;
  final String date;
  final String content1;
  final String content2;
  final String blogType;

  BlogModel({
    required this.id,
    required this.image,
    required this.title,
    required this.midImageUrl,
    required this.hashtags,
    required this.date,
    required this.content1,
    required this.content2,
    required this.blogType,
  });

  factory BlogModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      id: doc.id,
      image: data['image'] ?? '',
      title: data['title'] ?? '',
      midImageUrl: data['midImageUrl'] ?? '',
      hashtags: List<String>.from(data['hashtags'] ?? []),
      date: data['date'] ?? '',
      content1: data['content1'] ?? '',
      content2: data['content2'] ?? '',
      blogType: data['blogType'] ?? '',
    );
  }
}
