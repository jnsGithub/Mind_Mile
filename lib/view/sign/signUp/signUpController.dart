import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mind_mile/model/todoList.dart';
import 'package:mind_mile/util/sign.dart';
import 'package:mind_mile/util/todoList.dart';

class SignUpController extends GetxController{
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController diaryNameController = TextEditingController();

  RxInt selectSexValue = (-1).obs;
  RxInt selectGroupValue = (-1).obs;

  Sign sign = Sign();
  TodoListInfo todoListInfo = TodoListInfo();

  RxList<TodoLists> todoList = <TodoLists>[
    TodoLists(date: DateTime.now(),lasteditAt: DateTime.now(),documentId: '1', GroupId: '1', content: '오른쪽 하단 +를 눌러 할일을 등록하세요', completeTime: DateTime.now(), alarmTrue: false, alarmAt: DateTime.now(), complete: 0.obs, createAt: DateTime.now(), sequence: 0),
    TodoLists(date: DateTime.now(),lasteditAt: DateTime.now(),documentId: '2', GroupId: '1', content: '목록의 순서를 오른쪽 = 를 잡고 드래그해서 바꿔보세요', completeTime: DateTime.now(),alarmTrue: false, alarmAt: DateTime.now(), complete: 0.obs, createAt: DateTime.now(), sequence: 1),
    TodoLists(date: DateTime.now(),lasteditAt: DateTime.now(),documentId: '3', GroupId: '1', content: '목록을 왼쪽으로 슬라이드해서 알람 설정과 삭제 기능을 구현해보세요!', completeTime: DateTime.now(),alarmTrue: false, alarmAt: DateTime.now(), complete: 0.obs, createAt: DateTime.now(), sequence: 2),
    TodoLists(date: DateTime.now(),lasteditAt: DateTime.now(),documentId: '4', GroupId: '1', content: '목표별 할일에서 목표별로 할일을 관리해보세요', completeTime: DateTime.now(),alarmTrue: false, alarmAt: DateTime.now(), complete: 0.obs, createAt: DateTime.now(), sequence: 3),
    TodoLists(date: DateTime.now(),lasteditAt: DateTime.now(),documentId: '5', GroupId: '1', content: '워라벨 지킴이 목표의 할 일으로는 나만의 릴렉스 루틴을 한가지라도 적어주세요. 듀디것부터 공개할게요!', completeTime: DateTime.now(),alarmTrue: false, alarmAt: DateTime.now(), complete: 0.obs, createAt: DateTime.now(), sequence: 4),
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return regex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$');
    return regex.hasMatch(password);
  }
}