import 'package:get/get.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListGroup{
  final String documentId;
  String content;
  List<TodoLists> todoList;
  final DateTime createAt;
  DateTime lasteditAt;
  int color;
  int sequence;



  TodoListGroup({
    required this.documentId,
    required this.content,
    required this.todoList,
    required this.createAt,
    required this.lasteditAt,
    required this.color,
    required this.sequence,
  });

  factory TodoListGroup.fromMap(Map<String, dynamic> data) {
    // List<TodoLists> todoListGroup = [];
    // for (var doc in data['todoList']) {
    //   print(doc);
    //   Map<String, dynamic> data = doc as Map<String, dynamic>;
    //   data['documentId'] = doc.hashCode.toString();
    //   todoListGroup.add(TodoLists.fromMap(data));
    // }
    return TodoListGroup(
      documentId: data['documentId'],
      content: data['content'],
      todoList: data['todoList'],
      createAt: data['createAt'],
      lasteditAt: data['lasteditAt'],
      color: data['color'],
      sequence: data['sequence'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'content': content,
      'todoList': todoList,
      'createAt': createAt,
      'lasteditAt': lasteditAt,
      'color': color,
      'sequence': sequence,
    };
  }
}