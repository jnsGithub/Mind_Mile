import 'package:get/get.dart';
import 'package:mind_mile/util/testUpdate.dart';

class SurveyController extends GetxController {
  RxInt selectIndex = (0).obs;
  RxInt pageIndex = (0).obs;

  TestUpdate testUpdate = TestUpdate();
  RxList<int> score = <int>[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1].obs;
  List<String> symptoms = [
    "기분이 가라앉거나, 우울하거나, 희망이 없\n다고 느꼈다.",
    "평소 하던 일에 대한 흥미가 없어지거나 즐\n거움을 느끼지 못했다.",
    "잠들기가 어렵거나 자주 깼다/혹은 너무 많\n이 잤다.",
    "평소보다 식욕이 줄었다/혹은 평소보다 많\n이 먹었다.",
    "다른 사람들이 눈치 챌 정도로 평소보다 말\n과 행동이 느려졌다/혹은 너무 안절부절 못\n해서 가만히 앉아 있을 수 없었다.",
    "피곤하고 기운이 없었다.",
    "내가 잘못 했거나, 실패했다는 생각이 들었\n다/혹은 자신과 가족을 실망시켰다고 생각\n했다.",
    "신문을 읽거나 TV를 보는 것과 같은 일상\n적인 일에도 집중할 수가 없었다.",
    "차라리 죽는 것이 더 낫겠다고 생각했다/혹\n은 자해할 생각을 했다.",
    '7문항이 남았어요!\n조금만 힘내주세요 :)',
    "초조하거나 불안하거나 조마조마하게 느낀\n다.",
    "걱정하는 것을 멈추거나 조절할 수가 없다.",
    "여러 가지 것들에 대해\n 걱정을 너무 많이 한다.",
    "편하게 있기가 어렵다.",
    "너무 안절부절못해서 가만히 있기가 힘들다.",
    "쉽게 짜증이 나거나 쉽게 성을 내게 된다.",
    "마치 끔찍한 일이 생길 것처럼 \n두렵게 느껴진다."
  ];

  @override
  void onInit() {
    super.onInit();
  }
  @override
  void onClose() {
    super.onReady();
  }
}