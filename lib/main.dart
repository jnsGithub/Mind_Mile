import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/firebase_options.dart';
import 'package:mind_mile/view/diaryView/diaryView.dart';
import 'package:mind_mile/view/diaryView/dirayDetail/diaryDetailView.dart';
import 'package:mind_mile/view/sign/loginView.dart';
import 'package:mind_mile/view/sign/signUp/signUpView.dart';
import 'package:mind_mile/view/todoList/todoListMainView.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
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
      initialRoute: '/loginView',
      getPages: [
        GetPage(name: '/loginView', page: () => const LoginView(),),
        GetPage(name: '/signUpView', page: () => const SignUpView(),),
        GetPage(name: '/todoListView', page: () => const TodoListMainView(),),
        GetPage(name: '/diaryView', page: () => const DiaryView()),
        GetPage(name: '/diaryDetailView', page: () => const DiaryDetailView()),
      ],
    );
  }
}
