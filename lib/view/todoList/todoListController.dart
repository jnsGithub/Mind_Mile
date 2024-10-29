import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoListController extends GetxController {
  TextEditingController addController = TextEditingController();

  RxInt cupertinoTabBarIValue = 0.obs;
  int cupertinoTabBarIValueGetter() => cupertinoTabBarIValue.value;
  RxBool isAdd = false.obs;

  RxInt selectTap = 0.obs;
  PageController pageController = PageController();

  ScrollController scrollController = ScrollController();
  Rx<PointerMoveEvent> details = PointerMoveEvent().obs;
  Rx<PointerDownEvent> offset = PointerDownEvent().obs;

  bool isScrolling = false;


  List<String> testText = [
    '오른쪽 하단 +를 눌러 할일을 등록하세요',
    '목록의 순서를 오른쪽 = 를 잡고 드래그해서 바꿔보세요',
    '목록을 왼쪽으로 슬라이드해서 알람 설정과 삭제 기능을 구현해보세요!',
    '목표별 할일에서 목표별로 할일을 관리해보세요',
    '워라벨 지킴이 목표의 할 일으로는 나만의 릴렉스 루틴을 한가지라도 적어주세요. 듀디것부터 공개할게요!',
    '밥먹고 산책하기',
    '10시 이후에 일 안하기',
  ];

  RxInt tabIndex = 0.obs;
  Rx<CalendarFormat> calendarFormat = CalendarFormat.week.obs;
  bool isDrag = false;

  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

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
      // scrollController
      //     .animateTo(
      //   scrollController.position.maxScrollExtent,
      //   duration: Duration(seconds: 2),
      //   curve: Curves.easeInOut,
      // )
      //     .then((_) => isScrolling = false);
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
  changeTab(int index) {
    tabIndex.value = index;
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
            content: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: size.width * 0.9,
              height: 520,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  Text('오늘 하루는 어땠어?', style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.w600),),
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
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        Text('오늘의 일기 쓰기', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500),),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text('제목 : ', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w500)),
                            Container(
                              height: 20,
                              width: size.width * 0.4,
                              child: TextField(
                                controller: titleController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: '제목은 한줄 일기가 돼 !',
                                  hintStyle: TextStyle(fontSize: 12, color: Color(0xffD9D9D9), fontWeight: FontWeight.w500),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                          width: size.width * 0.5,
                          child: TextField(
                            controller: contentController,
                            maxLines: 20,
                            decoration: InputDecoration(
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
}