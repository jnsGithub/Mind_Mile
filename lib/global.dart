import 'package:balloon_widget/balloon_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

Color mainColor = const Color(0xffBFE0FB);
Color subColor = const Color(0xff133C6B);

String? myName;
String? uid;
int groupValue = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> setFcmToken() async {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  await _db.collection('users').doc(uid).update({
    'fcmToken': await FirebaseMessaging.instance.getToken() ?? '',
  });
}

Future<void> getMyInfo() async {
  DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(auth.FirebaseAuth.instance.currentUser!.uid).get();
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  myName = data['name'];
  uid = auth.FirebaseAuth.instance.currentUser!.uid;
  groupValue = data['randomGroup'];
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