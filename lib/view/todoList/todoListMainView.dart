import 'dart:ui' as ui;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cupertino_tabbar/cupertino_tabbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mind_mile/component/hornCircle.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/util/diary.dart';
import 'package:mind_mile/view/diaryView/diaryView.dart';
import 'package:mind_mile/view/todoList/todoListDialog.dart';
import 'package:mind_mile/view/todoList/todoListGroupView.dart';
import 'package:mind_mile/view/todoList/todoListView.dart';
import 'package:table_calendar/table_calendar.dart';
import 'todoListController.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListMainView extends GetView<TodoListController> {
  TodoListMainView({super.key});

  final Rx<ui.Image?> image = Rx<ui.Image?>(null); // 이미지를 관리할 Rx

  // 이미지 로드 함수
  Future<void> loadImage(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final List<int> bytes = data.buffer.asUint8List();
    final Uint8List uint8List = Uint8List.fromList(bytes);

    // 이미지 디코딩 후 콜백으로 처리
    ui.decodeImageFromList(uint8List, (ui.Image img) {
      image.value = img;  // 이미지가 로드되면 Rx 상태를 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TodoListController());
    Get.lazyPut(() => GlobalController());

    loadImage(wellness != null
        ? wellness! < 3
        ? 'assets/images/score/selectTT.png'
        : wellness! < 6
        ? 'assets/images/score/selectSoso.png'
        : 'assets/images/score/selectHappy.png'
        : 'assets/images/score/selectTT.png'
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool, dynamic) {
        FocusScope.of(context).unfocus();
        for(int i = 0; i < controller.readOnlyList.length; i++) {
          controller.readOnlyList[i].value = true;
        }
        if(controller.isAdd.value) {
          controller.isAdd.value = false;
        }
        if(controller.isDetail.value) {
          controller.isDetail.value = false;
        }
        if(controller.isGroupEdit.value) {
          for(var i in controller.slidableGroupControllers){
            i.dismiss();
          }
          for(int i = 0; i < controller.isGroupDragHandleVisibleList.length; i++) {
            controller.isGroupDragHandleVisibleList[i] = true;
          }
          controller.isGroupEdit.value = false;
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          controller.isAdd.value = false;
          controller.addController.clear();
          for(int i = 0; i < controller.readOnlyList.length; i++) {
            controller.readOnlyList[i].value = true;
          }
          controller.getTodoList();
          print('a');
        },
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                // elevation: 50,
                centerTitle: false,
                toolbarHeight: 55,

                title: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // print(prefs.getString('wellness'));
                              // print(wellness);
                              await FirebaseAuth.instance.signOut();
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Get.offAllNamed('/loginView');
                            }, child: Text('로그아웃')),
                        // TextButton(
                        //     onPressed: () async
                        //     {
                        //       SharedPreferences prefs = await SharedPreferences.getInstance();
                        //       prefs.clear();
                        //     },
                        //     child: Text('TestButton')
                        // ),
                        Image(image: AssetImage('assets/images/setting.png'), width: 16,),
                      ],
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              body: Obx(() => controller.selectTap.value != 3 ? Padding(
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
                                    margin: const EdgeInsets.only(top: 1),
                                    child: Row(
                                      children: [
                                        Stack(
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
                                            controller.isVisible.value ?
                                            wellness != null ? Positioned(
                                              right: -13,
                                              bottom: -15,
                                                child: Obx(() {
                                                  if (image.value == null) {
                                                    return CircularProgressIndicator();  // 이미지 로드 중에는 로딩 인디케이터
                                                  } else {
                                                    return HornCircleWithImage(imagePath: image.value);
                                                  }
                                                }),)
                                                : const SizedBox() : const SizedBox(),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${myName}의 기록',
                                              style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.w700),
                                            ),
                                            controller.isVisible.value ? GestureDetector(
                                              onTap: () async {
                                                await controller.setIsVisible();
                                                if(controller.isVisible.value == false) {
                                                  Get.snackbar('일기 기록 불가', '일기를 기록 할 수 있는 시간이 아닙니다.');
                                                  return;
                                                }
                                                controller.diaryDialog(context);
                                              },
                                              child: DottedBorder(
                                                padding: const EdgeInsets.all(0),
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
                                                    controller.dailyText.value,
                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                              ),
                                            ) : SizedBox(height: 25),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(() => controller.isDetail.value ? Container() : Column(
                                      children: [
                                        GetBuilder<TodoListController>(
                                          builder: (controller) {
                                            return TableCalendar(
                                                onDaySelected: (selectedDay, focusedDay) {
                                                  controller.selectedDate.value = selectedDay;
                                                  controller.getTodoList();
                                                  controller.update();
                                                },
                                                selectedDayPredicate: (day) {
                                                  return isSameDay(controller.selectedDate.value, day);
                                                },
                                                locale: 'ko_KR',
                                                focusedDay: controller.selectedDate.value,
                                                firstDay: DateTime.utc(2000, 1, 1),
                                                lastDay: DateTime.utc(2100, 12, 31),
                                                calendarFormat: controller.calendarFormat.value,
                                                onFormatChanged: (format) {
                                                  controller.changeCalendarFormat(format);
                                                  controller.update();
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
                                                    margin: const EdgeInsets.all(10.0),
                                                    alignment: Alignment.center,
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: subColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Text(
                                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                                      style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  todayBuilder: (context, date, events) => Container(
                                                    margin: const EdgeInsets.all(10.0),
                                                    alignment: Alignment.center,
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: mainColor,
                                                      borderRadius: BorderRadius.circular(60),
                                                    ),
                                                    child: Text(
                                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                                      style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  defaultBuilder: (context, date, events) => Container(
                                                    margin: const EdgeInsets.all(10.0),
                                                    alignment: Alignment.center,
                                                    width: date.day != 1 ? 30 : 40,
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
                                                  outsideBuilder: (context, date, events) => Container(
                                                    margin: const EdgeInsets.all(10.0),
                                                    alignment: Alignment.center,
                                                    width: date.day != 1 ? 30 : 40,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(60),
                                                    ),
                                                    child: Text(
                                                      date.day != 1 ? date.day.toString() : '${date.month}/${date.day}',
                                                      style: TextStyle(fontSize: 11, color: const Color(0xff999999), fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                  dowBuilder: (context, day) => Container(
                                                    // margin: const EdgeInsets.all(10.0),
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(60),
                                                    ),
                                                    child: Text(
                                                      day.weekday == 1 ? '월' : day.weekday == 2 ? '화' : day.weekday == 3 ? '수' : day.weekday == 4 ? '목' : day.weekday == 5 ? '금' : day.weekday == 6 ? '토' : '일',
                                                      style: TextStyle(fontSize: 11, color: Color(0xff0999999), fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                                ),
                                              );
                                          }
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
                                          decoration: const BoxDecoration(
                                            color: Color(0xff999999),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Obx(() => controller.isDetail.value ? Container() : Container(
                                    width: size.width,
                                    height: 25,
                                    child: CupertinoTabBar(
                                      controller.cupertinoTabBarIValue == 0 ? const Color(0xFFF1F1F1) : const Color(0xFFF1F1F1),
                                      controller.cupertinoTabBarIValue == 0 ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF),
                                      const [
                                        Text(
                                          "할 일 모아 보기",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "목표별 보기",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                      controller.cupertinoTabBarIValueGetter,
                                          (int index) {
                                        controller.isGroupEdit.value = false;
                                        controller.cupertinoTabBarIValue.value = index;
                                        controller.isAdd.value = false;
                                        controller.isGroupEdit.value = false;
                                        if(controller.cupertinoTabBarIValue.value == 1) {
                                          print(index);
                                          print(controller.isGroupEdit.value);
                                            for(var i in controller.slidableGroupControllers){
                                              print(1);
                                              // i.close();
                                              i.dismiss();
                                            }
                                          controller.isGroupEdit.value = false;
                                        }
                                        controller.addController.clear();
                                      },
                                      allowExpand: true,
                                      borderRadius: BorderRadius.circular(5),
                                      useShadow: false,
                                      duration: const Duration(milliseconds: 1000),
                                    ),
                                  ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(() => controller.isDetail.value ? Container() : GestureDetector(
                                      onTap: (){
                                        if(controller.cupertinoTabBarIValue.value == 0 && controller.isDetail.value == false) {
                                          // var controller = Get.find<TodoListController>;
                                          // if(controller.isEdit.value) {
                                          //   controller.slidableController.close();
                                          //   controller.isEdit.value = false;
                                          //
                                          // }
                                          // else {
                                          //   controller.slidableController.openEndActionPane();
                                          //   controller.isEdit.value = true;
                                          // }

                                          print(1);
                                        }
                                        else{
                                          if(controller.isGroupEdit.value == true){
                                            for(var i in controller.slidableGroupControllers){
                                              i.dismiss();
                                            }
                                            for(int i = 0; i < controller.isGroupDragHandleVisibleList.length; i++) {
                                              controller.isGroupDragHandleVisibleList[i] = true;
                                            }
                                          }

                                          controller.isGroupEdit.value = !controller.isGroupEdit.value;

                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            controller.cupertinoTabBarIValue.value == 0 ? SizedBox() : Container(
                                              padding: const EdgeInsets.all(3),
                                              width: 15,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: controller.isGroupEdit.value ? Colors.red : subColor,
                                                // image: const DecorationImage(
                                                //   image: AssetImage('assets/images/edit.png'),
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              child: Image(image: AssetImage('assets/images/edit.png',), ),
                                            ),
                                            SizedBox(width: 5),
                                            controller.cupertinoTabBarIValue.value == 0 ? SizedBox() : Obx(() => Text(
                                                controller.isGroupEdit.value
                                                    ? '완료'
                                                    : '목표 편집',
                                                style: TextStyle(fontSize: 10, color: controller.isGroupEdit.value ? Colors.red : subColor, fontWeight: FontWeight.w600),),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(() => controller.cupertinoTabBarIValue.value == 0 ? TodoListView() : TodoListGroupView(),),
                                  controller.isAdd.value ? Container(
                                    width: size.width,
                                    height: 60,
                                    padding: const EdgeInsets.symmetric(horizontal: 9),
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
                                            focusNode: controller.focusNode,
                                            decoration: InputDecoration(
                                              hintText: '할 일을 입력해주세요',
                                              hintStyle: TextStyle(fontSize: 16, color: Color(0xffbdbdbd), fontWeight: FontWeight.w400),
                                              border: InputBorder.none,
                                            ),
                                            maxLines: 1000,
                                            // onSubmitted: (value) async {
                                            //   if(value == '') {
                                            //     return;
                                            //   }
                                            //   int length = 0;
                                            //   for(int i = 0; i < controller.todoListGroup.length; i++) {
                                            //     if(controller.todoListGroup[i].content == '목표 없는 리스트') {
                                            //       length = controller.todoListGroup[i].todoList.length;
                                            //     }
                                            //   }
                                            //   TodoLists todoLists = TodoLists(
                                            //     lasteditAt: DateTime.now(),
                                            //     completeTime: DateTime.now(),
                                            //     content: value,
                                            //     alarmAt: null,
                                            //     complete: 0.obs,
                                            //     createAt: DateTime.now(),
                                            //     date: controller.selectedDate.value,
                                            //     documentId: '',
                                            //     GroupId: '',
                                            //     sequence: length,
                                            //     todayIndex: controller.todoList.length,
                                            //     alarmTrue: false,
                                            //   );
                                            //   controller.addController.clear();
                                            //   controller.isAdd.value = false;
                                            //   await controller.todoListInfo.addTodoLists(todoLists);
                                            //   controller.todoList.add(todoLists);
                                            //   await controller.init();
                                            // },
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
                    ],
                  ),
                ) : const DiaryView(),
              ),
              bottomNavigationBar: Obx(() => bottomNavi(context, controller.selectTap, controller.pageController),),
              floatingActionButton: Obx(() => controller.selectTap.value != 3 && (controller.cupertinoTabBarIValue.value == 0 || controller.isDetail.value || controller.isGroupEdit.value == true)
                  ? FloatingActionButton(
                backgroundColor: subColor,
                onPressed: () async {
                  print(controller.selectTap.value);
                  // controller.addTodoListDialog(context);
                  print(controller.isAdd.value);

                  if(controller.isAdd.value){
                      if(controller.addController.text == '') {
                        controller.isAdd.value = false;
                        return;
                      }
                      int length = 0;
                      for(int i = 0; i < controller.todoListGroup.length; i++) {
                        if(controller.todoListGroup[i].content == '목표 없는 리스트') {
                          length = controller.todoListGroup[i].todoList.length;
                        }
                      }
                      TodoLists todoLists = TodoLists(
                        lasteditAt: DateTime.now(),
                        completeTime: DateTime.now(),
                        content: controller.addController.text,
                        alarmAt: null,
                        complete: 0.obs,
                        createAt: DateTime.now(),
                        date: controller.selectedDate.value,
                        documentId: '',
                        GroupId: '',
                        sequence: length,
                        todayIndex: controller.todoList.length,
                        alarmTrue: false,
                      );
                      controller.addController.clear();
                      await controller.todoListInfo.addTodoLists(todoLists);
                      // controller.todoList.add(todoLists);
                      await controller.init();
                      controller.isAdd.value = false;
                      return;
                  }
                  else if(controller.readOnlyList.contains(false.obs)){
                    print(controller.todoList[controller.readOnlyList.indexOf(false.obs)].content);
                    controller.todoList[controller.readOnlyList.indexOf(false.obs)].content = controller.todoListController[controller.readOnlyList.indexOf(false.obs)].text;
                    await controller.updateTodo(controller.todoList[controller.readOnlyList.indexOf(false.obs)]);
                    for(int i = 0; i < controller.readOnlyList.length; i++) {
                      controller.readOnlyList[i].value = true;
                    }
                    return;
                  }
                  if(controller.cupertinoTabBarIValue.value == 0) {
                    controller.isAdd.value = !controller.isAdd.value;
                    print(controller.isAdd.value);
                    if(controller.isAdd.value) {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        controller.scrollController.animateTo(
                          controller.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                        // controller.focusNode.requestFocus();
                        FocusScope.of(context).requestFocus(controller.focusNode);
                      });
                    }
                  } else if(controller.isDetail.value) {
                    addGroupDetailItemDialog(context, controller.isCalendar, controller.isAlarm, controller.selectedGroupId);
                  }
                  else {
                    addTodoListGroup(context, false);
                  }
                },
                child: Icon(controller.isAdd.value ? Icons.check : controller.readOnlyList.contains(false.obs) ? Icons.check : Icons.add, color: Colors.white, size: 35,),
              )
                  : const SizedBox()),
            ),
            // Obx(() => controller.selectTap.value != 3 ? Positioned(
            //     bottom: 100,
            //     right: 100,//30,
            //     child: GestureDetector(
            //       onTap: () {
            //         print(controller.selectTap.value);
            //         // controller.addTodoListDialog(context);
            //         if(controller.cupertinoTabBarIValue.value == 0) {
            //           controller.isAdd.value = !controller.isAdd.value;
            //           print(controller.isAdd.value);
            //           if(controller.isAdd.value) {
            //             Future.delayed(Duration(milliseconds: 100), () {
            //               controller.scrollController.animateTo(
            //                 controller.scrollController.position.maxScrollExtent,
            //                 duration: const Duration(milliseconds: 300),
            //                 curve: Curves.easeOut,
            //               );
            //               // controller.focusNode.requestFocus();
            //               FocusScope.of(context).requestFocus(controller.focusNode);
            //             });
            //           }
            //         } else if(controller.isDetail.value) {
            //           addGroupDetailItemDialog(context, controller.isCalendar, controller.isAlarm, controller.selectedGroupId);
            //         }
            //         else {
            //           addTodoListGroup(context, false);
            //         }
            //
            //       },
            //       child: Container(
            //         width: 50,
            //         height: 50,
            //         decoration: BoxDecoration(
            //           color: subColor,
            //           borderRadius: BorderRadius.circular(60),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
            //               offset: const Offset(0, 4), // 그림자 방향 (x, y) 설정
            //               blurRadius: 0.5, // 그림자의 흐릿함 정도
            //               spreadRadius: 0, // 그림자 확산 정도
            //             ),
            //           ],
            //         ),
            //         child: Icon(
            //           Icons.add,
            //           color: Colors.white,
            //           size: 35,
            //         ),
            //       ),
            //     ),
            //   ) : const SizedBox(),),
            GetBuilder<GlobalController>(
                builder: (globalController) {
                  return globalController.isShow.value?
                  GestureDetector(
                    onTap: (){
                      globalController.bb();
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ):Container();
                }
            ),
          ],
        ),
      ),
    );
  }
}
