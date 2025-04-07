import 'dart:async';
import 'package:intl/intl.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slidable_panel/flutter_slidable_panel.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/records.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/util/recordsInfo.dart';
import 'package:mind_mile/util/todoList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class TodoListController extends GetxController with SingleGetTickerProviderMixin{

  TextEditingController addController = TextEditingController();
  late FocusNode focusNode;
  RxBool hasFocus = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  TodoListInfo todoListInfo = TodoListInfo();

  // late SlidableController slidableController ;
  RxBool isEdit = false.obs;

  RxInt cupertinoTabBarIValue = 0.obs;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue.value;
  RxBool isAdd = false.obs;

  /*그룹 디테일*/
  RxBool isGroupEdit = false.obs;
  RxBool isDetail = false.obs;

  Rx<TodoListGroup> todoListGroupDetail = TodoListGroup(documentId: '1', lasteditAt: DateTime.now(), content: '당신의 첫 목표는?', todoList: [], createAt: DateTime.now(), color: 0xff32A8EB, sequence: 0).obs;
  RxBool isEmpty = false.obs;
  RxBool isCalendar = false.obs;
  RxBool isAlarm = false.obs;

  RxInt selectTap = 0.obs;
  PageController pageController = PageController();
  String selectedGroupId = '';

  ScrollController scrollController = ScrollController();
  // Rx<PointerMoveEvent> details = PointerMoveEvent().obs;
  // Rx<PointerDownEvent> offset = PointerDownEvent().obs;

  bool isScrolling = false;

  /*그룹 리스트*/
  RxList<DragAndDropList> contents = <DragAndDropList>[].obs;
  RxList<DragAndDropList> detailContents = <DragAndDropList>[].obs;
  RxList<SlideController> slidableGroupControllers = <SlideController>[].obs;
  RxList<bool> isGroupDragHandleVisibleList = <bool>[].obs;
  // RxBool isPress = false.obs;
  RxList<TodoListGroup> todoListGroup = <TodoListGroup>[].obs;

  // TodoList 받아오기
  RxList<TodoLists> todoList = <TodoLists>[].obs;
  RxList<RxBool> readOnlyList = <RxBool>[].obs;
  List<TextEditingController> todoListController = <TextEditingController>[].obs;
  List<FocusNode> focusNodeList = <FocusNode>[].obs;

  // 오늘 하루 기록
  RecordsInfo recordsInfo = RecordsInfo();
  RxList<Records> recordsList = <Records>[].obs;
  RxBool isVisible = false.obs;
  RxString dailyText = ''.obs;

  RxInt tabIndex = 1.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.week.obs;
  bool isDrag = false;

  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  RxBool isVisibility = false.obs;
  // RxString diaryText = ''.obs;

  @override
  onInit() async {
    super.onInit();
    await init();
    focusNode = FocusNode();
    focusNode.addListener(() {
      hasFocus.value = focusNode.hasFocus;
    });
    for (int i = 0; i < todoListGroup.length; i++) {
      slidableGroupControllers.add(SlideController(usePostActionController: true, usePreActionController: true));
      isGroupDragHandleVisibleList.add(true);
    }
  }


  init() async {
    await getTodoList();
    await getTodoListGroup();
    await getRecords();
    await setIsVisible();
  }

  getRecords() async {
    recordsList.value = await recordsInfo.getRecords();
  }

  updateComplete(TodoLists todo) {
    todoListInfo.updateComplete(todo.documentId, todo.complete.value);
    init();
  }


  // 할일 CRUD
  getTodoList() async {
    todoList.value = await todoListInfo.getTodayTodoList(selectedDate.value);
    readOnlyList.clear();
    todoListController.clear();
    focusNodeList.clear();
    for(int i = 0; i < todoList.length; i++){
      readOnlyList.add(true.obs);
      todoListController.add(TextEditingController(text: todoList[i].content));
      focusNodeList.add(FocusNode());
    }
  }
  setTodoList() async {

  }
  updateTodoList() async{
    await todoListInfo.updateIndex(todoList);
  }
  updateTodo(TodoLists todo) async {
    await todoListInfo.updateTodoList(todo);
    await init();
  }

  // 그룹 CRUD
  getTodoListGroup() async {
    todoListGroup.value = await todoListInfo.getTodoListGroup();
  }
  setTodoListGroup() async {
  }
  updateTodoListGroup() async {

  }

  changeTodoListGroup(newGroup, oldGroup, newTodoList, oldTodoList) async {
    await todoListInfo.updateIndexGroupInItem(newGroup, oldGroup, newTodoList, oldTodoList);
  }

  setIsVisible() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 11, 0);
    DateTime endTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);
    // bool isVisible = now.isAfter(startTime) && now.isBefore(endTime);
    if(now.hour >= 19){
      print('case 1');
      if(prefs.getInt('lastRecordDate') == int.parse(DateFormat('yyyyMMdd').format(DateTime.now()))){
        isVisible.value = false;
      }
      else{
        isVisible.value = true;
        dailyText.value = '오늘 하루는 어땠나요??';
      }
    }
    else if(now.hour < 19 && now.hour > 14){
      print('case 2');
      isVisible.value = false;
    }
    else if(now.hour <= 14){
      print('case 3');
      if((prefs.getInt('lastRecordDate') ?? int.parse(DateFormat('yyyyMMdd').format(DateTime.now())) - 1) <= int.parse(DateFormat('yyyyMMdd').format(DateTime.now())) - 1){
        print(prefs.getInt('lastRecordDate'));
        isVisible.value = true;
        if(groupValue == 0){
          dailyText.value = '어제의 하루는 어땠나요?';
        }
        else{
          if(wellness! < 3){
            dailyText.value = dailyWords['bad'][Random().nextInt(dailyWords['bad'].length)];
          }
          else if(wellness! < 5){
            dailyText.value = dailyWords['well'][Random().nextInt(dailyWords['well'].length)];
          }
          else{
            dailyText.value = dailyWords['good'][Random().nextInt(dailyWords['good'].length)];
          }
        }

      }
      else{
        isVisible.value = false;
      }
    }
  }

  void startAutoScroll(double direction) {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      scrollController.animateTo(
        scrollController.position.pixels + direction,
        duration: const Duration(milliseconds: 50),
        curve: Curves.linear,
      );
    });
  }

  void stopAutoScroll() {
    _isAutoScrolling = false;
    _autoScrollTimer?.cancel();
  }

  void autoScroll(Offset offset, Offset offset2) {
    if (offset.dy != offset2.dy) {
      // isScrolling = true;
      if(offset.dy > offset2.dy){
        scrollController
            .animateTo(
          offset2.dy,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        )
            .then((_) => isScrolling = false);
      }
      else{
        scrollController
            .animateTo(
          offset2.dy - scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
      }
    }
    else{
      scrollController
          .animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void changeCalendarFormat(CalendarFormat format) {
    calendarFormat.value = format;
  }


  diaryDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RxInt selectIndex = (-1).obs;
    bool isGroup1 = groupValue == 1;
    if(isGroup1){
      selectIndex.value = wellness ?? -1;
    }
    List<int> selectList = [0, 1, 2, 3, 4, 5, 6];
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showDialog(
        context: context,
        builder: (context){
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              titlePadding: EdgeInsets.zero,
              backgroundColor: const Color(0xffEAF6FF),
              title: Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: (){
                        Get.back();
                      },
                      icon: const Icon(Icons.close, color: Color(0xff133C6B),
                      )
                  )
              ),
              content: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: size.width * 0.9,
                  height: isGroup1 ? 400 : 480,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Text(isGroup1 ? '듀디가 어제 하루가 어땠을지 생각해 봤어.\n이렇게 기록해도 괜찮을지 한번 확인해 줘!' : '오늘 하루는 어땠어?', style: TextStyle(fontSize: isGroup1 ? 13 : 15, color: subColor, fontWeight: FontWeight.w600),),
                      const SizedBox(height: 20,),
                      Container(
                        width: size.width,
                        height: isGroup1 ? 136 : 97,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                        ),
                        child: Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('오늘 하루의 점수를 매겨봐 !', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w500),),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  a('assets/images/score/unselectTT.png',     'assets/images/score/selectTT.png', selectIndex, selectList[0], size.width*0.1154, 45),
                                  a('assets/images/score/unselectDefault.png',      'assets/images/score/select1.png', selectIndex, selectList[1], size.width*0.0513, 20),
                                  a('assets/images/score/unselectDefault.png',      'assets/images/score/select2.png', selectIndex, selectList[2], size.width*0.0513, 20),
                                  a('assets/images/score/unselectSoso.png',   'assets/images/score/selectSoso.png', selectIndex, selectList[3], size.width*0.1154, 45),
                                  a('assets/images/score/unselectDefault.png',      'assets/images/score/select3.png', selectIndex, selectList[4], size.width*0.0513, 20),
                                  a('assets/images/score/unselectDefault.png',      'assets/images/score/select4.png', selectIndex, selectList[5], size.width*0.0513, 20),
                                  a('assets/images/score/unselectHappy.png',  'assets/images/score/selectHappy.png', selectIndex, selectList[6], size.width*0.1154, 45),
                                ]
                              ),
                              isGroup1 ? Icon(Icons.info_outline, color: subColor, size: 10,) : const SizedBox(),
                              SizedBox(height: isGroup1 ? 5 : 0,),
                              isGroup1 ? const Text('듀디가 예측해서 임의로 기록한 점수에요.\n실제 어제 하루와 다르다면 수정해 주세요.',
                                style: TextStyle(
                                  fontSize: 9, color: Color(0xff6F6F6F), fontWeight: FontWeight.w500
                                ),) : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: size.width,
                        height: isGroup1 ? 140 : 270,
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10,),
                            Text('오늘의 일기 쓰기', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                    height: 50,
                                child: Text('제목 : ', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500))),
                                SizedBox(
                                  height: 50,
                                  width: size.width * 0.533,
                                  child: TextField(
                                    controller: titleController,
                                    style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 5),
                                      hintText: '제목은 한줄 일기가 돼 !',
                                      hintStyle: TextStyle(fontSize: 12, color: Color(0xffD9D9D9), fontWeight: FontWeight.w500),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                              width: size.width,
                              child: TextField(
                                controller: contentController,
                                maxLines: 20,
                                style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '일기쓰기...',
                                  hintStyle: TextStyle(fontSize: 12, color: Color(0xffD9D9D9), fontWeight: FontWeight.w500),
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: subColor,
                          minimumSize: Size(size.width*0.1744, 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                          onPressed: () async {
                          if(selectIndex.value == -1 || titleController.text == '' || contentController.text == ''){
                            if(!Get.isSnackbarOpen){
                              Get.snackbar('알림', '모든 항목을 입력해주세요.');
                            }
                            return;
                          }

                          int moodSort = 0;
                          if(selectIndex.value < 3){
                            moodSort = 1;
                          }
                          else if(selectIndex.value > 5){
                            moodSort = 2;
                          }
                          else{
                            moodSort = 1;
                          }
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setInt('lastRecordDate', int.parse(DateFormat('yyyyMMdd').format(DateTime.now())));
                          RecordsInfo recordsInfo = RecordsInfo();
                          saving(context);
                          await recordsInfo.setRecords(selectIndex.value, moodSort, titleController.text, contentController.text, groupValue == 1);
                          await init();
                          Get.back();
                          Get.back();
                          },
                          child: const Text('저장', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),)
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget a(String path, String path2, RxInt selectIndex, int index, double width, double height){
    return GestureDetector(
        onTap: (){
          selectIndex.value = index;
          print(index);
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: index != selectIndex.value ? AssetImage(path) : AssetImage(path2),
                  fit: BoxFit.fitWidth
              )
          ),
        ),
      );
  }


  var focusedDay = DateTime.now().obs;
  void previousMonth() {
    int month = focusedDay.value.month - 1;
    if(DateTime.now().month > month && DateTime.now().year == focusedDay.value.year) {
      if(!Get.isSnackbarOpen){
        // Get.snackbar('알림', '이전달에는 예약을 할 수 없습니다.');
      }
      return;
    }
    focusedDay.value = DateTime(
      focusedDay.value.year,
      month,
      DateTime.now().month == focusedDay.value.month - 1 ? DateTime.now().day : 1,
    );
    update();
  }

  void nextMonth() {
    if(DateTime.now().year + 1 == focusedDay.value.year && DateTime.now().month == focusedDay.value.month){
      if(!Get.isSnackbarOpen){
        // Get.snackbar('알림', '예약은 1년 이내로만 가능합니다.');
      }
      return;
    }
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month + 1,
      1,
    );
    update();
  }


  RxList<dynamic> length() {
    if (todoListGroupDetail.value.todoList.isNotEmpty) {
      RxList<DateTime> temp = [
        DateTime(todoListGroupDetail.value.todoList[0].date.year,
            todoListGroupDetail.value.todoList[0].date.month,
            todoListGroupDetail.value.todoList[0].date.day)
      ].obs;

      for (int i = 1; i < todoListGroupDetail.value.todoList.length; i++) {
        bool isDuplicate = false;
        // 현재 todoList의 날짜와 temp의 날짜를 비교
        for (int j = 0; j < temp.length; j++) {
          if (todoListGroupDetail.value.todoList[i].date.year == temp[j].year &&
              todoListGroupDetail.value.todoList[i].date.month == temp[j].month &&
              todoListGroupDetail.value.todoList[i].date.day == temp[j].day) {
            isDuplicate = true; // 중복된 날짜를 발견
            break; // 중복된 날짜가 있으므로 더 이상 비교할 필요 없음
          }
        }

        // 중복되지 않으면 temp에 추가
        if (!isDuplicate) {
          temp.add(DateTime(
            todoListGroupDetail.value.todoList[i].date.year,
            todoListGroupDetail.value.todoList[i].date.month,
            todoListGroupDetail.value.todoList[i].date.day,
          ));
        }
      }

      print(temp);
      return temp;
    } else {
      return <DateTime>[].obs;
    }
  }
}