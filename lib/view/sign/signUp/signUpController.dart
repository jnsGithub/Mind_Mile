import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mind_mile/util/sign.dart';

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
}