import 'dart:ui';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slidable_panel/flutter_slidable_panel.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';
import 'package:mind_mile/view/todoList/todoListDialog.dart';
import 'package:mind_mile/view/todoList/todoListGroupDetailView.dart';

class TodoListGroupView extends GetView<TodoListController> {
  const TodoListGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) async {
      // print('oldItemIndex : $oldItemIndex, oldListIndex : $oldListIndex, newItemIndex : $newItemIndex, newListIndex : $newListIndex');
      var movedItem = controller.todoListGroup[oldListIndex].todoList.removeAt(oldItemIndex);
      controller.todoListGroup[newListIndex].todoList.insert(newItemIndex, movedItem);
      for(int i = 0; i < controller.todoListGroup[newListIndex].todoList.length; i++){
        controller.todoListGroup[newListIndex].todoList[i].sequence = i;
      }
      controller.changeTodoListGroup(
          controller.todoListGroup[newListIndex],
          controller.todoListGroup[oldListIndex],
          controller.todoListGroup[newListIndex].todoList,
          controller.todoListGroup[oldListIndex].todoList);
      await controller.init();
      controller.todoListGroup.refresh();
    }

    void _onListReorder(int oldListIndex, int newListIndex) async {
      var movedList = controller.todoListGroup.removeAt(oldListIndex);
      controller.todoListGroup.insert(newListIndex, movedList);
      for(int i = 0; i < controller.todoListGroup[newListIndex].todoList.length; i++){
        controller.todoListGroup[newListIndex].sequence = i;
      }
      await controller.todoListInfo.updateIndexGroup(controller.todoListGroup);
      await controller.init();
      controller.todoListGroup.refresh();
      // 마찬가지로 UI가 업데이트됩니다.
    }
    return SingleChildScrollView(
      child: Obx(() {
        controller.contents.value = List.generate(controller.todoListGroup.length, (index) {
          return DragAndDropList(
            contentsWhenEmpty: SizedBox(),
            verticalAlignment: CrossAxisAlignment.center,
            horizontalAlignment: MainAxisAlignment.start,
            canDrag: controller.isGroupEdit.value && controller.isGroupDragHandleVisibleList[index],//controller.slidableGroupControllers[index].dismissed,//controller.isGroupDragHandleVisibleList[index],
            header: Container(
              height: 50,
              child: Obx(() => controller.todoListGroup.length == 0 ? Container()
                  : SlidablePanel(
                controller: controller.slidableGroupControllers[index],
                gestureDisabled: !controller.isGroupEdit.value,
                key: ValueKey(controller.todoListGroup[index].content + controller.todoListGroup[index].createAt.toString()),
                maxSlideThreshold: controller.todoListGroup[index].content == '릴렉스 루틴' || controller.todoListGroup[index].content == '목표 없는 리스트' ? 0.15 : 0.3,
                onSlideStart: () async {
                  // print('수정중임? ${controller.isGroupEdit.value}');
                  // print('얘꺼 뭐 됨? ${controller.isGroupDragHandleVisibleList[index]}');
                  // Future.delayed(Duration(milliseconds: 1000), () {
                  //   print('슬라이드 닫힘? ${controller.slidableGroupControllers[index].dismissed}');
                  // });
                  Future.delayed(Duration(milliseconds: 500), () {
                    if(!controller.slidableGroupControllers[index].dismissed){
                      // print('닫힘');
                      controller.isGroupDragHandleVisibleList[index] = false;
                    }
                    else{
                      // print('열림');
                      controller.isGroupDragHandleVisibleList[index] = true;
                    }
                    controller.update();
                  });
                },
                axis: Axis.horizontal,
                postActions: [
                  GestureDetector(
                    onTap: () {
                      addTodoListGroup(context, true, title: controller.todoListGroup[index].content, group: controller.todoListGroup[index]);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Color(0xff56C75B),
                      child: ImageIcon(
                        AssetImage('assets/add.png'),
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  if(controller.todoListGroup[index].content != '릴렉스 루틴' && controller.todoListGroup[index].content != '목표 없는 리스트')
                    GestureDetector(
                      onTap: () {
                        deleteTodoListGroupDialog(context, controller.todoListGroup[index], index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Color(0xffE44C42),
                        child: ImageIcon(
                          AssetImage('assets/images/delete.png'),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                ],
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      border: controller.isGroupEdit.value ? Border(bottom: BorderSide(color: Color(0xff999999), width: 0.5)) : null
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, size: 20, color: Color(controller.todoListGroup[index].color),),
                      SizedBox(width: 10,),
                      Text('${controller.todoListGroup[index].content}', style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w500),),
                      !controller.isGroupEdit.value ? IconButton(
                        onPressed: (){
                          controller.selectedGroupId = controller.todoListGroup[index].documentId;
                          if(controller.todoListGroup[index].todoList.length == 0) {
                            controller.isEmpty.value = true;
                            controller.todoListGroupDetail.value = controller.todoListGroup[index];
                          } else {
                            controller.isEmpty.value = false;
                            controller.todoListGroupDetail.value = controller.todoListGroup[index];
                          }
                          controller.isDetail.value = !controller.isDetail.value;
                        },
                        icon: Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xff999999)), splashRadius: 10,) : SizedBox()
                    ],
                  ),
                ),
              )),
            ),
            children: [
              for(var i in controller.todoListGroup[index].todoList)
                DragAndDropItem(
                    child: Obx(() => controller.isGroupEdit.value ? SizedBox() : Padding(
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
                                    if (i.complete.value == 2) {
                                      i.complete.value = 0;
                                    } else {
                                      i.complete.value++;
                                    }
                                    controller.updateComplete(i);
                                    // print(i.complete.value);
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
                    )
                ),
            ],
          );
        });

        return Obx(() => Container(
            width: size.width,
            height: 500,
            child: controller.isDetail.value ? TodoListGroupDetailView(controller.todoListGroupDetail)
                : DragAndDropLists(
              onListDraggingChanged: (isDragging, bool) {

              },

                contentsWhenEmpty: Container(
                  height: 50,
                  width: size.width,
                  child: Center(
                    child: Text('No items'),
                  ),
                ),
                lastItemTargetHeight: 5,
                verticalAlignment: CrossAxisAlignment.center,
                // listDivider: controller.isGroupEdit.value ?  Divider(
                //   height: 0,
                //   thickness: 2,
                //   color: Color(0xffD9D9D9),
                // ) : null,
                listDragHandle: controller.isGroupEdit.value ? DragHandle(child: Icon(Icons.drag_handle, size: 30, color: Color(0xffD9D9D9),)) : null,
                itemDragHandle: !controller.isGroupEdit.value ? DragHandle(child: Icon(Icons.drag_handle, size: 30, color: Color(0xffD9D9D9),)) : null,
                children: controller.contents,
                onItemReorder: _onItemReorder,
                onListReorder: _onListReorder
            ),
          ),
        );
      }),
    );
  }
}
