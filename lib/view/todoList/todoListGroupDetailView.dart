import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';
import 'package:intl/intl.dart';

class TodoListGroupDetailView extends GetView<TodoListController> {
  Rx<TodoListGroup> group;
  TodoListGroupDetailView(this.group, {super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Get.lazyPut(() => TodoListController());

    // print(group.value.content);
    // print(controller.isEmpty.value);
    RxList<dynamic> length() {
      if (!controller.isEmpty.value) {
        RxList<DateTime> temp = [
          DateTime(controller.todoListGroupDetail.value.todoList[0].date.year,
              controller.todoListGroupDetail.value.todoList[0].date.month,
              controller.todoListGroupDetail.value.todoList[0].date.day)
        ].obs;

        for (int i = 1; i < controller.todoListGroupDetail.value.todoList.length; i++) {
          bool isDuplicate = false;
          // 현재 todoList의 날짜와 temp의 날짜를 비교
          for (int j = 0; j < temp.length; j++) {
            if (controller.todoListGroupDetail.value.todoList[i].date.year == temp[j].year &&
                controller.todoListGroupDetail.value.todoList[i].date.month == temp[j].month &&
                controller.todoListGroupDetail.value.todoList[i].date.day == temp[j].day) {
              isDuplicate = true; // 중복된 날짜를 발견
              break; // 중복된 날짜가 있으므로 더 이상 비교할 필요 없음
            }
          }

          // 중복되지 않으면 temp에 추가
          if (!isDuplicate) {
            temp.add(DateTime(
              controller.todoListGroupDetail.value.todoList[i].date.year,
              controller.todoListGroupDetail.value.todoList[i].date.month,
              controller.todoListGroupDetail.value.todoList[i].date.day,
            ));
          }
        }

        print(temp);
        return temp;
      } else {
        return [].obs;
      }
    }
    // print(length());
    RxList<DragAndDropList> contents = <DragAndDropList>[].obs;
    contents.value = List.generate(length().length, (index) {
      return DragAndDropList(
        verticalAlignment: CrossAxisAlignment.start,
        canDrag: false,
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${DateFormat.MMMMEEEEd('ko_KR').format(length()[index])}', style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w600),),
            Divider(color: Color(0xff999999), thickness: 0.5,),
          ],
        ),
        children: [
          for(var i in controller.todoListGroupDetail.value.todoList) // 날짜 비교해서 삽입해야함.
            if(DateTime(i.date.year, i.date.month, i.date.day) == length()[index])
              DragAndDropItem(
                key: ValueKey(i.documentId),
                  child: Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xff999999), width: 0.5))
                        ),
                        alignment: Alignment.centerLeft,
                        height: 50,
                        width: size.width,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if (i.complete.value == 2) {
                                  i.complete.value = 0;
                                } else {
                                  i.complete.value++;
                                }
                                controller.todoListInfo.updateComplete(i.documentId, i.complete.value);
                                print(i.complete.value);
                              },
                              child: Obx(() => Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        i.complete.value == 0 ? 'assets/images/void.png'
                                            : i.complete.value == 1 ? 'assets/images/half.png'
                                            : 'assets/images/full.png'
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(i.content, style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),),
                          ],
                        )
                    ),
              ),
          // DragAndDropItem(
          //   child: Padding(
          //       padding: EdgeInsets.only(left: 30),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         border: Border(bottom: BorderSide(color: Color(0xff999999), width: 0.5))
          //       ),
          //         alignment: Alignment.centerLeft,
          //         height: 50,
          //         width: size.width,
          //         child: Text('$index.1'))
          //   )
          // ),
          // DragAndDropItem(
          //     child: Padding(
          //         padding: EdgeInsets.only(left: 30),
          //         child: Container(alignment: Alignment.centerLeft,height: 50, width: size.width,child: Text('$index.2'))
          //     )
          // ),
          // DragAndDropItem(
          //     child: Padding(
          //         padding: EdgeInsets.only(left: 30),
          //         child: Container(alignment: Alignment.centerLeft,height: 50, width: size.width,child: Text('$index.3'))
          //     )
          // )
        ],
      );
    });


    _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) async {
      // print('-----------------');
      var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
      contents[newListIndex].children.insert(newItemIndex, movedItem);
      print('oldItemIndex : $oldItemIndex');
      print('oldListIndex : $oldListIndex');
      print('newItemIndex : $newItemIndex');
      print('newListIndex : $newListIndex');
      print(controller.todoListGroupDetail.value.todoList[newListIndex].content);
      print(contents[newListIndex].children[newItemIndex].key);
      final key = contents[newListIndex].children[newItemIndex].key;

      if (key is ValueKey) {
        String value = key.value;
        await controller.todoListInfo.updateGroupInItemIndex(value, length()[newListIndex]);
      } else {
        print("The key is not a ValueKey.");
      }
      // await controller.todoListInfo.updateGroupInItemIndex(controller.todoListGroupDetail.value.todoList[newItemIndex], length()[newListIndex]);
      contents.refresh(); // 변경 사항을 즉시 반영
    }

    _onListReorder(int oldListIndex, int newListIndex) {
      var movedList = contents.removeAt(oldListIndex);
      contents.insert(newListIndex, movedList);
      contents.refresh(); // 변경 사항을 즉시 반영
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        leadingWidth: 20,
        leading: IconButton(
          onPressed: () async {
            await controller.init();

            controller.isDetail.value = false;
          },
          icon: Icon(Icons.arrow_back_ios, size: 15,),
        ),
        title: Row(
          children: [
            Icon(Icons.circle, size: 13, color: Color(controller.todoListGroupDetail.value.color),),
            SizedBox(width: 20,),
            //controller.isEmpty.value ? SizedBox() :
            Text(controller.todoListGroupDetail.value.content, style: TextStyle(fontSize: 18, color: subColor, fontWeight: FontWeight.w600),),
          ],
        ),
      ),
      body: controller.isEmpty.value ? Container() : Obx(() => DragAndDropLists(
        listDragHandle: DragHandle(child: Icon(Icons.drag_handle, size: 30, color: Color(0xffD9D9D9),)),
            itemDragHandle: DragHandle(child: Icon(Icons.drag_handle, size: 30, color: Color(0xffD9D9D9),)),
            children: contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder
        ),
      ),
    );
  }
}
