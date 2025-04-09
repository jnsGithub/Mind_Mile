import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/firebase_options.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/util/test.dart';
import 'package:mind_mile/view/chat/chatView.dart';
import 'package:mind_mile/view/diaryView/diaryView.dart';
import 'package:mind_mile/view/diaryView/dirayDetail/diaryDetailView.dart';
import 'package:mind_mile/view/sign/loginView.dart';
import 'package:mind_mile/view/sign/signUp/signUpView.dart';
import 'package:mind_mile/view/survey/surveyEndView.dart';
import 'package:mind_mile/view/survey/surveyStartView.dart';
import 'package:mind_mile/view/survey/surveyView.dart';
import 'package:mind_mile/view/todoList/todoListMainView.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

bool isLogin = false;
bool isSurvey = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();


  DateTime a = DateTime.now();
  a.subtract(Duration(days: a.weekday));
  PermissionStatus status = await Permission.notification.request();
  if(status.isGranted){
    print('권한 허용');
  }else{
    print('권한 거부');
  }


  if(auth.FirebaseAuth.instance.currentUser != null) {
    await getMyInfo();
    if(Platform.isAndroid) {
      setFirebaseMessaging();
    }
    if(groupValue == 2){ // TODO : 그룹값이 1이면
      print('그룹값 2');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      PredectedWellness predectedWellness = PredectedWellness();
      int? lastRequestDate = prefs.getInt('lastRequestDate');
      print(lastRequestDate);
      if(lastRequestDate == null || lastRequestDate < int.parse(DateFormat('yyyyMMdd').format(DateTime.now()))){
        // 예측값 받아와야함
        log(name: 'INFO', '데이터 없거나 오늘 날짜보다 작음 - 예측 데이터를 받아옵니다.');
        wellness = await predectedWellness.requestWellness(uid!) ?? 3;
      }
      else{
        log(name: 'INFO', '예측값이 있음 - 기존 데이터를 받아옵니다.');
        wellness = prefs.getInt('wellness') ?? 3;
        textList = prefs.getStringList('wordList') ?? [];
        print('예측값 wellness ${wellness}');
        print('예측값 textList ${textList}');
      }
    } else{
      print('그룹값 1 아님');
    }
    isLogin = true;
  }
  else{
    isLogin = false;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: false,
          fontFamily: 'Pretendard',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor:  Colors.white,
              titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400
              ), elevation:0
          )
      ),
      initialRoute: isLogin ? !isSurvey ? '/surveyView' : '/todoListView' : '/loginView',
      getPages: [
        GetPage(name: '/loginView', page: () => const LoginView(),),
        GetPage(name: '/signUpView', page: () => const SignUpView(),),
        GetPage(name: '/todoListView', page: () => TodoListMainView(),),
        GetPage(name: '/diaryView', page: () => const DiaryView()),
        GetPage(name: '/diaryDetailView', page: () => const DiaryDetailView()),
        GetPage(name: '/surveyView', page: () => const SurveyView()),
        GetPage(name: '/surveyStartView', page: () => const SurveyStartView()),
        GetPage(name: '/surveyEndView', page: () => const SurveyEndView()),
        GetPage(name: '/chatView', page: () => ChatView()),
      ],
    );
  }
}
