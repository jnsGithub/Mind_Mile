import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/view/sign/signUp/signUpController.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => SignUpController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Container(
                    height: 70,
                    width: size.width*0.1538,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/mindmileLogomini.png'),
                            fit: BoxFit.fitWidth
                        )
                    ),
                  ),
                  Text('회원가입', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  SizedBox(height: 57,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('E-mail', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          textFieldComponent(controller.emailController, size.width*0.6308, 34)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PW', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          textFieldComponent(controller.pwController, size.width*0.6308, 34, isObscure: true.obs)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PW 확인', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          textFieldComponent(controller.pwCheckController, size.width*0.6308, 34, isObscure: true.obs)
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 24,),
                  Text('개인정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  SizedBox(height: 7,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('이름', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          textFieldComponent(controller.nameController, size.width*0.6308, 34)
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('생년월일', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          textFieldComponent(controller.birthdayController, size.width*0.6308, 34, isNumber: true, hint: 'YYYYMMDD')
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('성별', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          Container(
                            width: size.width*0.6308,
                            child: Obx(() => Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      if(controller.selectSexValue.value == 0){
                                        controller.selectSexValue.value = -1;
                                      }
                                      else{
                                        controller.selectSexValue.value = 0;
                                      }
                                    },
                                    child: Container(
                                      width: size.width*0.1872,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          color: controller.selectSexValue.value  == 0 ? mainColor : Colors.white,
                                          border: Border.all(color: const Color(0xffB2D6F1)),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                                              offset: const Offset(0, 3), // 그림자 방향 (x, y) 설정
                                              blurRadius: 6, // 그림자의 흐릿함 정도
                                              spreadRadius: 0.001, // 그림자 확산 정도
                                            ),
                                          ]
                                      ),
                                      child: Center(child: Text('남자', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      if(controller.selectSexValue.value == 1){
                                        controller.selectSexValue.value = -1;
                                      }
                                      else{
                                        controller.selectSexValue.value = 1;
                                      }
                                    },
                                    child: Container(
                                      width: size.width*0.1872,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          color: controller.selectSexValue.value  == 1 ? mainColor : Colors.white,
                                          border: Border.all(color: const Color(0xffB2D6F1)),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                                              offset: const Offset(0, 3), // 그림자 방향 (x, y) 설정
                                              blurRadius: 6, // 그림자의 흐릿함 정도
                                              spreadRadius: 0.001, // 그림자 확산 정도
                                            ),
                                          ]
                                      ),
                                      child: Center(child: Text('여자', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      if(controller.selectSexValue.value == 2){
                                        controller.selectSexValue.value = -1;
                                      }
                                      else{
                                        controller.selectSexValue.value = 2;
                                      }
                                    },
                                    child: Container(
                                      width: size.width*0.1872,
                                      height: 34,
                                      decoration: BoxDecoration(
                                          color: controller.selectSexValue.value  == 2 ? mainColor : Colors.white,
                                          border: Border.all(color: const Color(0xffB2D6F1)),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                                              offset: const Offset(0, 3), // 그림자 방향 (x, y) 설정
                                              blurRadius: 6, // 그림자의 흐릿함 정도
                                              spreadRadius: 0.001, // 그림자 확산 정도
                                            ),
                                          ]
                                      ),
                                      child: Center(child: Text('기타', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 53,),
                  Obx(() =>
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('유저그룹', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),),
                          Container(
                            width: size.width*0.6308,
                            height: 34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    if(controller.selectGroupValue.value == 0){
                                      controller.selectGroupValue.value = -1;
                                    }
                                    else{
                                      controller.selectGroupValue.value = 0;
                                    }
                                  },
                                  child: Container(
                                    width: size.width*0.1872,
                                    height: 34,
                                    decoration: BoxDecoration(
                                        color: controller.selectGroupValue.value  == 0 ? mainColor : Colors.white,
                                        border: Border.all(color: const Color(0xffB2D6F1)),
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                                            offset: const Offset(0, 3), // 그림자 방향 (x, y) 설정
                                            blurRadius: 6, // 그림자의 흐릿함 정도
                                            spreadRadius: 0.001, // 그림자 확산 정도
                                          ),
                                        ]
                                    ),
                                    child: Center(child: Text('Group1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    if(controller.selectGroupValue.value == 1){
                                      controller.selectGroupValue.value = -1;
                                    }
                                    else{
                                      controller.selectGroupValue.value = 1;
                                    }
                                  },
                                  child: Container(
                                    width: size.width*0.1872,
                                    height: 34,
                                    decoration: BoxDecoration(
                                        color: controller.selectGroupValue.value  == 1 ? mainColor : Colors.white,
                                        border: Border.all(color: const Color(0xffB2D6F1)),
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                                            offset: const Offset(0, 3), // 그림자 방향 (x, y) 설정
                                            blurRadius: 6, // 그림자의 흐릿함 정도
                                            spreadRadius: 0.001, // 그림자 확산 정도
                                          ),
                                        ]
                                    ),
                                    child: Center(child: Text('Group2', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  Text('다이어리 이름', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textFieldComponent(controller.diaryNameController, size.width*0.2051, 34),
                      SizedBox(width: 5,),
                      Text('의 다이어리', style: TextStyle(fontSize: 14, color: subColor, fontWeight: FontWeight.w600),)
                    ],
                  ),
                  SizedBox(height: 40,),
                  Container(
                    width: size.width*0.2564,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // 그림자 색상 및 투명도
                          offset: const Offset(2, 5), // 그림자 방향 (x, y) 설정
                          blurRadius: 0, // 그림자의 흐릿함 정도
                          spreadRadius: 0, // 그림자 확산 정도
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          // 버튼 클릭 시 동작
                          // Get.toNamed('/surveyStartView');
                          if(controller.pwController.text !=controller.pwCheckController.text){
                            Get.snackbar('비밀번호 확인', '비밀번호가 일치하지 않습니다.');
                            return;
                          }
                          else if(controller.pwController.text.length < 6){
                            Get.snackbar('비밀번호 확인', '비밀번호는 6자리 이상이어야 합니다.');
                            return;
                          }
                          else
                          if(await controller.sign.signUp(
                              context,
                              controller.emailController.text,
                              controller.pwController.text,
                              controller.nameController.text,
                              controller.birthdayController.text,
                              controller.selectSexValue.value == 0 ? 'M' : controller.selectSexValue.value == 1 ? 'F' : 'N',
                              controller.selectGroupValue.value,
                              controller.diaryNameController.text)){
                            await controller.todoListInfo.setTodoListGroup('릴렉스 루틴', 0xffFFD6D6, 0);
                            await controller.todoListInfo.setTodoListGroup('목표 없는 리스트', 0xffFFD6D6, 1);
                            QuerySnapshot<Map<String, dynamic>> title = await FirebaseFirestore.instance.collection('users').doc(uid).collection('Goals').where('content', isEqualTo: '목표 없는 리스트').get();
                            print(title.docs[0].id);
                            for(int i = 0; i < controller.todoList.length; i++){
                              await controller.todoListInfo.addTodoLists(
                                TodoLists(
                                    documentId: '',
                                    GroupId: title.docs[0].id,
                                    content: controller.todoList[i].content,
                                    alarmTrue: false,
                                    alarmAt: null,
                                    complete: 0.obs,
                                    date: DateTime.now(),
                                    completeTime: DateTime.now(),
                                    createAt: DateTime.now(),
                                    sequence: i,
                                    lasteditAt: DateTime.now(),
                                ),);
                                  //title.docs[0].id, title.docs[0].data()['content'].toString(), controller.todoList[i].content, false, null, i, todayIndex: i);
                            }
                            groupValue = controller.selectGroupValue.value;
                            Get.toNamed('/surveyStartView');
                          }
                          else{
                            print('회원가입 실패');
                          }
                        },
                        child: const Text('가입하기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
