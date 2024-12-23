import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/records.dart';

class RecordsInfo{
  final db = FirebaseFirestore.instance;

  // 기록 만들기
  Future<void> setRecords(int mood, int moodSort, String title, String content, bool predict) async {
    try{
      Records records = Records(
        documentId: '',
        mood: mood,
        moodSort: moodSort,
        title: title,
        content: content,
        predict: predict,
        createAt: DateTime.now(),
      );
      await db.collection('users').doc(uid).collection('Records').doc().set(records.toMap());
    } catch (e) {
      print('기록 만들기 실패');
      print(e);
    }
  }

  // 기록 리스트 받아오기
  Future<List<Records>> getRecords() async {
    List<Records> records = [];
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createAt'] = (data['createAt'] as Timestamp).toDate();
        records.add(Records.fromMap(data));
      }
      return records;
    } catch (e) {
      print('기록 리스트 가져올때 걸림');
      print(e);
      return [];
    }
  }

  Future<Map> getVisibleRecords() async {
    Map<String, dynamic> visibleRecords = {};
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        data['createAt'] = (data['createAt'] as Timestamp).toDate();
        visibleRecords[document.id] = data;
      }
      return visibleRecords;
    } catch (e) {
      print('기록 리스트 가져올때 걸림');
      print(e);
      return {};
    }
  }
}