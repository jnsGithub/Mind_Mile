import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/model/diaryDetail.dart';
import 'package:mind_mile/model/records.dart';
import 'package:mind_mile/util/recordsInfo.dart';

class DiaryDetailController extends GetxController {
  RecordsInfo recordsInfo = RecordsInfo();
  RxList<Records> allRecordsList = <Records>[].obs;
  RxList<Records> recordsList = <Records>[].obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxList<int> years = <int>[].obs;
  RxInt selectedYear = 0.obs;
  RxInt selectedMonth = (DateTime.now().month - 1).obs;
  RxInt yearsLength = 0.obs;

  RxBool isSearch = false.obs;


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
    years.value = getRecordsMaxYear();
    sortRecords();
  }



  getRecords() async {
    allRecordsList.value = await recordsInfo.getRecords();
    recordsList.assignAll(allRecordsList);
  }

  getRecordsMaxYear() {
    List<int> years = [];
    for (int i = 0; i < allRecordsList.length; i++) {
      if(years.length == 0){
        years.add(allRecordsList[i].createAt.year);
      }
      else if(years[years.length-1] != allRecordsList[i].createAt.year){
        years.add(allRecordsList[i].createAt.year);
      }
    }
    print(years);
    return years;
  }

  void searchRecords(String search) {
    recordsList.assignAll(allRecordsList.where((element) => element.title.contains(search) || element.content.contains(search)).toList().obs);
  }

  void sortRecords() {
    recordsList.assignAll(allRecordsList.where((element) => element.createAt.year == years[selectedYear.value] && element.createAt.month == selectedMonth.value + 1).toList().obs);
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