import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/view/sign/loginController.dart';


class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => LoginController());
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 33),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Container(
                width: size.width * 0.3128,
                height: size.width * 0.3128,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/mindmileLogo.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              const SizedBox(height: 98),
              const Text('로그인', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
              const SizedBox(height: 20),
              textFieldComponent(controller.emailController, size.width*0.7974, 34, hint: 'E-mail'),
              const SizedBox(height: 14),
              textFieldComponent(controller.passwordController, size.width*0.7974, 34, hint: 'PW', isObscure: controller.isObscure),
              const SizedBox(height: 20),
              Center(
                child: Container(
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
                        // Get.offAllNamed('/todoListView');
                        if(!Get.isSnackbarOpen){
                          saving(context);
                        }
                        if(await controller.sign.signIn(controller.emailController.text, controller.passwordController.text)){
                          Get.offAllNamed('/todoListView');
                        }
                        else{
                          Get.back();
                          if(!Get.isSnackbarOpen){
                            Get.snackbar('로그인 실패', '아이디와 비밀번호를 확인해주세요');
                          }
                        }
                      },
                      child: const Text('시작하기', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                  ),
                ),
              ),
              const SizedBox(height: 33),
              Container(
                width: size.width*0.5615,
                height: 26,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () async {

                        },
                        child: const Text(
                          '아이디 비밀번호 찾기',
                          style: TextStyle(
                              fontSize: 12,
                              color:Color(0xff646464),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),
                    const Text(
                      '|',
                      style: TextStyle(
                          fontSize: 22,
                          color:Color(0xff646464),
                          fontWeight: FontWeight.w100
                      ),
                    ),
                    GestureDetector(
                        onTap: () async {
                          Get.toNamed('/signUpView');
                        },
                        child: const Text(
                          '회원가입',
                          style: TextStyle(
                              fontSize: 12,
                              color:Color(0xff646464),
                              fontWeight: FontWeight.w400
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
