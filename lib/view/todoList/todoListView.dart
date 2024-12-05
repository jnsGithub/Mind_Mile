import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';
import 'package:mind_mile/view/todoList/todoListDialog.dart';


class TodoListView extends GetView<TodoListController> {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() => controller.todoList.length == 0 && controller.isAdd.value == false
        ? Container(
      alignment: Alignment.center,
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 18,
            color: subColor,
          ),
          const SizedBox(height: 10),
          Text(
            '오늘 할 일이 없어요 !',
            style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '오른쪽 하단 ',
                style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w400),
              ),
              Icon(
                Icons.add_circle,
                size: 10,
                color: subColor,
              ),
              Text(
                ' 버튼을 눌러 할 일을 추가해보세요 :D',
                style: TextStyle(fontSize: 10, color: subColor, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    )
        : Container(
      width: size.width,
      // height: 500,
      child: Obx(() => ReorderableListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          print(1);
          final item = controller.todoList.removeAt(oldIndex);
          controller.todoList.insert(newIndex, item);
          for(int i = 0 ; i < controller.todoList.length; i++){
            controller.todoList[i].todayIndex = i;
          }
          controller.updateTodoList();
        },

        buildDefaultDragHandles: false,
        itemCount: controller.todoList.length,
        itemBuilder: (context, index) {
          RxInt selectCount = 0.obs;
          return Slidable(
            key: ValueKey(controller.todoList[index].content + controller.todoList[index].createAt.toString()),
            // controller: controller.slidableController,
            // enabled: false,
            endActionPane: ActionPane( // 오른쪽에서 왼쪽으로 드래그 시 액션 표시
              extentRatio: 0.3,
              motion: const StretchMotion(),
              children: [
                CustomSlidableAction(
                  padding: EdgeInsets.zero,
                  backgroundColor: Color(0xff56C75B),
                  onPressed: (context) {
                    updateAlarmDialog(context, controller.todoList[index].documentId);
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
                    // child: Icon(
                    //   Icons.notifications,
                    //   color: Colors.white,
                    // ),
                    child: ImageIcon(
                      AssetImage('assets/images/bell.png'),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                CustomSlidableAction(
                  padding: EdgeInsets.zero,
                  backgroundColor: Color(0xffE44C42),
                  onPressed: (context) {
                    // 삭제 버튼 동작

                    deleteItemDialog(context, controller.todoList, index, controller.todoList[index].documentId);
                    // controller.todoList.removeAt(index);
                    // controller.todoList.refresh();
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
                    // child: Icon(
                    //   Icons.delete,
                    //   color: Colors.white,
                    // ),
                    child: ImageIcon(
                      AssetImage('assets/images/delete.png'),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xff999999),
                  ),
                ),
              ),
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => GestureDetector(
                        onTap: () {
                          if (controller.todoList[index].complete.value == 2) {
                            controller.todoList[index].complete.value = 0;
                          } else {
                            controller.todoList[index].complete.value++;
                          }
                          controller.updateComplete(controller.todoList[index]);
                        },
                        child: Container(
                          width: 30,
                          height: 29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            image: DecorationImage(
                              image: AssetImage(
                                controller.todoList[index].complete.value == 0
                                    ? 'assets/images/void.png'
                                    : controller.todoList[index].complete.value == 1
                                    ? 'assets/images/half.png'
                                    : 'assets/images/full.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: size.width * 0.6,
                        child: Text(
                          controller.todoList[index].content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 5,
                      ),
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(
                          Icons.drag_handle,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  controller.todoList[index].alarmTrue ? Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 30,
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(60),
                        //   image: DecorationImage(
                        //     image: AssetImage(
                        //       controller.todoList[index].complete.value == 0
                        //           ? 'assets/images/void.png'
                        //           : controller.todoList[index].complete.value == 1
                        //           ? 'assets/images/half.png'
                        //           : 'assets/images/full.png',
                        //     ),
                        //   ),
                        // ),
                      ),
                      const SizedBox(width: 30),
                      controller.todoList[index].alarmAt == null ? SizedBox() : Container(
                        width: size.width * 0.6,
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: Color(0xff68B64D),
                              size: 10,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${controller.todoList[index].alarmAt!.hour < 12 ? 'AM' : 'PM'} ${controller.todoList[index].alarmAt!.hour}:${controller.todoList[index].alarmAt!.minute}',
                              style: TextStyle(
                                fontSize: 7,
                                color: Color(0xff68B64D),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ) : Container(),
                ],
              ),
            ),
          );
        },
      ),
      ),
    )
    );
  }
}

// class TodoListView extends GetView<TodoListController> {
//   const TodoListView({super.key});
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     final ColorScheme colorScheme = Theme.of(context).colorScheme;
//     final Color oddItemColor = colorScheme.secondary.withOpacity(0.05);
//     final Color evenItemColor = colorScheme.secondary.withOpacity(0.15);
//     final Color draggableItemColor = colorScheme.secondary;
//     Widget proxyDecorator(
//         Widget child, int index, Animation<double> animation) {
//       return AnimatedBuilder(
//         animation: animation,
//         builder: (BuildContext context, Widget? child) {
//           final double animValue = Curves.easeInOut.transform(animation.value);
//           final double elevation = lerpDouble(0, 6, animValue)!;
//           return Material(
//             elevation: elevation,
//             color: draggableItemColor,
//             shadowColor: draggableItemColor,
//             child: child,
//           );
//         },
//         child: child,
//       );
//     }
//     return Container(
//       width: size.width,
//       height: 500,
//       child: ReorderableListView.builder(
//         shrinkWrap: true,
//         proxyDecorator: proxyDecorator,
//         physics: ClampingScrollPhysics(), // 내부 스크롤 비활성화
//         // physics: const ClampingScrollPhysics(), // 내부 스크롤 비활성화
//         onReorderStart: (index) {
//           // 들어올릴때
//           controller.isDrag = true;
//           print('Reorder Start: $index');
//         },
//         onReorderEnd: (index) {
//           // 내려놓을때
//           controller.isDrag = false;
//           print('Reorder End: $index');
//         },
//         dragStartBehavior: DragStartBehavior.start,
//         onReorder: (oldIndex, newIndex) {
//           if (oldIndex < newIndex) {
//             newIndex -= 1;
//           }
//           final String item = controller.testText.removeAt(oldIndex);
//           controller.testText.insert(newIndex, item);
//         },
//
//         buildDefaultDragHandles: false,
//         itemCount: controller.testText.length,
//         itemBuilder: (context, index) {
//           RxInt selectCount = 0.obs;
//           return  Container(
//             key: ValueKey(controller.testText[index]), // 고유 키 추가
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: const Color(0xff999999),
//                 ),
//               ),
//             ),
//             height: 60,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onDoubleTap: () {
//                     updateAlarmDialog(context);
//                   },
//                   onTap: () {
//                     if (selectCount.value == 2) {
//                       selectCount.value = 0;
//                     } else {
//                       selectCount.value++;
//                     }
//                     print(selectCount.value);
//                   },
//                   child: Obx(() => Container(
//                     width: 30,
//                     height: 30,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(60),
//                       image: DecorationImage(
//                         image: AssetImage(
//                           selectCount.value == 0
//                               ? 'assets/images/void.png'
//                               : selectCount.value == 1
//                               ? 'assets/images/half.png'
//                               : 'assets/images/full.png',
//                         ),
//                       ),
//                     ),
//                   ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Container(
//                   width: size.width * 0.6,
//                   child: Text(
//                     controller.testText[index],
//                     style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),
//                     maxLines: 2,
//                   ),
//                 ),
//                 Container(
//                   width: 5,
//                 ),
//                 ReorderableDragStartListener( // 드래그 시작 리스너
//                   index: index,
//                   child: Icon(
//                     Icons.drag_handle,
//                     color: subColor,
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
