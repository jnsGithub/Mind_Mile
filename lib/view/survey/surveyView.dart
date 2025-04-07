import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/component/widgetComponent.dart';
import 'package:mind_mile/view/survey/surveyController.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => SurveyController());
    return Scaffold(
      body: Obx(() => Center(
        child: Column(
          mainAxisAlignment: controller.pageIndex.value == 9 ? MainAxisAlignment.center : MainAxisAlignment.end,
          children: [
            Obx(() => Container(
              width: size.width*0.7103,
              child: Text(
                '${controller.symptoms[controller.pageIndex.value]}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            )
            ),
            controller.pageIndex.value == 9 ? SizedBox() : Column(
              children: [
                SizedBox(height: 54,),
                buttonComponent(size.width*0.7103, 55, '전혀 방해받지 않았다', controller.selectIndex, 0, controller.pageIndex, controller.score),
                SizedBox(height: 34,),
                buttonComponent(size.width*0.7103, 55, '며칠 방해받지 않았다', controller.selectIndex, 1, controller.pageIndex, controller.score),
                SizedBox(height: 34,),
                buttonComponent(size.width*0.7103, 55, '2주중 절반 이상 방해받았다', controller.selectIndex, 2, controller.pageIndex, controller.score),
                SizedBox(height: 34,),
                buttonComponent(size.width*0.7103, 55, '거의 매일 방해받았다', controller.selectIndex, 3, controller.pageIndex, controller.score),
                SizedBox(height: 129,),
              ],
            ),
          ],
        ),
      ),
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              controller.pageIndex.value == 0 ? Container(height: 1,)
                  : IconButton(
                  onPressed: (){
                    if(controller.pageIndex.value != 0){
                      controller.pageIndex.value--;
                      controller.selectIndex.value = 0;
                    }
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: (){
                    if(controller.selectIndex.value == -1 && controller.pageIndex.value != 9){
                      if(!Get.isSnackbarOpen){
                        Get.snackbar('알림', '항목을 선택해주세요.');
                      }
                      return;
                    }
                    if(controller.symptoms.length - 1 != controller.pageIndex.value){
                      controller.pageIndex.value++;
                      controller.selectIndex.value = -1;
                      // controller.score[controller.pageIndex.value] = controller.selectIndex.value;
                    }
                    else {
                      for (int i = 0; i < controller.score.length; i++) {
                        if (controller.score[i] == -1) {
                          Get.snackbar('알림', '모든 항목을 선택해주세요.');
                          break;
                        }
                        else if (i == controller.score.length - 1) {
                          Get.toNamed('/surveyEndView');
                          print('다음화면 넘어가야함.');
                        }
                      }
                    }
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
