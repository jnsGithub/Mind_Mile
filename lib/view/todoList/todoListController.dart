import 'dart:async';

import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/util/todoList.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListController extends GetxController with SingleGetTickerProviderMixin{
  TextEditingController addController = TextEditingController();

  TodoListInfo todoListInfo = TodoListInfo(); // 지워야함

  // late SlidableController slidableController ;
  RxBool isEdit = false.obs;

  RxInt cupertinoTabBarIValue = 0.obs;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue.value;
  RxBool isAdd = false.obs;

  /*그룹 디테일*/
  RxBool isGroupEdit = false.obs;
  RxBool isDetail = false.obs;
  Rx<TodoListGroup> todoListGroupDetail = TodoListGroup(documentId: '1', title: '당신의 첫 목표는?', todoList: [], createDate: DateTime.now(), color: 0xff32A8EB, index: 0).obs;
  RxBool isEmpty = false.obs;
  RxBool isCalendar = false.obs;
  RxBool isAlarm = false.obs;

  RxInt selectTap = 0.obs;
  PageController pageController = PageController();

  ScrollController scrollController = ScrollController();
  Rx<PointerMoveEvent> details = PointerMoveEvent().obs;
  Rx<PointerDownEvent> offset = PointerDownEvent().obs;

  bool isScrolling = false;

  /*그룹 리스트*/
  RxList<DragAndDropList> contents = <DragAndDropList>[].obs;
  RxList<SlidableController> slidableGroupControllers = <SlidableController>[].obs;
  RxList<bool> isGroupDragHandleVisibleList = <bool>[].obs;
  RxBool isPress = false.obs;


  RxList<TodoList> todoList = <TodoList>[
    TodoList(documentId: '1', GroupId: '1', title: '오른쪽 하단 +를 눌러 할일을 등록하세요', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 0),
    TodoList(documentId: '1', GroupId: '1', title: '목록의 순서를 오른쪽 = 를 잡고 드래그해서 바꿔보세요', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 1),
    TodoList(documentId: '1', GroupId: '1', title: '목록을 왼쪽으로 슬라이드해서 알람 설정과 삭제 기능을 구현해보세요!', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 2),
    TodoList(documentId: '1', GroupId: '1', title: '목표별 할일에서 목표별로 할일을 관리해보세요', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 3),
    TodoList(documentId: '1', GroupId: '1', title: '워라벨 지킴이 목표의 할 일으로는 나만의 릴렉스 루틴을 한가지라도 적어주세요. 듀디것부터 공개할게요!', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 4),
    TodoList(documentId: '1', GroupId: '1', title: '밥먹고 산책하기', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 5),
    TodoList(documentId: '1', GroupId: '1', title: '10시 이후에 일 안하기', isAlarm: true, alarmDate: DateTime.now(), completeCount: 0.obs, createDate: DateTime.now(), index: 6),
  ].obs;

  RxList<String> testText = <String>[
    '오른쪽 하단 +를 눌러 할일을 등록하세요',
    '목록의 순서를 오른쪽 = 를 잡고 드래그해서 바꿔보세요',
    '목록을 왼쪽으로 슬라이드해서 알람 설정과 삭제 기능을 구현해보세요!',
    '목표별 할일에서 목표별로 할일을 관리해보세요',
    '워라벨 지킴이 목표의 할 일으로는 나만의 릴렉스 루틴을 한가지라도 적어주세요. 듀디것부터 공개할게요!',
    '밥먹고 산책하기',
    '10시 이후에 일 안하기',
  ].obs;
  RxList<TodoListGroup> todoListGroup = [
    TodoListGroup(
    documentId: '1',
    title: '당신의 첫 목표는?',
    color: 0xff32A8EB,
    todoList: [
      TodoList(
        documentId: '1',
        GroupId: '1',
        title: '모아 미팅하기',
        createDate: DateTime.now(),
        isAlarm: false,
        alarmDate: DateTime.now(),
        completeCount: 0.obs,
        index: 0,
      ),
    ],
    createDate: DateTime.now(),
      index: 0,
  ),
    TodoListGroup(
      documentId: '2',
      title: '릴렉스 루틴',
      color: 0xff68B64D,
      todoList: [
        TodoList(
          documentId: '3',
          GroupId: '2',
          title: '밥먹고 산책하기',
          createDate: DateTime.utc(2021, 10, 10),
          isAlarm: false,
          alarmDate: DateTime.now(),
          completeCount: 0.obs,
          index: 0,
        ),
        TodoList(
          documentId: '4',
          GroupId: '2',
          title: '10시 이후에 일 안하기',
          createDate: DateTime.utc(2021, 10, 11),
          isAlarm: false,
          alarmDate: DateTime.now(),
          completeCount: 0.obs,
          index: 1,
        )
      ],
      createDate: DateTime.now(),
      index: 1,
    ),
    TodoListGroup(
      documentId: '3',
      title: '목표 없는 리스트',
      color: 0xff684DB6,
      todoList: [
        TodoList(
          documentId: '3',
          GroupId: '3',
          title: '드라마 보기 📺',
          createDate: DateTime.now(),
          isAlarm: false,
          alarmDate: DateTime.now(),
          completeCount: 0.obs,
          index: 0,
        ),
      ],
      createDate: DateTime.now(),
      index: 2,
    )
  ].obs;



  RxInt tabIndex = 1.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.week.obs;
  bool isDrag = false;

  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  @override
  onInit(){
    super.onInit();
    for (int i = 0; i < todoListGroup.length; i++) {
      slidableGroupControllers.add(SlidableController(this));
      isGroupDragHandleVisibleList.add(true);

      // 슬라이드 상태 변화에 따른 드래그 핸들 표시 여부 업데이트
      int currentIndex = i; // 클로저에서 i를 캡처하기 위해
      // slidableGroupControllers[currentIndex].animation.addListener(() {
      //   print(slidableGroupControllers[currentIndex].closing);
      //   print(slidableGroupControllers[currentIndex].animation.value);
      //   if (slidableGroupControllers[currentIndex].animation.value == 0.0) {
      //     isGroupDragHandleVisibleList[currentIndex] = true;
      //   }
      //   else if(slidableGroupControllers[currentIndex].animation.value == 0.3 ){
      //     isGroupDragHandleVisibleList[currentIndex] = false;
      //   }
      //   else if(slidableGroupControllers[currentIndex].animation.value == 0.15){
      //     if(todoListGroup[currentIndex].title == '목표 없는 리스트' || todoListGroup[currentIndex].title == '릴렉스 루틴'){
      //       isGroupDragHandleVisibleList[currentIndex] = false;
      //
      //     }
      //   }
      // });
      // slidableGroupControllers[i].actionPaneType.addListener(() async {
      //     Future.delayed(Duration(milliseconds: 100), () {
      //       // print(slidableGroupControllers[currentIndex].);
      //       if (slidableGroupControllers[currentIndex].actionPaneType.value ==
      //           ActionPaneType.none) {
      //         isGroupDragHandleVisibleList[currentIndex] = true;
      //       }
      //       else {
      //         isGroupDragHandleVisibleList[currentIndex] = false;
      //       }
      //     });
      // });
    }
  }
  test(currentIndex){
    if (slidableGroupControllers[currentIndex].animation.value == 0.0) {
          isGroupDragHandleVisibleList[currentIndex] = true;
        }
        else if(slidableGroupControllers[currentIndex].animation.value == 0.3 ){
          isGroupDragHandleVisibleList[currentIndex] = false;
        }
        else if(slidableGroupControllers[currentIndex].animation.value == 0.15) {
      if (todoListGroup[currentIndex].title == '목표 없는 리스트' ||
          todoListGroup[currentIndex].title == '릴렉스 루틴') {
        isGroupDragHandleVisibleList[currentIndex] = false;
      }
    }
  }
  void startAutoScroll(double direction) {
    if (_isAutoScrolling) return;

    _isAutoScrolling = true;
    _autoScrollTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      scrollController.animateTo(
        scrollController.position.pixels + direction,
        duration: Duration(milliseconds: 50),
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
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        )
            .then((_) => isScrolling = false);
      }
      else{
        scrollController
            .animateTo(
          offset2.dy - scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
      }
    }
    else{
      scrollController
          .animateTo(
        scrollController.position.minScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void changeCalendarFormat(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void reorderTask(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = testText.removeAt(oldIndex);
    testText.insert(newIndex, item);
  }

  diaryDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RxInt selectIndex = (-1).obs;
    List<int> selectList = [0, 1, 2, 3, 4, 5, 6];
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            titlePadding: EdgeInsets.zero,
            backgroundColor: Color(0xffEAF6FF),
            title: Container(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: (){
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: Color(0xff133C6B),
                    )
                )
            ),
            content: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width * 0.9,
                height: 480,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Text('오늘 하루는 어땠어?', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w600),),
                    SizedBox(height: 20,),
                    Container(
                      width: size.width,
                      height: 97,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('오늘 하루의 점수를 매겨봐 !', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: size.width,
                      height: 270,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),
                          Text('오늘의 일기 쓰기', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    hintText: '제목은 한줄 일기가 돼 !',
                                    hintStyle: TextStyle(fontSize: 12, color: Color(0xffD9D9D9), fontWeight: FontWeight.w500),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 150,
                            width: size.width,
                            child: TextField(
                              controller: contentController,
                              maxLines: 20,
                              style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
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
                        onPressed: (){
                        Get.back();
                        },
                        child: Text('저장', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),)
                    )
                  ],
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
        Get.snackbar('알림', '이전달에는 예약을 할 수 없습니다.');
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
        Get.snackbar('알림', '예약은 1년 이내로만 가능합니다.');
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
}