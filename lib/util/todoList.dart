import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/model/todoListGroup.dart';

class TodoListInfo{
  final db = FirebaseFirestore.instance;

  // 그룹 리스트 받아오기
  Future<List<TodoListGroup>> getTodoListGroup() async {
    List<TodoListGroup> todoListGroup = [];
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('Goals').orderBy('sequence', descending: false).get();
      QuerySnapshot snapshot2 = await db.collection('users').doc(uid).collection('TodoLists').get();
      var a = await db.collection('users').doc(uid).collection('TodoLists').count().get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createAt'] = (data['createAt'] as Timestamp).toDate();
        data['lasteditAt'] = (data['lasteditAt'] as Timestamp).toDate();
        data['todoList'] = <TodoLists>[];
        for(QueryDocumentSnapshot doc in snapshot2.docs){
          if(doc['GroupId'] == document.id){
            Map<String, dynamic> data2 = doc.data() as Map<String, dynamic>;
            data2['documentId'] = doc.id;
            data2['createAt'] = (data2['createAt'] as Timestamp).toDate();
            data2['completeTime'] = (data2['completeTime'] as Timestamp).toDate();
            data2['lasteditAt'] = (data2['lasteditAt'] as Timestamp).toDate();
            data2['date'] = (data2['date'] as Timestamp).toDate();
            if(data2['alarmAt'] != null) {
              data2['alarmAt'] = (data2['alarmAt'] as Timestamp).toDate();
            }
            else{
              data2['alarmAt'] = null;
            }
            // data['todoList'] = data['todoList'] ?? [];
            data['todoList'].add(TodoLists.fromMap(data2));
          }
          for (int i = 0; i < data['todoList'].length; i++) {
            for(int j = 0; j < i; j++){
              if(data['todoList'][i].sequence! < data['todoList'][j].sequence!){
                TodoLists temp = data['todoList'][i];
                data['todoList'][i] = data['todoList'][j];
                data['todoList'][j] = temp;
              }
            }
          }
        }
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
  Future<void> setTodoListGroup(String content, int color, int sequence) async {
    try{
      final snapshot = await db.collection('users').doc(uid).collection('Goals').get();
      for(QueryDocumentSnapshot doc in snapshot.docs){
        db.collection('users').doc(uid).collection('Goals').doc(doc.id).update({
          'sequence': doc['sequence'] + 1,
        });
      }
      await db.collection('users').doc(uid).collection('Goals').doc().set({
        'content': content,
        'createAt': DateTime.now(),
        'date': DateTime.now(),
        'color': color,
        'sequence': 0,
        'lasteditAt': DateTime.now(),
      });
    } catch(e){
      print('그룹 만들기 가져올때 걸림');
      print(e);
    }
  }

  Future<void> updateTodoListGroup(String docId, int color) async {
    try{
      await db.collection('users').doc(uid).collection('Goals').doc(docId).update(
        {
          'color': color,
        }
      );
    } catch(e){
      print('그룹 만들기 가져올때 걸림');
      print(e);
    }
  }

  // 그룹 삭제
  Future<void> deleteTodoListGroup(String groupId) async {
    try{
      await db.collection('users').doc(uid).collection('Goals').doc(groupId).delete();
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').where('GroupId', isEqualTo: groupId).get();
      QuerySnapshot snapshot2 = await db.collection('users').doc(uid).collection('Goals').where('content', isEqualTo: '목표 없는 리스트').get();
      QuerySnapshot snapshot3 = await db.collection('users').doc(uid).collection('TodoLists').where('GroupId', isEqualTo: snapshot2.docs[0].id).get();
      int i = snapshot3.docs.length;
      for (QueryDocumentSnapshot document in snapshot.docs) {
        await db.collection('users').doc(uid).collection('TodoLists').doc(document.id).update({
          'GroupId': snapshot2.docs[0].id,
          'sequence': i++,
        });
      }
    } catch(e){
      print('그룹 삭제 가져올때 걸림');
      print(e);
    }
  }

  // 할일 추가
  Future<void> addTodoLists(TodoLists todoList, {bool? isInit}) async {//, String goalId, String goal, String content, bool alarmTrue, DateTime? alarmAt, int sequence, {int? todayIndex}) async {
    try{
      if(isInit == null){
        String groupId = '';
        QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('Goals').where('content', isEqualTo: '목표 없는 리스트').get();
        for (QueryDocumentSnapshot document in snapshot.docs) {
          groupId = document.id;
        }
        todoList.GroupId = groupId;
        // todoList.sequence = snapshot.docs.length;

        await db.collection('users').doc(uid).collection('TodoLists').doc().set(todoList.toMap());
      }
      else{
        QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').where('GroupId', isEqualTo: todoList.GroupId).get();
        QuerySnapshot snapshot2 = await db.collection('users').doc(uid).collection('TodoLists').orderBy('date', descending: false).get();
        todoList.todayIndex = snapshot2.docs.length; // TODO: 이거 null로 해야되나?
        todoList.sequence = snapshot.docs.length;
        await db.collection('users').doc(uid).collection('TodoLists').doc(todoList.documentId).set(todoList.toMap());
      }

    } catch(e){
      print('할일 추가 할때 걸림');
      print(e);
    }
  }

  Future<void> deleteTodoLists(String documentId, List<TodoLists> list, String groupId) async {
    try{
      await db.collection('users').doc(uid).collection('TodoLists').doc(documentId).delete();
      // QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').orderBy('todayIndex', descending: false).get();
      QuerySnapshot snapshot2 = await db.collection('users').doc(uid).collection('TodoLists').where('GroupId', isEqualTo: groupId).orderBy('sequence', descending: false).get();
      for (int i = 0; i < list.length; i++) {
        if(list[i].date.year == DateTime.now().year && list[i].date.month == DateTime.now().month && list[i].date.day == DateTime.now().day){
          await db.collection('users').doc(uid).collection('TodoLists').doc(list[i].documentId).update({
            'todayIndex': i,
          });
        }
        // await db.collection('users').doc(uid).collection('TodoLists').doc(snapshot.docs[i].id).update({
        //   'todayIndex': i,
        // });
      }
      for (int i = 0; i < snapshot2.docs.length; i++) {
        await db.collection('users').doc(uid).collection('TodoLists').doc(snapshot2.docs[i].id).update({
          'sequence': i,
        });
      }
      
    } catch(e){
      print('할일 삭제 할때 걸림');
      print(e);
    }
  }

  // 오늘의 할일 받아오기
  Future<List<TodoLists>> getTodayTodoList(DateTime selectDate) async {
    try {
      List<TodoLists> todoList = [];
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').orderBy('date', descending: false).get();
      int i = 0;
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createAt'] = (data['createAt'] as Timestamp).toDate();
        data['completeTime'] = (data['completeTime'] as Timestamp).toDate();
        data['lasteditAt'] = (data['lasteditAt'] as Timestamp).toDate();
        data['date'] = (data['date'] as Timestamp).toDate();
        if(data['todayIndex'] == null){
          data['todayIndex'] = i++;
        }
        if(data['alarmAt'] != null) {
          data['alarmAt'] = (data['alarmAt'] as Timestamp).toDate();
        }
        else{
          data['alarmAt'] = null;
        }
        if(data['date'].year == selectDate.year && data['date'].month == selectDate.month && data['date'].day == selectDate.day){
          todoList.add(TodoLists.fromMap(data));
        }
      }
      if(todoList.length > 1){
        for (int i = 0; i < todoList.length; i++) {
          for(int j = 0; j < i; j++){
            if(todoList[i].todayIndex! < todoList[j].todayIndex!){
              TodoLists temp = todoList[i];
              todoList[i] = todoList[j];
              todoList[j] = temp;
            }
          }
        }
      }
      return todoList;
    } catch (e) {
      print('오늘 할일 가져올때 걸림');
      print(e);
      return [];
    }
  }

  // 그룹 순서 변경
  Future<void> updateIndexGroup(List<TodoListGroup> list) async {
    try {
      for (int i = 0; i < list.length; i++) {
        await db.collection('users').doc(uid).collection('Goals').doc(list[i].documentId).update({
          'sequence': list[i].sequence,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // 그룹내 아이템 순서 바꾸기
  Future<void> updateIndexGroupInItem(TodoListGroup newGroup, TodoListGroup oldGroup, List<TodoLists> newTodoList, List<TodoLists> oldTodoList) async {
    try {
      if(newGroup.documentId != oldGroup.documentId) {
        for (var i in newTodoList) {
          if (i.GroupId != newGroup.documentId) {
            await db.collection('users').doc(uid).collection('TodoLists').doc(
                i.documentId).update({
              'GroupId': newGroup.documentId,
            });
          }
          await db.collection('users').doc(uid).collection('TodoLists').doc(i.documentId).update({
            'sequence': i.sequence,
          });
        }
        for (var i in oldTodoList) {
          await db.collection('users').doc(uid).collection('TodoLists').doc(i.documentId).update({
            'sequence': i.sequence,
          });
        }
      }
      for (var i in oldTodoList) {
        await db.collection('users').doc(uid).collection('TodoLists').doc(i.documentId).update({
          'sequence': i.sequence,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // 그룹 디테일 내에서 순서(날짜) 변경
  Future<void> updateGroupInItemIndex(String docId, DateTime date) async {
    try {
      await db.collection('users').doc(uid).collection('TodoLists').doc(docId).update({
        'date': date,
        'alarmAt': null,
        'alarmTrue': false,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTodoListAlarm(String docId, bool alarmTrue, int hour, int min) async {
    if(alarmTrue){
      DateTime date = DateTime.now();
      date = DateTime(date.year, date.month, date.day, hour, min);
      await db.collection('users').doc(uid).collection('TodoLists').doc(docId).update({
        'alarmTrue': true,
        'alarmAt': date,
      });
    }
    else{
      await db.collection('users').doc(uid).collection('TodoLists').doc(docId).update({
        'alarmTrue': false,
        'alarmAt': null,
      });
    }
  }

  // 오늘 할일 순서 변경 업데이트
  Future<void> updateIndex(List<TodoLists> list) async {
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        for (var i in list) {
          if(document.id == i.documentId){
            await db.collection('users').doc(uid).collection('TodoLists').doc(document.id).update({
              'todayIndex': i.todayIndex,
            });
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTodoList(TodoLists todo) async {
    try {
      print(todo.documentId);
      print(todo.content);
      await db.collection('users').doc(uid).collection('TodoLists').doc(todo.documentId).update({
        'content': todo.content,
      });
    } catch (e) {
      print(e);
    }
  }

  // 완료 정도 업데이트
  Future<void> updateComplete(String documentId, int complete) async {
    try {
      await db.collection('users').doc(uid).collection('TodoLists').doc(documentId).update({
        'complete': complete,
        'completeTime': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

}