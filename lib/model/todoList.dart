import 'package:get/get.dart';

class TodoList{
  final String documentId;
  String GroupId;
  String title;
  bool isAlarm;
  RxInt completeCount;
  DateTime createDate;

  TodoList({
    required this.documentId,
    required this.GroupId,
    required this.title,
    required this.isAlarm,
    required this.completeCount,
    required this.createDate,
  });

  factory TodoList.fromMap(Map<String, dynamic> data) {
    return TodoList(
      documentId: data['documentId'],
      GroupId: data['GroupId'],
      title: data['title'],
      isAlarm: data['isAlarm'],
      completeCount: data['completeCount'],
      createDate: data['createDate'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'GroupId': GroupId,
      'title': title,
      'isAlarm': isAlarm,
      'completeCount': completeCount,
      'createDate': createDate,
    };
  }
}