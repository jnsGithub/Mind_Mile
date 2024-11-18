import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/model/todoListGroup.dart';

class TodoListInfo{
  final db = FirebaseFirestore.instance.collection('users').doc(uid);

  // 그룹 리스트 받아오기
  Future<List<TodoListGroup>> getTodoListGroup() async {
    List<TodoListGroup> todoListGroup = [];
    try {
      QuerySnapshot snapshot = await db.collection('todoListGroup').orderBy('createDate', descending: true).get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createDate'] = data['createDate'].toDate();
        print(1);
        todoListGroup.add(TodoListGroup.fromMap(data));
      }
      return todoListGroup;
    } catch (e) {
      print('그룹 리스트 가져올때 걸림');
      print(e);
      return [];
    }
  }

  // 그룹 만들기
  Future<void> setTodoListGroup(String title, List<Map> todoList, int color, int index) async {
    try{
      await db.collection('todoListGroup').doc().set({
        'title': title,
        'todoList': todoList,
        'createDate': DateTime.now(),
        'color': color,
        'index': index,
      });
    } catch(e){
      print('그룹 만들기 가져올때 걸림');
      print(e);
    }
  }

  // 할일 추가
  Future<void> addTodoList(String GroupId, String title, bool isAlarm, DateTime alarmDate, int index) async {
    try{
      await db.collection('todoListGroup').doc(GroupId).update({
        'todoList': FieldValue.arrayUnion([
          {
            'GroupId': GroupId,
            'title': title,
            'isAlarm': isAlarm,
            'alarmDate': alarmDate,
            'completeCount' : 0,
            'createDate': DateTime.now(),
            'index': index,
          }
        ])
      });
      await db.collection('todoList').doc().set({
            'GroupId': GroupId,
            'title': title,
            'isAlarm': isAlarm,
            'alarmDate': alarmDate,
            'completeCount' : 0,
            'createDate': DateTime.now(),
            'index': index,
      });
    } catch(e){
      print('할일 추가 할때 걸림');
      print(e);
    }
  }

  // 오늘의 할일 받아오기 (리스트 버전)
  Future<List<TodoList>> getTodayTodoList1() async {
    try {
      List<TodoList> todoList = [];
      List<TodoListGroup> todoListGroup = await getTodoListGroup();
      for (var doc in todoListGroup) {
        for (var doc2 in doc.todoList) {
          if(doc2.createDate.year == DateTime.now().year && doc2.createDate.month == DateTime.now().month && doc2.createDate.day == DateTime.now().day){
            todoList.add(doc2);
          }
        }
      }
      for (int i = 0; i < todoList.length - 1; i++) {
        for(int j = 0; j < i; j++){
          if(todoList[i].index < todoList[j].index){
            TodoList temp = todoList[i];
            todoList[i] = todoList[j];
            todoList[j] = temp;
          }
        }
      }
      return todoList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // 오늘의 할일 받아오기 (도큐먼트 버전)
  Future<List<TodoList>> getTodayTodoList2(DateTime selectDate) async {
    try {
      List<TodoList> todoList = [];
      QuerySnapshot snapshot = await db.collection('todoList').get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createDate'] = data['createDate'].toDate();
        if(data['createDate'].year == selectDate.year && data['createDate'].month == selectDate.month && data['createDate'].day == selectDate.day){
          todoList.add(TodoList.fromMap(data));
        }
      }
      if(todoList.length > 1){
        for (int i = 0; i < todoList.length - 1; i++) {
          for(int j = 0; j < i; j++){
            if(todoList[i].index < todoList[j].index){
              TodoList temp = todoList[i];
              todoList[i] = todoList[j];
              todoList[j] = temp;
            }
          }
        }
      }
      return todoList;
    } catch (e) {
      print(e);
      return [];
    }
  }

}