import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';

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
                        backgroundColor: MaterialStateProperty.all(Color(0xffD9D9D9)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: MaterialStateProperty.all(Size(70, 15)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('아니오', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(subColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        minimumSize: MaterialStateProperty.all(Size(70, 15)),
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
                Obx(() => CupertinoSwitch(
                  value: isSwitch.value,
                  onChanged: (value) {
                    isSwitch.value = value;
                    print(isSwitch.value);
                  },
                  activeColor: subColor,
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
                    backgroundColor: MaterialStateProperty.all(subColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    minimumSize: MaterialStateProperty.all(Size(52, 21)),
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