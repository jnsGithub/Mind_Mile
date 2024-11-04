import 'package:mind_mile/model/todoList.dart';

class TodoListGroup{
  final String documentId;
  String title;
  List<TodoList> todoList;
  final DateTime createDate;
  int color;


  TodoListGroup({
    required this.documentId,
    required this.title,
    required this.todoList,
    required this.createDate,
    required this.color,
  });

  factory TodoListGroup.fromMap(Map<String, dynamic> data) {
    return TodoListGroup(
      documentId: data['documentId'],
      title: data['title'],
      todoList: data['todoList'],
      createDate: data['createDate'].toDate(),
      color: data['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'title': title,
      'todoList': todoList,
      'createDate': createDate,
      'color': color,
    };
  }
}