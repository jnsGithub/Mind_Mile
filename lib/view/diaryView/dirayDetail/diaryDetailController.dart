import 'package:get/get.dart';
import 'package:mind_mile/model/diaryDetail.dart';

class DiaryDetailController extends GetxController {
  List<DiaryDetail> detailList = [
    DiaryDetail(documentId: '1', title: '발표했어요! 휴!', content: '너무나도 뿌듯했당 😝', createDate: DateTime.now(), score: 1),
    DiaryDetail(documentId: '2', title: '그냥 평범한 하루였다.', content: '명성이랑 같이 파스타 먹으러 간건 좋았는데 일단 할일이 너무 많아버려... 으아ㅏㅏ 어떻게 할지 모르겠당 ㅠㅠ', createDate: DateTime.now(), score: 0),
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