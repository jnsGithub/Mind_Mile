import 'package:get/get.dart';

class TodoList{
  final String documentId;
  String GroupId;
  String title;
  bool isAlarm;
  DateTime? alarmDate;
  RxInt completeCount;
  DateTime createDate;
  int index;

  TodoList({
    required this.documentId,
    required this.GroupId,
    required this.title,
    required this.isAlarm,
    required this.alarmDate,
    required this.completeCount,
    required this.createDate,
    required this.index,
  });

  factory TodoList.fromMap(Map<String, dynamic> data) {
    RxInt a = RxInt(data['completeCount']);
    return TodoList(
      documentId: data['documentId'],
      GroupId: data['GroupId'],
      title: data['title'],
      isAlarm: data['isAlarm'],
      alarmDate: data['alarmDate'].toDate() ,
      completeCount: a,
      createDate: data['createDate'].toDate(),
      index: data['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'GroupId': GroupId,
      'title': title,
      'isAlarm': isAlarm,
      'alarmDate': alarmDate,
      'completeCount': completeCount,
      'createDate': createDate,
      'index': index,
    };
  }
}