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

    print(group.value.content);
    print(controller.isEmpty.value);
    List<dynamic> length(){
      if(!controller.isEmpty.value){
        List<DateTime> temp = [group.value.todoList[0].date];
        for(int i = 0; i < group.value.todoList.length - 1; i++){
          if(group.value.todoList[i].date.year != group.value.todoList[i+1].date.year ||
              group.value.todoList[i].date.month != group.value.todoList[i+1].date.month ||
              group.value.todoList[i].date.day != group.value.todoList[i+1].date.day){
            temp.add(group.value.todoList[i+1].date);
            // print(temp);
          }
        }
        return temp;
      }
      else{
        return [];
      }
    }
    print(length());
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
          for(var i in group.value.todoList) // 날짜 비교해서 삽입해야함.
            DragAndDropItem(
                child: length()[index] != i.date ? SizedBox() : Container(
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
                )
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


    _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
      var movedItem = contents[oldListIndex].children.removeAt(oldItemIndex);
      contents[newListIndex].children.insert(newItemIndex, movedItem);
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
          onPressed: () {
            controller.isDetail.value = false;
          },
          icon: Icon(Icons.arrow_back_ios, size: 15,),
        ),
        title: Row(
          children: [
            Icon(Icons.circle, size: 13, color: Color(group.value.color),),
            SizedBox(width: 20,),
            //controller.isEmpty.value ? SizedBox() :
            Text(group.value.content, style: TextStyle(fontSize: 18, color: subColor, fontWeight: FontWeight.w600),),
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
