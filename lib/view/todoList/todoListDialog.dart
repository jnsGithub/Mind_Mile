import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable_panel/flutter_slidable_panel.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/util/todoList.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

// 왜인지 모르겠지만 사용 안하는중
deleteTodoListDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: const Color(0xffEAF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.only(top: 20),
          content: Container(
            alignment: Alignment.center,
            width: size.width * 0.7795,
            height: 94,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('할일을 삭제 하시겠습니까?', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color(0xffD9D9D9)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(const Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('아니오', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(subColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(const Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('네', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ],
                )
              ],
            ),
          )
      );
    },
  );
}

updateAlarmDialog(BuildContext context, String docId, TodoLists todoList){
  showDialog(context: context, builder: (BuildContext context) {
    RxBool isSwitch = todoList.alarmTrue.obs;

    TextEditingController hourController = TextEditingController(text: isSwitch.value ? (todoList.alarmAt!.hour).toString() : '-');
    TextEditingController minController = TextEditingController(text: isSwitch.value ? (todoList.alarmAt!.minute).toString() : '-');
    RxBool isAfterNoon = todoList.alarmTrue ? todoList.alarmAt!.hour > 12 ? true.obs : false.obs : false.obs;
    return AlertDialog(
      backgroundColor: const Color(0xffEAF6FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Container(alignment: Alignment.topRight,child: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close, color: subColor, size: 20))),
      content: SizedBox(
        width: 336,
        height: 220,
        child: Column(
          children: [
            const Text('시간 설정'),
            const SizedBox(height: 20),
            Container(
              width: 299,
              height: 79,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => GestureDetector(
                      onTap: (){
                        isAfterNoon.value = !isAfterNoon.value;
                      },
                      child: Text(isAfterNoon.value ? '오후' : '오전',
                        style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.w700),
                      )
                  )),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 50,
                    child: Obx(() => TextField(
                        readOnly: !isSwitch.value,
                        onChanged: (value) {
                          try{
                            if(!value.isNumericOnly){
                              value = '0';
                              hourController.text = value;
                            }
                            if (value.length > 2) {
                              // 최대 글자 수를 넘으면 마지막 입력을 제거
                              value = value.substring(1, 2);
                              hourController.text = value;
                            }
                            if(int.parse(value) > 12){
                              value = '12';
                              hourController.text = value;
                            }
                          } catch(e){
                            print(e);
                          }
                        },
                        style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                        controller: hourController,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintText: '00',
                          hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                        ),
                        // onSubmitted: (value) async{
                        //   try{
                        //     if(hourController.text == ''){
                        //       hourController.text = '0';
                        //     }
                        //     if(minController.text == ''){
                        //       minController.text = '0';
                        //     }
                        //     var controller = Get.find<TodoListController>();
                        //     await controller.todoListInfo.updateTodoListAlarm(docId, isSwitch.value, int.parse(hourController.text), int.parse(minController.text));
                        //     await controller.init();
                        //     Get.back();
                        //   } catch(e){
                        //     print(e);
                        //   }
                        // },
                      ),
                    ),
                  ),
                  Text(':', style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),),
                  SizedBox(
                    width: 50,
                    child: Obx(() => TextField(
                        readOnly: !isSwitch.value,
                        onChanged: (value) {
                          if(!value.isNumericOnly){
                            value = '0';
                            minController.text = value;
                          }
                          try{
                            if (value.length > 2) {
                              // 최대 글자 수를 넘으면 마지막 입력을 제거
                              value = value.substring(1, 2);
                              minController.text = value;
                            }
                            if(int.parse(value) > 59){
                              value = '59';
                              minController.text = value;
                            }
                          } catch(e){
                            print(e);
                          }
                        },
                        style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                        controller: minController,
                        // keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(left: 10),
                          hintText: '00',
                          hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                        ),
                        // onSubmitted: (value) async {
                        //   try{
                        //     if(hourController.text == ''){
                        //       hourController.text = '0';
                        //     }
                        //     if(minController.text == ''){
                        //       minController.text = '0';
                        //     }
                        //     var controller = Get.find<TodoListController>();
                        //     await controller.todoListInfo.updateTodoListAlarm(docId, isSwitch.value, int.parse(hourController.text), int.parse(minController.text));
                        //     await controller.init();
                        //     Get.back();
                        //   } catch(e){
                        //     print(e);
                        //   }
                        // },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: (){
                      isSwitch.value = !isSwitch.value;
                      if(!isSwitch.value){
                        hourController.text = '-';
                        minController.text = '-';
                      }else{
                        hourController.text = '00';
                        minController.text = '00';
                      }
                      print(isSwitch.value);
                    },
                    child: Text('PUSH 알람 설정',style: TextStyle(fontSize:10,  color: subColor, fontWeight: FontWeight.w600))),
                const SizedBox(width: 10),
                Obx(() => SizedBox(
                  height: 20,
                  width: 20,
                  child: Transform.scale(
                    scale: 0.5,
                    child: CupertinoSwitch(
                      value: isSwitch.value,
                      onChanged: (value) {
                        isSwitch.value = value;
                        if(!isSwitch.value){
                          hourController.text = '-';
                          minController.text = '-';
                        }else{
                          hourController.text = '00';
                          minController.text = '00';
                        }
                        print(isSwitch.value);
                      },
                      activeColor: subColor,
                    ),
                  ),
                ),
                ),
              ],
            ),
            const SizedBox(height: 5,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: subColor,
                  maximumSize: const Size(67, 27),
                  minimumSize: const Size(67, 27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  try{
                    int? hour = 0;
                    int? min = 0;

                    if(!isSwitch.value){
                      hourController.text = '00';
                      minController.text = '00';
                    }

                    if(hourController.text != '' && minController.text != ''){
                      hour = int.parse(hourController.text);
                      min = int.parse(minController.text);
                    }
                    else{
                      if(hourController.text == ''){
                        hour = 0;
                      }
                      if(minController.text == ''){
                        min = 0;
                      }
                    }
                    if(isAfterNoon.value){
                      if(hour == 12){
                        hour = 12;
                      }
                      else{
                        hour = hour + 12;
                      }
                    }
                    else{
                      if(hour == 12){
                        hour = 0;
                      }
                    }
                    print(isAfterNoon.value);
                    print(hour);
                    var controller = Get.find<TodoListController>();
                    await controller.todoListInfo.updateTodoListAlarm(docId, isSwitch.value, hour, min);
                    await controller.init();
                    Get.back();
                  } catch(e){
                    print(e);
                  }
                },
                child: const Text('저장', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),)
            )
          ],
        ),
      ),
    );
  }
  );
}

deleteTodoListGroupDialog(BuildContext context, TodoListGroup group, int index) {
  Size size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: const Color(0xffEAF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.only(top: 20),
          content: Container(
            alignment: Alignment.center,
            width: size.width * 0.7795,
            height: 94,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('그룹을 삭제 하시겠습니까?', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(const Color(0xffD9D9D9)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(const Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('아니오', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(subColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(const Size(70, 15)),
                      ),
                      onPressed: () async {
                        saving(context);
                        await TodoListInfo().deleteTodoListGroup(group.documentId);
                        await Get.find<TodoListController>().init();
                        Get.find<TodoListController>().slidableGroupControllers.removeAt(index);
                        Get.find<TodoListController>().isGroupDragHandleVisibleList.removeAt(index);

                        print(Get.find<TodoListController>().slidableGroupControllers.length);
                        Get.back();
                        Get.back();
                      },
                      child: const Text('네', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ],
                )
              ],
            ),
          )
      );
    },
  );
}

addTodoListGroup(BuildContext context, bool isEdit, {String? title, TodoListGroup? group}){
  Size size = MediaQuery.of(context).size;
  int color = 0;
  RxInt selectedColor = 15.obs;
  List<Color> colorList = [
    const Color(0xffEC1712),const Color(0xffFF661F),const Color(0xffFFC12C),const Color(0xff047E43),
    const Color(0xff68B64D),const Color(0xff133C6B),const Color(0xff32A8EB),const Color(0xff684DB6),
    const Color(0xffFEBBC5),const Color(0xffFCE2A8),const Color(0xffBACD9D),const Color(0xff5F8697),
    const Color(0xffA59E90),const Color(0xffCBCBE7),const Color(0xff999999),Colors.transparent];
  TextEditingController titleController = TextEditingController();
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: const Color(0xffEAF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                Get.back();
              },
              icon: Icon(Icons.close, color: subColor, size: 20),
            ),
          ),
          content: SizedBox(
            width: size.width,
            height: 270,
            child: Column(
              children: [
                Text('목표 추가/수정', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                const SizedBox(height: 10),
                Container(
                  width: size.width,
                  height: 53,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('목표 이름', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: size.width / 2,
                        height: 30,
                        child: TextField(
                          controller: titleController,
                          textAlign: TextAlign.center,
                          readOnly: isEdit,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // contentPadding: const EdgeInsets.only(left: 10),
                            hintText: isEdit ? title! : '당신의 첫 목표는?',
                            hintStyle: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600, ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  height: 103,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 10),
                      Text('그룹 색상', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: size.width,
                          height: 70,
                          child: GridView.builder(
                              itemCount: colorList.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index){
                                return Obx(() => GestureDetector(
                                    onTap: (){
                                      print(colorList[index]);
                                      color = colorList[index].value;
                                      selectedColor.value = index;
                                    },
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: selectedColor.value == index ? mainColor : Colors.transparent, width: 2),
                                        color: colorList[index],
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                    ),
                                  ),
                                );
                              }
                          )
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(subColor),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      minimumSize: WidgetStateProperty.all(const Size(52, 21)),
                    ),
                    onPressed: () async {
                      saving(context);
                      var controller = Get.find<TodoListController>();
                      if(!isEdit){
                        await controller.todoListInfo.setTodoListGroup(titleController.text, color, controller.todoListGroup.length);
                        controller.slidableGroupControllers.add(SlideController(usePostActionController: true, usePreActionController: true));
                        controller.isGroupDragHandleVisibleList.add(true);
                        await controller.getTodoListGroup();
                      }
                      else{
                        await controller.todoListInfo.updateTodoListGroup(group!.documentId, color);
                      }
                      await controller.init();
                      for(var i in controller.slidableGroupControllers){
                        i.dismiss();
                      }
                      Get.back();
                      Get.back();
                    },
                    child: const Text('확인')
                )
              ],
            ),
          ),
        );
      });
}

deleteItemDialog(BuildContext context, RxList<TodoLists> todoList, int index, String docId,{bool? isDetail, String? groupId}){
  Size size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: const Color(0xffEAF6FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            content: Container(
              padding: const EdgeInsets.only(top: 20),
              width: size.width,
              height: 94,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('할일을 삭제 하시겠습니까?', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(const Color(0xffD9D9D9)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            minimumSize: WidgetStateProperty.all(const Size(52, 21)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('아니오', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),),
                        ),
                        const SizedBox(width: 30),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(subColor),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            minimumSize: WidgetStateProperty.all(const Size(52, 21)),
                          ),
                          onPressed: () async {
                            saving(context);
                            if(isDetail ?? false){
                              await TodoListInfo().deleteTodoLists(docId, todoList, groupId!);
                              Get.find<TodoListController>().init();
                              Get.find<TodoListController>().slidableGroupDetailControllers.removeAt(index);
                              Get.find<TodoListController>().todoListGroupDetail.value.todoList.removeAt(index);
                              Get.back();
                              Get.back();

                              return;
                            }
                            TodoLists todoLists = todoList[index];
                            todoList.removeAt(index);
                            await TodoListInfo().deleteTodoLists(todoLists.documentId, todoList, todoLists.GroupId);
                            Get.find<TodoListController>().init();
                            Get.back();
                            Get.back();
                          },
                          child: const Text('네', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),),
                        ),
                      ],
                    ),
                  ]
              ),
            )
        );
      }
  )  ;
}

addGroupDetailItemDialog(BuildContext context, RxBool isCalendar1, RxBool isAlarm1, String groupId){
  Size size = MediaQuery.of(context).size;
  RxBool isCalendar = false.obs;
  RxBool isAlarm = false.obs;
  TextEditingController contentController = TextEditingController();
  TextEditingController hourController = TextEditingController(text: '-');
  TextEditingController minController = TextEditingController(text: '-');
  RxBool isSwitch = false.obs;
  Rx<DateTime> selectedDate = DateTime(2021,01,01).obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxBool isAfterNoon = false.obs;
  showDialog(
      context: context,
      builder: (context){
        return Obx(() => AlertDialog(
          alignment: Alignment.bottomCenter,
            contentPadding: EdgeInsets.zero,
            titlePadding: isCalendar.value ? const EdgeInsets.symmetric(horizontal: 20) : EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: isCalendar.value ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: 260,
              height: 260,
              margin: const EdgeInsets.only(bottom: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Obx(() => TableCalendar(
                        locale: 'ko_KR',
                        rowHeight: 30.0,
                        // selectedDayPredicate: (day) {
                        //   return isSameDay(selectedDate.value, day);
                        // },
                        onDaySelected: (selectedDay, focusedDay1) {
                          selectedDate.value = selectedDay;
                          focusedDay.value = focusedDay1;
                          print(selectedDate.value);
                        },
                        selectedDayPredicate: (day) {
                          return isSameDay(selectedDate.value, day);
                        },
                        firstDay: DateTime.utc(2021, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: focusedDay.value,
                        calendarFormat: CalendarFormat.month,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false, // 포맷 버튼 숨기기
                            leftChevronVisible: false, // 왼쪽 화살표 숨기기
                            rightChevronVisible: false, // 오른쪽 화살표 숨기기
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMMM(locale).format(date),
                          ),
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(fontSize: 13, color: Color(0xffDADADA)),
                          weekendStyle: TextStyle(fontSize: 13, color: Color(0xffDADADA)),
                        ),
                        calendarStyle: CalendarStyle(
                          cellMargin: const EdgeInsets.all(3),
                          outsideDaysVisible: false,
                          defaultTextStyle: const TextStyle(fontSize: 13,),
                          weekendTextStyle: const TextStyle(fontSize: 13,),
                          holidayTextStyle: const TextStyle(fontSize: 13,),
                          todayDecoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: subColor,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(fontSize: 13, color: Colors.black),
                          selectedTextStyle: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        calendarBuilders: CalendarBuilders(
                            headerTitleBuilder: (context, date) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${DateFormat.y('ko_KR').format(date) + ' ' +  DateFormat.M('ko_KR').format(date)}'
                                    , // 제목 표시
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.chevron_left, size: 20,),
                                        onPressed: () {
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
                                          // previousMonth();
                                          // controller.update();
                                        }, // 이전 달로 이동
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right, size: 20,),
                                        onPressed: () {
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
                                          // controller.nextMonth();
                                        }, // 다음 달로 이동
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          defaultBuilder: (context, day, focusedDay) {
                            if (day.isBefore(DateTime.now())) {
                              // 지난 날짜 스타일
                              return Center(
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(fontSize: 13, color: Color(0xffDADADA)), // 원하는 색상으로 변경
                                ),
                              );
                            } else {
                              // 기본 날짜 스타일
                              return Center(
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(fontSize: 13,), // 기본 색상 설정
                                ),
                              );
                            }
                          },
                        ),
                      ),
                )
              ),
            )
                : isAlarm.value ? Container(
              width: 336,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              margin: const EdgeInsets.only(bottom: 17),
              decoration: BoxDecoration(
                color: const Color(0xffEAF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('시간 설정', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                  const SizedBox(height: 20),
                  Container(
                    width: 299,
                    height: 79,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => GestureDetector(
                            onTap: (){
                              isAfterNoon.value = !isAfterNoon.value;
                            },
                            child: Text(isAfterNoon.value ? '오후' : '오전',
                            style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.w700),
                              )
                        )),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: 50,
                          child: TextField(
                            onChanged: (value) {
                              if(int.parse(value) > 24){
                                value = '12';
                                hourController.text = value;
                              }
                              if (value.length > 2) {
                                // 최대 글자 수를 넘으면 마지막 입력을 제거
                                value = value.substring(1, 2);
                                hourController.text = value;
                              }
                            },
                            controller: hourController,
                            keyboardType: TextInputType.number,
                            readOnly: !isSwitch.value,
                            style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(left: 10),
                              hintText: !isSwitch.value ? '-' : '00',
                              hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Text(':', style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),),
                        SizedBox(
                          width: 50,
                          child: Obx(() =>TextField(
                              onChanged: (value) {
                                if(value.isEmpty){
                                  return;
                                }
                                if(int.parse(value) > 59){
                                  value = '59';
                                  minController.text = value;
                                }
                                if (value.length > 2) {
                                  // 최대 글자 수를 넘으면 마지막 입력을 제거
                                  value = value.substring(1, 2);
                                  minController.text = value;
                                }
                              },
                              controller: minController,
                              keyboardType: TextInputType.number,
                              readOnly: !isSwitch.value,
                              style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(left: 10),
                                hintText: !isSwitch.value ? '-' : '00',
                                hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                              ),
                              onSubmitted: (value) {

                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PUSH 알람 설정',style: TextStyle(fontSize:10,  color: subColor, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      Obx(() => SizedBox(
                        height: 20,
                        width: 20,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                            value: isSwitch.value,
                            onChanged: (value) {
                              isSwitch.value = value;
                              if(!isSwitch.value){
                                hourController.text = '-';
                                minController.text = '-';
                              }else{
                                hourController.text = '00';
                                minController.text = '00';
                              }
                              print(isSwitch.value);
                            },
                            activeColor: subColor,
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            )
                : null,
            content: Container(
              width: size.width,
              height: 150,
              padding: const EdgeInsets.only(left: 19, right: 19, top: 19, bottom: 0),//const EdgeInsets.symmetric(horizontal: 19, vertical: 19),
              decoration: BoxDecoration(
                color: const Color(0xffEAF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    height: 34,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: contentController,
                      style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, bottom: 15, right: 10),
                        border: InputBorder.none,
                        hintText: '할 일을 추가해 주세요',
                        hintStyle: TextStyle(
                            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      maxLines: 50,
                      // onSubmitted: (value) async {
                      //   int? hour = 0;
                      //   int? min = 0;
                      //   if(hourController.text != '' || minController.text != ''){
                      //     hour = int.parse(hourController.text);
                      //     min = int.parse(minController.text);
                      //   }
                      //
                      //   DateTime pushTime = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, hour, min);
                      //   TodoLists temp = TodoLists(
                      //     documentId: DateTime.now().millisecondsSinceEpoch.toString(),
                      //     GroupId: groupId,
                      //     completeTime: DateTime.now(),
                      //     complete: 0.obs,
                      //     createAt: DateTime.now(),
                      //     date: selectedDate.value,
                      //     todayIndex: 0,
                      //     lasteditAt: DateTime.now(),
                      //     content: value,
                      //     alarmTrue: isSwitch.value,
                      //     alarmAt: hourController.text == '-' || minController.text == '-' ? null : DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, int.parse(hourController.text), int.parse(minController.text)),
                      //     sequence: 0,
                      //   );
                      //
                      //   TodoListInfo().addTodoLists(
                      //     isInit: false,
                      //     temp,
                      //   );
                      //   var controller = Get.find<TodoListController>();
                      //   controller.todoListGroupDetail.value.todoList.add(temp);
                      //   controller.todoListGroupDetail.refresh();
                      //   controller.length();
                      //   // controller.detailContents.refresh();
                      //
                      //   Get.back();
                      // },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    height: 34,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                isAlarm.value = false;
                                isCalendar.value = !isCalendar.value;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: !isCalendar.value ? Colors.white : const Color(0xff899DB5),
                                  borderRadius: BorderRadius.circular(5),
                                  // image: DecorationImage(
                                  //   image: AssetImage(!isCalendar.value ? 'assets/images/calendarIcon.png' : 'assets/images/selectCalendarIcon.png'),
                                  //   fit: BoxFit.cover,)
                                ),
                                child: Image(image: AssetImage(!isCalendar.value ? 'assets/images/calendarIcon.png' : 'assets/images/selectCalendarIcon.png'), width: 20, height: 20),
                              ),
                            ),
                            const SizedBox(width: 11),
                            GestureDetector(
                              onTap: (){
                                isCalendar.value = false;
                                isAlarm.value = !isAlarm.value;
                              },
                              child: Container(
                                padding: const EdgeInsets.all(0),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: !isAlarm.value ? Colors.white : const Color(0xff899DB5),
                                  borderRadius: BorderRadius.circular(5),
                                  // image: DecorationImage(
                                  //   image: AssetImage(!isAlarm.value ? 'assets/images/bellIcon.png' : 'assets/images/selectBellIcon.png'),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                                child: Image(image: AssetImage(!isAlarm.value ? 'assets/images/bellIcon.png' : 'assets/images/selectBellIcon.png'), width: 20, height: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 11),
                        AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(left: isCalendar.value || isAlarm.value ? size.width*0.55 - 60 : 0),
                          child: GestureDetector(
                            onTap: () {
                              selectedDate.value = DateTime.now();
                              focusedDay.value = DateTime.now();
                            },
                            child: Text(
                              '오늘',
                              style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        // Text('오늘', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),)
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subColor,
                      maximumSize: const Size(67, 27),
                      minimumSize: const Size(67, 27),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                      onPressed: (){
                        int? hour = 0;
                        int? min = 0;

                        if(hourController.text.isNumericOnly && minController.text.isNumericOnly){
                          hour = int.parse(hourController.text);
                          min = int.parse(minController.text);
                        }
                        else{
                          if(hourController.text == ''){
                            hour = 0;
                          }
                          if(minController.text == ''){
                            min = 0;
                          }
                        }
                        if(isAfterNoon.value){
                          hour = hour + 12;
                        }

                        DateTime pushTime = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, hour!, min!);
                        TodoLists temp = TodoLists(
                          documentId: DateTime.now().millisecondsSinceEpoch.toString(),
                          GroupId: groupId,
                          completeTime: DateTime.now(),
                          complete: 0.obs,
                          createAt: DateTime.now(),
                          date: selectedDate.value,
                          todayIndex: 0,
                          lasteditAt: DateTime.now(),
                          content: contentController.text,
                          alarmTrue: isSwitch.value,
                          alarmAt: hourController.text == '-' && minController.text == '-' ? null : DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day, hour, min),
                          sequence: 0,
                        );

                        TodoListInfo().addTodoLists(
                          isInit: false,
                          temp,
                        );
                        var controller = Get.find<TodoListController>();
                        controller.todoListGroupDetail.value.todoList.add(temp);
                        controller.todoListGroupDetail.refresh();
                        controller.length();
                        // controller.detailContents.refresh();

                        Get.back();
                      }, child: const Text('저장', style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),)
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
}