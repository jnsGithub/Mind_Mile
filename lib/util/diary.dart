import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mile/global.dart';
import 'package:intl/intl.dart';

class DiaryInfo{
  final db = FirebaseFirestore.instance;
  DateTime currentDate = DateTime.now();

  // 일기 가져오기
  Future<List> getDiaryList() async {
    List diaryList = [];
    Map<DateTime, List> diaryMap = {};
    try {
      QuerySnapshot snapshot = await db.collection('users').doc(uid).collection('TodoLists').get();
      for (QueryDocumentSnapshot document in snapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        data['documentId'] = document.id;
        diaryList.add(data);
      }
      return diaryList;
    } catch (e) {
      print('일기 리스트 가져올때 걸림');
      print(e);
      return [];
    }
  }

  // 한 주간의 나 n주차 데이터 받아오기
  Future<List<List<double>>> getWeeklyTodoListCount(int num) async {
    try {
      List<List<DateTime>> weekList = [];
      List<double> weekMaxCountList = [0, 0, 0, 0, 0, 0, 0];
      List<double> weekCompleteList = [0, 0, 0, 0, 0, 0, 0];
      QuerySnapshot<Map> snapshot = await db.collection('users').doc(uid).collection('TodoLists').orderBy('date', descending: true).get();
      for(int i = 0 ; i < snapshot.docs.length; i++){
        var date = (snapshot.docs[i].data()['date'] as Timestamp).toDate();
        print(snapshot.docs.length);
        if(date.subtract(Duration(days: date.weekday)).isBefore(currentDate)){
          for(int j = 0; j <= getWeek(date, 0); j++){
            if(weekList.length <= getWeek(date, 0)){
              weekList.add([]);
            }
          }
          if(weekList.length <= getWeek(date, 0)){
            // weekList.add([]);
            print(getWeek(date, 0));
            print(weekList.length);
          }
          DateTime temp = DateTime(date.year, date.month, date.day, 0, 0, 0, 0);
          print(1);
          weekList[getWeek(date, 0)].add(temp);
          print(2);

        }
      }
      print(weekList);
      for(int i = 0; i < weekList[num].length; i++){
        DateTime date = (snapshot.docs[i].data()['date'] as Timestamp).toDate();
        if(weekList[num][i].isAtSameMomentAs(DateTime(date.year, date.month, date.day, 0, 0, 0, 0))){
          if(snapshot.docs[i].data()['complete'] == 2){
            if(weekList[num][i].weekday == 7){
              weekCompleteList[0]++;
            }
            else if(weekList[num][i].weekday == 1){
              weekCompleteList[1]++;
            }
            else if(weekList[num][i].weekday == 2){
              weekCompleteList[2]++;
            }
            else if(weekList[num][i].weekday == 3){
              weekCompleteList[3]++;
            }
            else if(weekList[num][i].weekday == 4){
              weekCompleteList[4]++;
            }
            else if(weekList[num][i].weekday == 5){
              weekCompleteList[5]++;
            }
            else if(weekList[num][i].weekday == 6) {
              weekCompleteList[6]++;
            }
          }
        }
      }
      for(int i = 0; i < weekList[num].length; i++){
        if(weekList[num][i].weekday == 7){
          // print('일요일 : ${weekList[num][i]}');
          weekMaxCountList[0]++;
        }
        else if(weekList[num][i].weekday == 1){
          // print('월요일 : ${weekList[num][i]}');
          weekMaxCountList[1]++;
        }
        else if(weekList[num][i].weekday == 2){
          // print('화요일 : ${weekList[num][i]}');
          weekMaxCountList[2]++;
        }
        else if(weekList[num][i].weekday == 3){
          // print('수요일 : ${weekList[num][i]}');
          weekMaxCountList[3]++;
        }
        else if(weekList[num][i].weekday == 4){
          // print('목요일 : ${weekList[num][i]}');
          weekMaxCountList[4]++;
        }
        else if(weekList[num][i].weekday == 5){
          // print('금요일 : ${weekList[num][i]}');
          weekMaxCountList[5]++;
        }
        else if(weekList[num][i].weekday == 6){
          // print('토요일 : ${weekList[num][i]}');
          weekMaxCountList[6]++;
        }
      }

      // print(weekMaxCountList);
      // print(weekCompleteList);
      // print(weekList);
      return [weekMaxCountList, weekCompleteList];
    } catch (e) {
      print('일기 추가할때 걸림');
      print(e);
      return [[0,0,0,0,0,0,0], [0,0,0,0,0,0,0]];
    }
  }

  // 한 주간의 기분점수 n주차 데이터 받아오기
  Future<Map<String, double>> getWeeklyFeelingScore(int num) async {
    Map<String, double> feelingScore = {
      'sun': 0.toDouble(),
      'mon': 0.toDouble(),
      'tue': 0.toDouble(),
      'wed': 0.toDouble(),
      'thu': 0.toDouble(),
      'fri': 0.toDouble(),
      'sat': 0.toDouble(),
    };
    try{
      QuerySnapshot<Map> snapshot = await db.collection('users').doc(uid).collection('Records').orderBy('createAt', descending: true).get();

      for(int i = 0; i < snapshot.docs.length; i++){
        DateTime date = (snapshot.docs[i].data()['createAt'] as Timestamp).toDate();
        if(date.subtract(Duration(days: date.weekday)).isBefore(currentDate)){
          if(getWeek(date, 0) == num){
            double mood = (snapshot.docs[i].data()['mood'] as int).toDouble();
            if(date.weekday == 7){
              feelingScore['sun'] = mood;
            }
            else if(date.weekday == 1){
              feelingScore['mon'] = mood;
            }
            else if(date.weekday == 2){
              feelingScore['tue'] = mood;
            }
            else if(date.weekday == 3){
              feelingScore['wed'] = mood;
            }
            else if(date.weekday == 4){
              feelingScore['thu'] = mood;
            }
            else if(date.weekday == 5){
              feelingScore['fri'] = mood;
            }
            else if(date.weekday == 6){
              feelingScore['sat'] = mood;
            }
          }
        }
      }
      // print(feelingScore);

      return feelingScore;
    } catch (e) {
      print('기분점수 가져올때 걸림');
      print(e);
      return feelingScore;
    }
  }

  Future<Map<String, String>> getWeeklyDate(int num) async {
    DateTime mood = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
    mood = DateTime(mood.year, mood.month, mood.day, 0, 0, 0, 0);
    mood = mood.subtract(Duration(days: num * 7));
    DateFormat.M('ko_KR').format(mood);
    Map<String, String> weeklyDate = {
      'sun': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood),
      'mon': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 1))),
      'tue': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 2))),
      'wed': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 3))),
      'thu': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 4))),
      'fri': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 5))),
      'sat': DateFormat('yyyy.MM.dd', 'ko_KR').format(mood.add(Duration(days: 6))),
    };
    // print(weeklyDate);
    return weeklyDate;
  }

  // n주차 계산
  int getWeek(DateTime date, int week) {
    while (true) {
      // 현재 주의 시작 날짜 계산
      DateTime currentStartOfWeek = currentDate.subtract(Duration(days: currentDate.weekday + week * 7));
      // 주어진 날짜의 주 시작 날짜 계산
      DateTime dateStartOfWeek = date.subtract(Duration(days: date.weekday == 7 ? 0 : date.weekday));
      currentStartOfWeek = DateTime(currentStartOfWeek.year, currentStartOfWeek.month, currentStartOfWeek.day, 0, 0, 0, 0);
      dateStartOfWeek = DateTime(dateStartOfWeek.year, dateStartOfWeek.month, dateStartOfWeek.day, 0, 0, 0, 0);
      if (dateStartOfWeek.isAtSameMomentAs(currentStartOfWeek)) {
        return week;
      } else {
        // 다음 주 확인
        week++;
      }
    }
  }
}