import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/model/todoListGroup.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';
import 'package:intl/intl.dart';

class TodoListGroupDetailView extends GetView<TodoListController> {
  TodoListGroup group;
  TodoListGroupDetailView(this.group, {super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => TodoListController());

    List<DateTime> length(){
      List<DateTime> temp = [group.todoList[0].createDate];
      for(int i = 0; i < group.todoList.length - 1; i++){
        if(group.todoList[i].createDate.year != group.todoList[i+1].createDate.year ||
            group.todoList[i].createDate.month != group.todoList[i+1].createDate.month ||
            group.todoList[i].createDate.day != group.todoList[i+1].createDate.day){
          temp.add(group.todoList[i+1].createDate);
          print(temp);
        }
      }
      return temp;
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
          for(var i in group.todoList) // 날짜 비교해서 삽입해야함.
            DragAndDropItem(
                child: length()[index] != i.createDate ? SizedBox() : Container(
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
                            if (i.completeCount.value == 2) {
                              i.completeCount.value = 0;
                            } else {
                              i.completeCount.value++;
                            }
                            print(i.completeCount.value);
                          },
                          child: Obx(() => Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    i.completeCount.value == 0 ? 'assets/images/void.png'
                                        : i.completeCount.value == 1 ? 'assets/images/half.png'
                                        : 'assets/images/full.png'
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(i.title, style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),),
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
            Icon(Icons.circle, size: 13, color: Color(group.color),),
            SizedBox(width: 20,),
            Text(group.title, style: TextStyle(fontSize: 18, color: subColor, fontWeight: FontWeight.w600),),
          ],
        ),
      ),
      body: Obx(() => DragAndDropLists(
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
