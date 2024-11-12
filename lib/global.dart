import 'package:balloon_widget/balloon_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color mainColor = const Color(0xffBFE0FB);
Color subColor = const Color(0xff133C6B);

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