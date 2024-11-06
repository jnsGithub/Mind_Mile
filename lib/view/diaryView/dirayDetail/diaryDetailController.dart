import 'package:get/get.dart';
import 'package:mind_mile/model/diaryDetail.dart';

class DiaryDetailController extends GetxController {
  List<DiaryDetail> detailList = [
    DiaryDetail(documentId: '1', title: '안녕1', content: '기분나쁨1', createDate: DateTime.now(), score: 1),
    DiaryDetail(documentId: '2', title: '안녕2', content: '기분나쁨2', createDate: DateTime.now(), score: 2),
    DiaryDetail(documentId: '3', title: '안녕3', content: '기분나쁨3기분나쁨3기분나쁨3기분나쁨3기분나쁨3기분나쁨3기분나쁨3기분나쁨3기분나쁨3', createDate: DateTime.now(), score: 3),
    DiaryDetail(documentId: '4', title: '안녕4', content: '기분나쁨4', createDate: DateTime.now(), score: 4)
  ];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}