import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/model/diaryDetail.dart';
import 'package:mind_mile/model/records.dart';
import 'package:mind_mile/util/recordsInfo.dart';

class DiaryDetailController extends GetxController {
  RecordsInfo recordsInfo = RecordsInfo();
  RxList<Records> recordsList = <Records>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    super.onClose();
  }

  init() async {
    await getRecords();
  }

  getRecords() async {
    recordsList.value = await recordsInfo.getRecords();
  }

  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate.value, // 기본값: 현재 날짜
  //     firstDate: DateTime(2024,1), // 선택 가능 범위 시작
  //     lastDate: selectedDate.value,  // 선택 가능 범위 끝
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: Colors.blue,
  //
  //           colorScheme: ColorScheme.light(primary: Colors.blue),
  //           buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (pickedDate != null && pickedDate != selectedDate.value) {
  //     selectedDate.value = pickedDate;
  //   }
  // }
}