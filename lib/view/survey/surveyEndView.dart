import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyEndView extends StatelessWidget {
  const SurveyEndView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.20,),
            Text('듀디가 공감하기 위해\n당신의 정신건강 상태를 체크했어요', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            Text('듀디와 함께 매일의 할 일을 기록하고\n하루의 기분이나 스트레스를\n점수로 표현하면서', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            Text('나의 성취와 마음상태의 관계를\n알아보세요!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 60,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff379EEB),
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              onPressed: () {
                Get.offAllNamed('/todoListView');
              },
              child: Text('시작하기', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),),
            ),
            SizedBox(height: 129,),
          ],
        ),
      ),
    );
  }
}
