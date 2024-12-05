import 'package:get/get.dart';

class TodoLists{
  String documentId;
  String GroupId;
  String content;
  bool alarmTrue;
  DateTime? alarmAt;
  RxInt complete;
  DateTime createAt;
  DateTime completeTime;
  DateTime lasteditAt;
  DateTime date;

  int sequence;
  int? todayIndex;

  TodoLists({
    required this.documentId,
    required this.GroupId,
    required this.content,
    required this.alarmTrue,
    required this.alarmAt,
    required this.complete,
    required this.completeTime,
    required this.createAt,
    required this.sequence,
    required this.lasteditAt,
    required this.date,
    this.todayIndex = 0,
  });

  factory TodoLists.fromMap(Map<String, dynamic> data) {
    RxInt a = RxInt(data['complete']);
    // print(data);
    // print('여긴 오나?');
      return TodoLists(
        documentId: data['documentId'],
        GroupId: data['GroupId'],
        content: data['content'],
        alarmTrue: data['alarmTrue'],
        alarmAt: data['alarmAt'],
        complete: a,
        completeTime: data['completeTime'],
        createAt: data['createAt'],
        sequence: data['sequence'],
        todayIndex: data['todayIndex'],
        date: data['date'],
        lasteditAt: data['lasteditAt'],
      );
    }

  Map<String, dynamic> toMap() {
    return {
      // 'documentId': documentId,
      'GroupId': GroupId,
      'content': content,
      'alarmTrue': alarmTrue,
      'alarmAt': alarmAt,
      'complete': complete.value,
      'completeTime': completeTime,
      'createAt': createAt,
      'sequence': sequence,
      'date': date,
      'todayIndex': todayIndex,
      'lasteditAt': lasteditAt,
    };
  }
}