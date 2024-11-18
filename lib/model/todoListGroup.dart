import 'package:get/get.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListGroup{
  final String documentId;
  String title;
  List<TodoList> todoList;
  final DateTime createDate;
  int color;
  int index;



  TodoListGroup({
    required this.documentId,
    required this.title,
    required this.todoList,
    required this.createDate,
    required this.color,
    required this.index,
  });

  factory TodoListGroup.fromMap(Map<String, dynamic> data) {
    List<TodoList> todoListGroup = [];
    for (var doc in data['todoList']) {
      print(doc);
      Map<String, dynamic> data = doc as Map<String, dynamic>;
      data['documentId'] = doc.hashCode.toString();
      todoListGroup.add(TodoList.fromMap(data));
    }

    return TodoListGroup(
      documentId: data['documentId'],
      title: data['title'],
      todoList: todoListGroup,
      createDate: data['createDate'],
      color: data['color'],
      index: data['index'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'title': title,
      'todoList': todoList,
      'createDate': createDate,
      'color': color,
      'index': index,
    };
  }
}