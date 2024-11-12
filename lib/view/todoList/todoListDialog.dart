import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:table_calendar/table_calendar.dart';

deleteTodoListDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: Color(0xffEAF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.only(top: 20),
          content: Container(
            alignment: Alignment.center,
            width: size.width * 0.7795,
            height: 94,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('할일을 삭제 하시겠습니까?', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Color(0xffD9D9D9)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('아니오', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(subColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: WidgetStateProperty.all(Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('네', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
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

updateAlarmDialog(BuildContext context){
  showDialog(context: context, builder: (BuildContext context) {
    TextEditingController hourController = TextEditingController();
    TextEditingController minController = TextEditingController();
    RxBool isSwitch = true.obs;
    return AlertDialog(
      backgroundColor: Color(0xffEAF6FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      title: Container(alignment: Alignment.topRight,child: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close, color: subColor, size: 20))),
      content: Container(
        width: 336,
        height: 200,
        child: Column(
          children: [
            Text('시간 설정'),
            SizedBox(height: 20),
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
                  Container(
                    width: 50,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length > 2) {
                          // 최대 글자 수를 넘으면 마지막 입력을 제거
                          value = value.substring(1, 2);
                          hourController.text = value;
                        }
                      },
                      controller: hourController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: '00',
                        hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Text(':', style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),),
                  Container(
                    width: 50,
                    child: TextField(
                      onChanged: (value) {
                        if (value.length > 2) {
                          // 최대 글자 수를 넘으면 마지막 입력을 제거
                          value = value.substring(1, 2);
                          hourController.text = value;
                        }
                      },
                      controller: minController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: '00',
                        hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('PUSH 알람 설정',style: TextStyle(fontSize:10,  color: subColor, fontWeight: FontWeight.w600)),
                SizedBox(width: 10),
                Obx(() => Container(
                  height: 20,
                  width: 20,
                  child: Transform.scale(
                    scale: 0.5,
                    child: CupertinoSwitch(
                      value: isSwitch.value,
                      onChanged: (value) {
                        isSwitch.value = value;
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
      ),
    );
  }
  );
}

addTodoListGroup(BuildContext context){
  Size size = MediaQuery.of(context).size;
  List<Color> colorList = [
    Color(0xffEC1712),Color(0xffFF661F),Color(0xffFFC12C),Color(0xff047E43),
    Color(0xff68B64D),Color(0xff133C6B),Color(0xff32A8EB),Color(0xff684DB6),
    Color(0xffFEBBC5),Color(0xffFCE2A8),Color(0xffBACD9D),Color(0xff5F8697),
    Color(0xffA59E90),Color(0xffCBCBE7),Color(0xff999999),Colors.transparent];
  TextEditingController titleController = TextEditingController();
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          backgroundColor: Color(0xffEAF6FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: (){
                Get.back();
              },
              icon: Icon(Icons.close, color: subColor, size: 20),
            ),
          ),
          content: Container(
            width: size.width,
            height: 270,
            child: Column(
              children: [
                Text('목표 추가/수정', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                SizedBox(height: 10),
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
                      Container(
                        width: size.width / 2,
                        height: 30,
                        child: TextField(

                          controller: titleController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            // contentPadding: const EdgeInsets.only(left: 10),
                            hintText: '당신의 첫 목표는?',
                            hintStyle: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600, ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 19),
                  height: 103,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 10),
                      Text('그룹 색상', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
                      Container(
                          width: size.width,
                          height: 70,
                          child: GridView.builder(
                              itemCount: colorList.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index){
                                return GestureDetector(
                                  onTap: (){
                                    print(colorList[index]);
                                  },
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: colorList[index],
                                      borderRadius: BorderRadius.circular(60),
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
                      minimumSize: WidgetStateProperty.all(Size(52, 21)),
                    ),
                    onPressed: (){
                      Get.back();
                    },
                    child: Text('확인')
                )
              ],
            ),
          ),
        );
      });
}

deleteItemDialog(BuildContext context, RxList<TodoList> todoList, int index){
  Size size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Color(0xffEAF6FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            content: Container(
              padding: EdgeInsets.only(top: 20),
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
                            backgroundColor: WidgetStateProperty.all(Color(0xffD9D9D9)),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            minimumSize: WidgetStateProperty.all(Size(52, 21)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('아니오', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),),
                        ),
                        SizedBox(width: 30),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(subColor),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            minimumSize: WidgetStateProperty.all(Size(52, 21)),
                          ),
                          onPressed: () {
                            todoList.removeAt(index);
                            Navigator.pop(context);
                          },
                          child: Text('네', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),),
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

addGroupDetailItemDialog(BuildContext context, RxBool isCalendar1, RxBool isAlarm1){
  Size size = MediaQuery.of(context).size;
  RxBool isCalendar = false.obs;
  RxBool isAlarm = false.obs;
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();
  RxBool isSwitch = true.obs;
  showDialog(
      context: context,
      builder: (context){
        return Obx(() => AlertDialog(
          alignment: Alignment.bottomCenter,
            contentPadding: EdgeInsets.zero,
            titlePadding: isCalendar.value ? EdgeInsets.symmetric(horizontal: 20) : EdgeInsets.zero,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: isCalendar.value ? Container(
              padding: EdgeInsets.all(15),
              width: 260,
              height: 260,
              margin: EdgeInsets.only(bottom: 17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TableCalendar(
                locale: 'ko_KR',
                rowHeight: 30.0,
                firstDay: DateTime.utc(2021, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 13, color: Color(0xffDADADA)),
                  weekendStyle: TextStyle(fontSize: 13, color: Color(0xffDADADA)),
                ),
                calendarStyle: CalendarStyle(
                  cellMargin: EdgeInsets.zero,
                  outsideDaysVisible: false,

                  defaultTextStyle: TextStyle(fontSize: 13,),
                  weekendTextStyle: TextStyle(fontSize: 13,),
                  holidayTextStyle: TextStyle(fontSize: 13,),
                  todayDecoration: BoxDecoration(
                    color: Color(0xff008BE4),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xff008BE4),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  print(selectedDay);
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (day.isBefore(DateTime.now())) {
                      // 지난 날짜 스타일
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(fontSize: 13, color: Color(0xffDADADA)), // 원하는 색상으로 변경
                        ),
                      );
                    } else {
                      // 기본 날짜 스타일
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(fontSize: 13,), // 기본 색상 설정
                        ),
                      );
                    }
                  },
                ),
              ),
            )
                : isAlarm.value ? Container(
              width: 336,
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              margin: EdgeInsets.only(bottom: 17),
              decoration: BoxDecoration(
                color: Color(0xffEAF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text('시간 설정', style: TextStyle(fontSize: 15, color: subColor, fontWeight: FontWeight.w500),),
                  SizedBox(height: 20),
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
                        Container(
                          width: 50,
                          child: TextField(
                            onChanged: (value) {
                              if (value.length > 2) {
                                // 최대 글자 수를 넘으면 마지막 입력을 제거
                                value = value.substring(1, 2);
                                hourController.text = value;
                              }
                            },
                            controller: hourController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: '00',
                              hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Text(':', style: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),),
                        Container(
                          width: 50,
                          child: TextField(
                            onChanged: (value) {
                              if (value.length > 2) {
                                // 최대 글자 수를 넘으면 마지막 입력을 제거
                                value = value.substring(1, 2);
                                hourController.text = value;
                              }
                            },
                            controller: minController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              hintText: '00',
                              hintStyle: TextStyle(fontSize: 30, color: subColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('PUSH 알람 설정',style: TextStyle(fontSize:10,  color: subColor, fontWeight: FontWeight.w600)),
                      SizedBox(width: 10),
                      Obx(() => Container(
                        height: 20,
                        width: 20,
                        child: Transform.scale(
                          scale: 0.5,
                          child: CupertinoSwitch(
                            value: isSwitch.value,
                            onChanged: (value) {
                              isSwitch.value = value;
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
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 19, vertical: 16),
              decoration: BoxDecoration(
                color: Color(0xffEAF6FF),
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
                      style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, bottom: 15, right: 10),
                        border: InputBorder.none,
                        hintText: '할 일을 추가해 주세요',
                        hintStyle: TextStyle(
                            fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 11),
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
                                padding: EdgeInsets.all(4),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: !isCalendar.value ? Colors.white : Color(0xff899DB5),
                                  borderRadius: BorderRadius.circular(5),
                                  // image: DecorationImage(
                                  //   image: AssetImage(!isCalendar.value ? 'assets/images/calendarIcon.png' : 'assets/images/selectCalendarIcon.png'),
                                  //   fit: BoxFit.cover,)
                                ),
                                child: Image(image: AssetImage(!isCalendar.value ? 'assets/images/calendarIcon.png' : 'assets/images/selectCalendarIcon.png'), width: 18, height: 18),
                              ),
                            ),
                            SizedBox(width: 11),
                            GestureDetector(
                              onTap: (){
                                isCalendar.value = false;
                                isAlarm.value = !isAlarm.value;
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: !isAlarm.value ? Colors.white : Color(0xff899DB5),
                                  borderRadius: BorderRadius.circular(5),
                                  // image: DecorationImage(
                                  //   image: AssetImage(!isAlarm.value ? 'assets/images/bellIcon.png' : 'assets/images/selectBellIcon.png'),
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                                child: Image(image: AssetImage(!isAlarm.value ? 'assets/images/bellIcon.png' : 'assets/images/selectBellIcon.png'), width: 18, height: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 11),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.only(left: isCalendar.value || isAlarm.value ? size.width*0.55 - 60 : 0),
                          child: Text(
                            '오늘',
                            style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                        // Text('오늘', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
}