import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

Widget textFieldComponent(TextEditingController controller, double width, double height, {String? hint, RxBool? isObscure, bool? isNumber}) {
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
            keyboardType: isNumber == null ? null : isNumber ? TextInputType.number : TextInputType.text,
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

Widget buttonComponent(double width, double height, String text, RxInt selectIndex, int index, RxInt a, RxList<int> score) {
  return Obx(() => Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          selectIndex.value = index;
          if(a.value >= 10) {
            score[a.value - 1] = index;
          } else {
            score[a.value] = index;
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: a.value >= 10 ? score[a.value - 1] == index ? Color(0xffBFE0FB) : subColor : score[a.value] == index ? Color(0xffBFE0FB) : subColor,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: a.value >= 10 ? score[a.value - 1] == index ? subColor : Colors.white : score[a.value] == index ? subColor : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}

Widget bottomNavi(BuildContext context, RxInt selected, PageController controller) {
  Size size = MediaQuery.of(context).size;
  List<int> index = [0, 0, 0, 0];
 return Container(
   alignment: Alignment.center,
    height: 80,
   padding: EdgeInsets.only(bottom: 15),
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
           if(index == 2){
              Get.toNamed('/chatView');
              return;
            }
           selected.value = index;
         },
         child: Container(
           decoration: BoxDecoration(
             border: Border.all(color: Colors.transparent),

           ),
           width: size.width * 0.25,
           height: 70,
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

