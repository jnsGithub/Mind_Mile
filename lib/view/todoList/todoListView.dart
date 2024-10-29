import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';

class TodoListView extends GetView<TodoListController> {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Listener(
        onPointerUp: (details) {
          // 드래그 종료 시 자동 스크롤 중지
          controller.stopAutoScroll();
        },
        onPointerMove: (details) {
          // 드래그 중인 아이템의 현재 위치를 업데이트
          if(controller.isDrag) {
            final position = controller.scrollController.position;
            const threshold = 150.0; // 자동 스크롤 시작 임계값
            print(details.localPosition.dy);
            if (details.localPosition.dy > MediaQuery.of(context).size.height / 2) {
              // 화면 하단 근처에 도달 시 아래로 스크롤
              controller.startAutoScroll(10.0);
            } else if (details.localPosition.dy < threshold) {
              // 화면 상단 근처에 도달 시 위로 스크롤
              controller.startAutoScroll(-10.0);
            } else {
              controller.stopAutoScroll();
            }
          }
        },
        child: ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
          // physics: const ClampingScrollPhysics(), // 내부 스크롤 비활성화
          onReorderStart: (index) {
            // 들어올릴때
            controller.isDrag = true;
            print('Reorder Start: $index');
          },
          onReorderEnd: (index) {
            // 내려놓을때
            controller.isDrag = false;
            print('Reorder End: $index');
          },
          dragStartBehavior: DragStartBehavior.start,
          onReorder: (oldIndex, newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = controller.testText.removeAt(oldIndex);
            controller.testText.insert(newIndex, item);
          },

          buildDefaultDragHandles: false,
          itemCount: controller.testText.length,
          itemBuilder: (context, index) {
            RxInt selectCount = 0.obs;
            return  Container(
              key: ValueKey(controller.testText[index]), // 고유 키 추가
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xff999999),
                  ),
                ),
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (selectCount.value == 2) {
                        selectCount.value = 0;
                      } else {
                        selectCount.value++;
                      }
                      print(selectCount.value);
                    },
                    child: Obx(() => Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        image: DecorationImage(
                          image: AssetImage(
                            selectCount.value == 0
                                ? 'assets/images/void.png'
                                : selectCount.value == 1
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
                      controller.testText[index],
                      style: TextStyle(fontSize: 16, color: subColor, fontWeight: FontWeight.w400),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  ReorderableDragStartListener( // 드래그 시작 리스너
                    index: index,
                    child: Icon(
                      Icons.drag_handle,
                      color: subColor,
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
