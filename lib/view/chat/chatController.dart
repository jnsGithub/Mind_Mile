import 'package:get/get.dart';
import 'package:mind_mile/model/chat.dart';

class ChatController extends GetxController {
  RxList<Chat> chatList = <Chat>[
    Chat(documentId: '1', message: '그래...! 너 말대로 너가 좋아하는 드라마를 보면서 스트레스를 푸는 것도 하나의 좋은 방법 인거 같아', isSender: false, createdAt: DateTime.now()),
    Chat(documentId: '2', message: '일기장 설정에 스트레스 관리 전략 횟수 설정하기가 있어!\n적당히 횟수를 정해보 건 어때?', isSender: false, createdAt: DateTime.now()),
    Chat(documentId: '3', message: '왜 그런 좋은기능을 너만알고있어', isSender: true, createdAt: DateTime.now()),
    Chat(documentId: '4', message: '아;; 미안.. 여하튼 널 위해 최선을 다하는 중이야', isSender: false, createdAt: DateTime.now()),
    Chat(documentId: '5', message: '오늘 많이 힘든 하루를 보냈었던거야...? 혹시 누구랑 불편한 일은 없었구ㅠㅠ', isSender: false, createdAt: DateTime.now()),
    Chat(documentId: '6', message: '아니.. 뭐 그냥.. 어떻게 알았어..?', isSender: true, createdAt: DateTime.now()),
    Chat(documentId: '7', message: '저번에도 나랑 같이 명상할 때 마음 쓰이는 친구가 있다고 해서ㅠㅠ 그런 갈등있으면 일이 손에 안잡히잖아.', isSender: false, createdAt: DateTime.now()),
    Chat(documentId: '8', message: '웅.. 약간 신경이 쓰이긴 하더라구 근데 내가 할 수 있는게 없어서 ㅠ', isSender: true, createdAt: DateTime.now()),
    Chat(documentId: '8', message: '뭔데.. 나한테 털어놔봐', isSender: false, createdAt: DateTime.now()),
  ].obs;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}