import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/diaryView/dirayDetail/diaryDetailController.dart';


class DiaryDetailView extends GetView<DiaryDetailController> {
  const DiaryDetailView({super.key});

  @override
  Widget build(BuildContext context) {

    Get.lazyPut(() => DiaryDetailController());
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffEAF6FF),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Color(0xffD6EEFB),
        shadowColor: Colors.black,
        centerTitle: true,
        title: Obx(() => controller.isSearch.value ? Container(
          height: 30,
          width: size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: '검색어를 입력해주세요',
              hintStyle: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            ),
            onChanged: (value){
              controller.searchRecords(value);
            },
          ),
        )
            : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => DropdownButton(
                  borderRadius: BorderRadius.circular(20),
                  menuMaxHeight: 200,
                  hint: Text('${controller.years.isEmpty ? 2024 : controller.years[controller.selectedYear.value]}년', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),),
                  iconSize: 0,
                  items: List.generate(
                      controller.years.length, (index) =>
                      DropdownMenuItem(
                        child: Text('${controller.years[index]}년', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),),
                        value: index,
                        onTap: () {
                          controller.selectedYear.value = index;
                          controller.sortRecords();
                          print(index);
                        },
                      )
                  ),
                  onChanged: (value){
                    controller.selectedYear.value = value as int;
                    controller.sortRecords();
                    print(value);
                  },
                  underline: Container(),
                ),
              ),
              const SizedBox(width: 5),
              Obx(() => DropdownButton(
                  borderRadius: BorderRadius.circular(20),
                  hint: Text('${controller.selectedMonth.value + 1}월', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),),
                  menuMaxHeight: 200,
                  iconSize: 0,
                  items: List.generate(
                      12, (index) =>
                      DropdownMenuItem(
                        child: Text('${index + 1}월', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),),
                        value: index,
                        onTap: () {
                          controller.selectedMonth.value = index;
                          controller.sortRecords();
                          print(index);
                        },
                      )
                  ),

                  onChanged: (value){
                    controller.selectedMonth.value = value as int;
                    controller.sortRecords();
                    print(controller.recordsList.length);
                    print(value);
                  },
                  underline: Container(),
                ),
              ),
              // Obx(() => Text('${controller.recordsList.length == 0 ? '' : DateFormat.yMMM('ko_KR').format(controller.recordsList[0].createAt)}', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),)),
              Icon(Icons.keyboard_arrow_down, color: subColor, size: 23),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                controller.isSearch.value = !controller.isSearch.value;
          }, icon: Icon(Icons.search, color: subColor, size: 24)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        child: Obx(() => ListView.builder(
          itemCount: controller.recordsList.length,
          itemBuilder: (context, index){
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              margin: const EdgeInsets.only(bottom: 20),
              width: size.width,
              height: 118,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image(image: AssetImage(controller.recordsList[index].mood != 0 ? 'assets/images/score/selectHappy.png' : 'assets/images/score/selectSoso.png'), width: 22, height: 22),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xffEAF6FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${DateFormat.yMMMd('ko_KR').format(controller.recordsList[index].createAt)} ${DateFormat.E('ko_KR').format(controller.recordsList[index].createAt)}요일', style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w600),)),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 60,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${controller.recordsList[index].title}\n\n${controller.recordsList[index].content}',
                            style: TextStyle(fontSize: 12, color: subColor, fontWeight: FontWeight.w400),),
                          // Text(),
                          // Text(controller.detailList[index].content, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}

