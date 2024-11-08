import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/diaryView/dirayDetail/diaryDetailController.dart';

class DiaryDetailView extends GetView<DiaryDetailController> {
  const DiaryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiaryDetailController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffEAF6FF),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xffD6EEFB),
        shadowColor: Colors.black,
        title: const Text('DiaryDetailView'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: ListView.builder(

          itemCount: controller.detailList.length,
          itemBuilder: (context, index){
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              margin: const EdgeInsets.only(bottom: 20),
              width: size.width,
              height: 118,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(DateFormat.yMMMd('ko_KR').format(controller.detailList[index].createDate), style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),),
                      Image(image: AssetImage('assets/images/score/selectHappy.png'), width: 22, height: 22),

                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Color(0x33437d9e),
                      border: Border.all(color: Color(0xff8091A47A), width: 1),
                      ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${controller.detailList[index].title}\n\n${controller.detailList[index].content}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                          // Text(),
                          // Text(controller.detailList[index].content, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
