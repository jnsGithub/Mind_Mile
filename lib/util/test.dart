import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mind_mile/model/myInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredectedWellness{
  final db = FirebaseFirestore.instance;

  void realTest() async {
    Timestamp a = Timestamp.fromDate(DateTime.now());
    DateTime b = a.toDate();

    print(int.parse(DateFormat('yyyyMMdd').format(b)));
    print(b);

  }

  Future<int?> requestWellness(String uid) async {
    try{
      final snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).limit(7).get();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0);
      DateTime lastRecordAt = (snapshot.docs[0].data()['createAt'] as Timestamp).toDate();

      String url = 'https://demo-app-540150120260.asia-northeast3.run.app/predict_wellness';

      List<String> wordList = snapshot.docs.map((e) => e.data()['content'].toString()).toList();
      List<int> moodList = snapshot.docs.map((e) => e.data()['mood'] as int).toList();

      MyInfo? myInfo = await getMyInfo();
      Map<String, dynamic> myInfoMap = myInfo!.toMap();

      myInfoMap['textList'] = wordList;
      myInfoMap['moodList'] = moodList;
      print(jsonEncode(myInfoMap));
      if(lastRecordAt.isBefore(currentDate)){
        var response = await dio.Dio().post(
            url,
            data: jsonEncode(myInfoMap),
            options: dio.Options(
                headers: {
                  'Content-Type': 'application/json',
                },
            ),
        );
        if(response.statusCode == 200){
          final todayInt = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
          prefs.setInt('lastRequestDate', todayInt);
          prefs.setInt('wellness', response.data['predected_wellness']);
          prefs.setStringList('wordList', response.data['wordList'].map<String>((e) => e as String).toList());
          textList = response.data['wordList'].map<String>((e) => e as String).toList();
          print(textList);
          print(response.data);
          return response.data['predected_wellness'];
        }
        else{
          return prefs.getInt('wellness');
        }
      }
      else {
        return prefs.getInt('wellness');
      }
    } catch (e) {
      print('테스트');
      print(e);
      return 0;
    }
  }

  Future<MyInfo?> getMyInfo() async {
    try{
      DocumentSnapshot snapshot = await db.collection('users').doc(uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<int> gadScoreList = data['GAD7'].map<int>((e) => e as int).toList();
      List<int> phqScoreList = data['PHQ9'].map<int>((e) => e as int).toList();
      data['documentId'] = snapshot.id;
      data['gadScore'] = gadScoreList.reduce((value, element) => value + element);
      data['phqScore'] = phqScoreList.reduce((value, element) => value + element);
      data['sex'] = data['sex'] == 'M' ? 1 : 0;
      data['lastMood'] = await getLastMoodScore();
      data['age'] = DateTime.now().year - DateTime.parse(data['birthDate'].toString()).year;

      return MyInfo.fromMap(data);
    }catch (e){
      print('마이인포');
      print(e);
      return null;
    }
  }

  Future<List<int>> getLastMoodScore() async {
    List<int> moodScore = [];
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0);
    try{
      final snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).limit(7).get();
      for(int i = 1; i < 8; i++){
        moodScore.add(0);
        for(var j in snapshot.docs){
          DateTime date = (j.data()['createAt'] as Timestamp).toDate();
          date = DateTime(date.year, date.month, date.day, 0, 0, 0, 0);
          if(date.isAtSameMomentAs(currentDate.subtract(Duration(days: i)))){
            moodScore[i - 1] = j.data()['mood'];
          }
        }
      }
      return moodScore;
    } catch (e) {
      print('무드스코어');
      print(e);
      return moodScore;

    }
  }
}