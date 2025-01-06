import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mind_mile/model/records.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/util/diary.dart';
import 'package:mind_mile/util/recordsInfo.dart';
import 'package:mind_mile/util/todoList.dart';

class DiaryController extends GetxController {
  List<String> diaryList = ['친구', '먹다', '오다', '다투다', '하루',' 일본',' 맛있다', '만나다'];
  RxList<TodoListGroup> todoListGroup = <TodoListGroup>[].obs;

  DiaryInfo diaryInfo = DiaryInfo();
  RecordsInfo recordsInfo = RecordsInfo();
  RxList<Records> records = <Records>[].obs;
  TodoListInfo todoListInfo = TodoListInfo();

  GlobalKey barChart1 = GlobalKey();
  GlobalKey barChart2 = GlobalKey();

  RxInt week = 0.obs;
  RxDouble maxY = 0.0.obs;

  RxList<List<double>> weeklyTodoList = <List<double>>[[0, 0, 0, 0, 0 ,0, 0], [0, 0, 0, 0, 0 ,0, 0]].obs;
  RxMap<String, double> weeklyFeelingScore = {
    'sun': -1.toDouble(),
    'mon': -1.toDouble(),
    'tue': -1.toDouble(),
    'wed': -1.toDouble(),
    'thu': -1.toDouble(),
    'fri': -1.toDouble(),
    'sat': -1.toDouble(),
  }.obs;
  RxMap<String, String> weeklyDate = {
    'sun': '',
    'mon': '',
    'tue': '',
    'wed': '',
    'thu': '',
    'fri': '',
    'sat': '',
  }.obs;

  @override
  void onInit() {
    super.onInit();
    init();
    print(maxY.value);
  }
  @override
  void onClose() {
    super.onClose();
  }

  init() async {
    await getTodoListGroup();
    await getRecords();
    await getWeeklyTodoList();
    await getWeeklyFeelingScore();
    await getWeeklyDate();
  }

  getTodoListGroup() async {
    todoListGroup.value = await todoListInfo.getTodoListGroup();
  }

  getWeeklyTodoList() async {
    maxY.value = 0;
    weeklyTodoList.value = await diaryInfo.getWeeklyTodoListCount(week.value);
    for(int i = 0; i < weeklyTodoList[0].length; i++){
      if(weeklyTodoList[0][i] > maxY.value){
        maxY.value = weeklyTodoList[0][i];
      }
    }
    // print('maxY : ${maxY.value}');
    // print(maxY.value);
  }

  getRecords() async {
    records.value = await recordsInfo.getRecords();
  }

  getWeeklyFeelingScore() async {
    weeklyFeelingScore.value = await diaryInfo.getWeeklyFeelingScore(week.value);
  }

  getWeeklyDate() async {
    weeklyDate.value = await diaryInfo.getWeeklyDate(week.value);
  }
}