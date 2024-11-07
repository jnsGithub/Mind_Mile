import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/survey/surveyController.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => SurveyController());
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${controller.symptoms[0]}'),
            buttonComponent(size.width*0.7103, 55, '전혀 방해받지 않았다', controller.selectIndex, 0),
            buttonComponent(size.width*0.7103, 55, '며칠 방해받지 않았다', controller.selectIndex, 0),
            buttonComponent(size.width*0.7103, 55, '2주중 절반 이상 방해받았다', controller.selectIndex, 0),
            buttonComponent(size.width*0.7103, 55, '거의 매일 방해받았다', controller.selectIndex, 0),
          ],
        ),
      ),
    );
  }
}
