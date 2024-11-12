import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyStartView extends StatelessWidget {
  const SurveyStartView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.20,),
            Text(
              '나의 현재 정신건강 상태는?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            Text(
              '앞으로 두디와의 하루 점검을 하기 전,\n자신의 정신건강 상태를 입력해 보아요.\n설문은 총 16문항입니다.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30,),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '지난 2주 동안',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, decoration: TextDecoration.underline),
                  ),
                  TextSpan(
                    text: '상태를 체크해 주세요!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 54,),
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
                Get.toNamed('/surveyView');
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
