import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mind_mile/util/sign.dart';
import 'package:mind_mile/util/todoList.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Sign sign = Sign();
  TodoListInfo todoListInfo = TodoListInfo();

  RxBool isObscure = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}