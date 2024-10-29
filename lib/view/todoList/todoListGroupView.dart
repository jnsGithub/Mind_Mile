import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mind_mile/view/todoList/todoListController.dart';

class TodoListGroupView extends GetView<TodoListController> {
  const TodoListGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(3, (groupIndex) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.add_circle, color: Colors.green, size: 16),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '그룹명 $groupIndex',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: List.generate(3, (itemIndex) {
                            RxInt selectCount = 0.obs;
                            return Column(
                              children: [
                                Divider(
                                  color: Colors.grey,
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Container(
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
                                    SizedBox(width: 10),
                                    Text(
                                      '할일 $itemIndex',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      child: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16),
              ],
            );
          }),
        ),
      ),
    );
  }
}
