import 'dart:ui';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

    void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
      var movedItem = controller.todoListGroup[oldListIndex].todoList.removeAt(oldItemIndex);
      controller.todoListGroup[newListIndex].todoList.insert(newItemIndex, movedItem);
      controller.todoListGroup.refresh();
      // `controller.todoListGroup`이 변경되었으므로 자동으로 UI가 업데이트됩니다.
    }
    void _onListReorder(int oldListIndex, int newListIndex) {
      var movedList = controller.todoListGroup.removeAt(oldListIndex);
      controller.todoListGroup.insert(newListIndex, movedList);
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
            canDrag: controller.isGroupEdit.value && controller.isGroupDragHandleVisibleList[index],
            header: Container(
              height: 50,
              // decoration: controller.isGroupEdit.value ? BoxDecoration(
              //     border: Border(bottom: BorderSide(color: Color(0xff999999), width: 0.5))
              // ) : null,
              child: Obx(() => controller.todoListGroup.length == 0 ? Container()
                  : Slidable(

                controller: controller.slidableGroupControllers[index],
                closeOnScroll: true,
                enabled: controller.isGroupEdit.value,
                key: ValueKey(controller.todoListGroup[index].title + controller.todoListGroup[index].createDate.toString()),
                // controller: controller.slidableController,
                // enabled: false,

                endActionPane: ActionPane( // 오른쪽에서 왼쪽으로 드래그 시 액션 표시
                  dismissible: DismissiblePane(
                    onDismissed: () {
                    controller.isGroupDragHandleVisibleList[index] = false;
                    print('dismissed');
                  },
                  ),
                  extentRatio: controller.todoListGroup[index].title == '릴렉스 루틴' || controller.todoListGroup[index].title == '목표 없는 리스트' ? 0.15 : 0.3,
                  motion: const ScrollMotion(),
                  children: [
                    CustomSlidableAction(
                      padding: EdgeInsets.zero,
                      backgroundColor: Color(0xff56C75B),
                      onPressed: (context) {
                        addTodoListGroup(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffD9D9D9),
                              width: 1,
                            ),
                          ),
                        ),
                        child: ImageIcon(
                          AssetImage('assets/add.png'),
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    controller.todoListGroup[index].title == '릴렉스 루틴' || controller.todoListGroup[index].title == '목표 없는 리스트' ? SizedBox() : CustomSlidableAction(
                      padding: EdgeInsets.zero,
                      backgroundColor: Color(0xffE44C42),
                      onPressed: (context) {
                        // 삭제 버튼 동작
                        deleteItemDialog(context, controller.todoList, index);
                        // controller.todoList.removeAt(index);
                        // controller.todoList.refresh();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: ImageIcon(
                          AssetImage('assets/images/delete.png'),
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
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
                      Text('${controller.todoListGroup[index].title}', style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w500),),
                      !controller.isGroupEdit.value ? IconButton(
                        onPressed: (){
                          if(controller.todoListGroup[index].todoList.length == 0) {
                            controller.isEmpty.value = true;
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
                    )
                ),
            ],
          );
        });

        return Container(
          width: size.width,
          height: 500,
          child: controller.isDetail.value ? TodoListGroupDetailView(controller.todoListGroupDetail.value)
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
        );
      }),
    );
  }
}
