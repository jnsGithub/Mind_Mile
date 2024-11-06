import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

Widget textFieldComponent(TextEditingController controller, double width, double height, {String? hint, RxBool? isObscure}) {
  return Container(
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child:
          isObscure?.value != null ? Obx(() => TextField(
              obscureText: isObscure!.value,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: hint,
                hintStyle: hint != null ? TextStyle(color: subColor, fontWeight: FontWeight.w600) : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: mainColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: mainColor, width: 3),
                ),
                suffixIcon: Obx(() => GestureDetector(
                  onTap: () {
                    isObscure.value = !isObscure.value; // 텍스트 필드의 가시성 토글
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isObscure.value ? 'assets/images/invisible.png' : 'assets/images/visible.png'),
                      ),
                    ),
                  ),
                ))
              ),
            ),
          ) : TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10),
              hintText: hint,
              hintStyle: hint != null ? TextStyle(color: subColor, fontWeight: FontWeight.w600) : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: mainColor, width: 3),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget bottomNavi(RxInt selected, PageController controller) {
  List<int> index = [0, 0, 0, 3];
 return Container(
    height: 80,
   padding: EdgeInsets.only(bottom: 30),
   decoration: BoxDecoration(
      color: Color(0xffEAF6FF),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          offset: Offset(0, -2),
          blurRadius: 5,
          spreadRadius: 0,
        ),
      ],
   ),
   child: Row(
     children: List.generate(index.length, (index) {
       return GestureDetector(
         onTap: () {
           // controller.jumpToPage(index);
           selected.value = index;
           print(selected.value);
         },
         child: Container(
           width: Get.width / 4,
           height: 51,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               selected.value == index ? Container(
                 width: 6,
                 height: 6,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(60),
                   color: Color(0xff7F99B5),
                 ),
               ) : Container(height: 6,),
               SizedBox(height: 5),
               Image.asset(
                 index == 0
                     ? 'assets/images/bottom/check.png'
                     : index == 1
                     ? 'assets/images/bottom/calendar.png'
                     : index == 2
                     ? 'assets/images/bottom/chat.png'
                     : 'assets/images/bottom/diary.png',
                 scale: 4,
               ),
             ],
           ),
         ),
       );
     })
   )
 );
}