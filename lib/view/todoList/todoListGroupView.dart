import 'dart:ui';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';

class TodoListGroupView extends GetView<TodoListController> {
  const TodoListGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    RxList<DragAndDropList> _contents;
    // Generate a list
    controller.contents.value = List.generate(controller.todoListGroup.length, (index) {
      return DragAndDropList(
        verticalAlignment: CrossAxisAlignment.start,
        canDrag: false,
        header: Row(
          children: [
            Icon(Icons.add_circle, size: 20, color: Color(controller.todoListGroup[index].color),),
            SizedBox(width: 10,),
            Text('${controller.todoListGroup[index].title}', style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),),
            IconButton(
              onPressed: (){

              },
              icon: Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff999999)), splashRadius: 10,)
          ],
        ),
        children: [
          for(var i in controller.todoListGroup[index].todoList)
            DragAndDropItem(
                child: Padding(
                    padding: EdgeInsets.only(left: 30),
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
      var movedItem = controller.contents[oldListIndex].children.removeAt(oldItemIndex);
      controller.contents[newListIndex].children.insert(newItemIndex, movedItem);
      controller.contents.refresh(); // 변경 사항을 즉시 반영
    }

    _onListReorder(int oldListIndex, int newListIndex) {
      var movedList = controller.contents.removeAt(oldListIndex);
      controller.contents.insert(newListIndex, movedList);
      controller.contents.refresh(); // 변경 사항을 즉시 반영
    }
    return Container(
        width: size.width,
        height: 500,
        child: Obx(() => DragAndDropLists(
            itemDragHandle: DragHandle(child: Icon(Icons.drag_handle, size: 30, color: Color(0xffD9D9D9),)),
            children: controller.contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder
        ),
      )
    );
  }
}
