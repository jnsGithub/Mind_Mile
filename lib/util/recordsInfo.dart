import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/records.dart';
import 'package:intl/intl.dart';


class RecordsInfo{
  final db = FirebaseFirestore.instance;

  // 기록 만들기
  Future<void> setRecords(int mood, int moodSort, String title, String content, bool predict) async {
    try{
      DateTime now = DateTime.now();
      if(now.hour < 12){
        now = DateTime(now.year, now.month, now.day - 1);
      }
      Records records = Records(
        documentId: '',
        mood: mood + 1,
        moodSort: moodSort,
        title: title,
        content: content,
        predict: predict,
        createAt: now,
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
        data['mood'] = data['mood'];
        records.add(Records.fromMap(data));
      }
      return records;
    } catch (e) {
      print('기록 리스트 가져올때 걸림');
      print(e);
      return [];
    }
  }

  Future<int> getVisibleRecords() async {
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).limit(1).get();
      Map<String, dynamic> data = snapshot.docs[0].data() as Map<String, dynamic>;
      if(data.isEmpty) {
        return 0;
      }
      return int.parse(DateFormat('yyyyMMdd').format((data['createAt'] as Timestamp).toDate()));
    } catch (e) {
      print('기록 리스트 가져올때 걸림');
      print(e);
      return int.parse(DateFormat('yyyyMMdd').format(DateTime.now())) - 1;
    }
  }
}