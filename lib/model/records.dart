import 'package:cloud_firestore/cloud_firestore.dart';

class Records{
  final String documentId;
  final int mood;
  final int moodSort;
  final String title;
  final String content;
  final bool predict;
  final DateTime createAt;

  Records({
    required this.documentId,
    required this.mood,
    required this.moodSort,
    required this.title,
    required this.content,
    required this.predict,
    required this.createAt,
  });

  factory Records.fromMap(Map<String, dynamic> data) {
    return Records(
      documentId: data['documentId'],
      mood: data['mood'],
      moodSort: data['moodSort'],
      title: data['title'],
      content: data['content'],
      predict: data['predict'],
      createAt: data['createAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mood': mood,
      'moodSort': moodSort,
      'title': title,
      'content': content,
      'predict': predict,
      'createAt': createAt,
    };
  }
}