import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/todoList/todoListGroupView.dart';
import 'package:mind_mile/view/todoList/todoListView.dart';
import 'package:table_calendar/table_calendar.dart';
import 'todoListController.dart';

class TodoListMainView extends GetView<TodoListController> {
  const TodoListMainView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TodoListController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 35,
            height: 35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appbarlogo.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Stack(
          children: [
            SingleChildScrollView(  // 스크롤 가능하게 추가
              controller: controller.scrollController,
              child: Obx(() => Column(
                  children: [
                    Column(
                      children: [
                        // 위젯을 모두 여기에 추가
                        Container(
                          width: size.width,
                          height: 70,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xff707070), width: 1),
                                  borderRadius: BorderRadius.circular(60),
                                ),
                                child: Container(
                                  width: size.width * 0.1462,
                                  height: size.width * 0.1462,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(60),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/images/profileex.png'),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '선희의 기록',
                                    style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.w700),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      controller.diaryDialog(context);
                                    },
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      strokeWidth: 0.5,
                                      radius: const Radius.circular(60),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(60),
                                          color: mainColor,
                                        ),
                                        height: 25,
                                        child: Text(
                                          '당신의 오늘 하루는 어땠나요?',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Obx(() => Column(
                            children: [
                              TableCalendar(
                                locale: 'ko_KR',
                                focusedDay: DateTime.now(),
                                firstDay: DateTime.utc(2000, 1, 1),
                                lastDay: DateTime.utc(2100, 12, 31),
                                calendarFormat: controller.calendarFormat.value,
                                onFormatChanged: (format) {
                                  controller.changeCalendarFormat(format);
                                },
                                availableCalendarFormats: const {
                                  CalendarFormat.month: '월간',
                                  CalendarFormat.week: '주간',
                                },
                                headerStyle: HeaderStyle(
                                  titleTextStyle: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w700),
                                  titleCentered: false,
                                  formatButtonVisible: false,
                                  leftChevronVisible: false,
                                  rightChevronVisible: false,
                                ),
                                calendarBuilders: CalendarBuilders(
                                  selectedBuilder: (context, date, events) => Container(
                                    margin: const EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                      style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  todayBuilder: (context, date, events) => Container(
                                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: subColor,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(
                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                      style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  defaultBuilder: (context, date, events) => Container(
                                    margin: const EdgeInsets.all(15.0),
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Text(
                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                      style: TextStyle(fontSize: 11, color: subColor, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.0718,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: const Color(0xff999999),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                width: size.width,
                                height: 1,
                                decoration: BoxDecoration(
                                  color: const Color(0xff999999),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Obx(() => Container(
                          width: size.width,
                          height: 25,
                          child: CupertinoTabBar(
                            controller.cupertinoTabBarIValue == 0 ? const Color(0xFFF1F1F1) : const Color(0xFFF1F1F1),
                            controller.cupertinoTabBarIValue == 0 ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF),
                            [
                              const Text(
                                "오늘 할 일",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "목표별 할 일",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            controller.cupertinoTabBarIValueGetter,
                                (int index) {
                              controller.cupertinoTabBarIValue.value = index;
                            },
                            allowExpand: true,
                            borderRadius: BorderRadius.circular(5),
                            useShadow: false,
                          ),
                        ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: subColor,
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/edit.png'),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Obx(() => Text(controller.cupertinoTabBarIValue.value == 0 ? '할일 편집' : '목표 편집', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),))
                            ],
                          ),
                        ),
                        controller.cupertinoTabBarIValue.value == 0 ? TodoListView() : TodoListGroupView(),
                        controller.isAdd.value ? Container(
                          width: size.width,
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/void.png'),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.7,
                                child: TextField(
                                  controller: controller.addController,
                                  decoration: InputDecoration(
                                    hintText: '할 일을 입력해주세요',
                                    hintStyle: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (value) {
                                    if(value == '') {
                                      return;
                                    }
                                    controller.addController.clear();
                                    controller.isAdd.value = false;
                                    controller.testText.add(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ) : Container(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // controller.addTodoListDialog(context);
                  controller.isAdd.value = !controller.isAdd.value;
                  print(controller.isAdd.value);
                  if(controller.isAdd.value) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      controller.scrollController.animateTo(
                        controller.scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subColor,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                        offset: const Offset(0, 4), // 그림자 방향 (x, y) 설정
                        blurRadius: 0.5, // 그림자의 흐릿함 정도
                        spreadRadius: 0, // 그림자 확산 정도
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => bottomNavi(controller.selectTap, controller.pageController)),
    );
  }
}
