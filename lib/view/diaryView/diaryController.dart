import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DiaryController extends GetxController {
  List<String> diaryList = ['친구', '먹다', '오다', '다투다', '하루',' 일본',' 맛있다', '만나다'];

  GlobalKey barChart1 = GlobalKey();
  GlobalKey barChart2 = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose() {
    super.onClose();
  }
}