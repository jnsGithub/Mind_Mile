import 'package:balloon_widget/balloon_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mind_mile/main.dart';

Color mainColor = const Color(0xffBFE0FB);
Color subColor = const Color(0xff133C6B);

String? myName;
String? uid;
int groupValue = 0;
int? wellness;
List<String> textList = [];
Map dailyWords = {
  'bad' : [
    '좋지 않은 하루.. 기록하고 날려버릴까?',
    '듀디는 항상 네편이야..!',
    '속상한 하루였던것 같아서 대신 기록해봤어',
    '안좋은 기분은 어제까지만!',
    '속상한 하루를 보냈던거야...? 내가 대신 기록해봤는데 어때..',
    '무슨일이야! 듀디한테 말해봐',
    '돌아보면 별게 아닐 수도 있어',
    '어제는 약간 센치한건가...? (눈치)',
    '기록해주면 너의 마음에 한발짝 더 다가갈 수 있을거같아'
  ],
  'well' : [
    '무료한 날이었나...?',
    '평범한게 잘사는거래',
    '무탈하면 그걸로 됐지!',
    '그저 그런 하루도 기록하면 달라져 ><',
    '그냥그냥 하루도 기록해보는 건 어때?',
    '어제는 평범한 하루였다 라고 기록하면 될까?',
    '내가 예측한 하루 검토 부탁해!',
    '무탈한 어제를 보냈구나?',
    '이정도면 좋은 하루였는걸?',
    '평범한 하루도 곱씹으면 의미있는 날일거야',
    '평온한 하루들이 모여 꿈에 이르길 바라',
    '별일만 없으면 행복한 인생 아니겠어?'
  ],
  'good' : [
    '기분좋은 날은 듀디도 같이해!',
    '듀디 까먹을정도로 좋았나보지?!',
    '좋은 날은 금방까먹는대. 기록으로 남겨보자!',
    '어제도 좋은 하루였다는거 몰랐지?',
    '기분좋은 하루의 시작을 함께해서 기뻐 ><',
    '좋은 날은 두고두고 생각해~',
    '좋은날 기록해야 긍정일기가 쌓인다구~',
    '뭔데?? 무슨 일이었는데?',
    '나도 알려줘...! 재밌는 일!!',
    '어제는 되게 좋은 날이었나봐',
    '기록을 해놔야 안잊어버리지!'
  ]
};

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setFcmToken() async {
  try{
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    await _db.collection('users').doc(uid).update({
      'fcmToken': await FirebaseMessaging.instance.getToken() ?? '',
    });
  } catch(e) {
    print(e);
  }
}

Future<void> getMyInfo() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(auth.FirebaseAuth.instance.currentUser!.uid).get();
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  myName = data['diaryName'];
  uid = auth.FirebaseAuth.instance.currentUser!.uid;
  groupValue = data['randomGroup'];
  if(data['GAD7'] != null){
    print('설문함');
    isSurvey = true;
  }else{
    print('설문 안함');
  }
  await setFcmToken();
}

void saving(BuildContext context) async {
  return showDialog<void>(
      context: context,
      barrierDismissible:false,
      builder: (BuildContext context) {
        return const AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0, // 그림자 효과 없애기
            content: Center(
              child: CircularProgressIndicator(color: Colors.white,),
            )
        );
      });
}

void initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  // final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
  //   onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
  //     // iOS에서 알림을 클릭했을 때 실행할 동작을 정의합니다.
  //   },
  // );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
      'high_importance_channel', 'high_importance_notification',
      importance: Importance.max));
}

void showNotification(RemoteMessage message) {
  initializeLocalNotifications();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'high_importance_channel',
    'high_importance_notification',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    icon: '@mipmap/ic_launcher',
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  flutterLocalNotificationsPlugin.show(
    0,
    message.notification!.title,
    message.notification!.body,
    platformChannelSpecifics,
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 메시지 처리 코드
    showNotification(message);
  print('Handling a background message: ${message.messageId}');
}

setFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if(FirebaseFirestore.instance.collection('users').doc(uid).get() != null) {
      setFcmToken();
  }


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
  });

}

class GlobalController extends GetxController {
  RxBool isShow = false.obs;
  OverlayEntry? overlayEntry;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  aa(context,targetKey, String text, {String? text2}) {
    isShow.value = !isShow.value;
    if (isShow.value) {
      showCustomTooltip(context, targetKey, text, text2: text2 == null ? null : text2);
    }
    update();
  }
  bb() {
    isShow.value = !isShow.value;
    if (!isShow.value) {
      overlayEntry?.remove();
    }
    update();
  }
  void showCustomTooltip(BuildContext context, GlobalKey key, String text, {String? text2}) {
    final RenderBox renderBox = key.currentContext
        ?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    Size size2 = MediaQuery.of(context).size;

    double a = ((key.currentContext?.findRenderObject() as RenderBox).localToGlobal(Offset.zero)).dy;

    overlayEntry = OverlayEntry(
      builder: (context) =>
          Positioned(
              left: 20,
              top: position.dy + 10, // 위젯 위에 표시되도록 위치 조정
              width: size2.width * 0.88,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Balloon(
                  color: Color(0xffD6EEFB),
                  nipPosition: BalloonNipPosition.topLeft,
                    // child: Text('dasdsaddasdsaddasdsaddasdsaddasdsad',style: TextStyle(color: Colors.black, fontSize: 10),)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(),
                        child: Text(text ,style: TextStyle(fontSize: 9, color: subColor, fontWeight: FontWeight.w500),
                        )
                    ),
                    text2 != null ? SizedBox(height: 5) : SizedBox(),
                    text2 != null ? DefaultTextStyle(
                        style: TextStyle(),
                        child: Text(text2,style: TextStyle(fontSize: 9, color: subColor, fontWeight: FontWeight.w500),
                        )
                    ): SizedBox(),
                  ],
                ),
              )
            ),
          )
    );

    Overlay.of(context).insert(overlayEntry!);
  }
}