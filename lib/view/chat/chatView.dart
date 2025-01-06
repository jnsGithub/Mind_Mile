import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import'package:get/get.dart';
import 'package:mind_mile/global.dart';
import 'package:mind_mile/view/chat/chatController.dart';

class ChatView extends GetView<ChatController> {
  ChatView({super.key});

  Duration duration = new Duration();
  Duration position = new Duration();
  bool isPlaying = false;
  bool isLoading = false;
  bool isPause = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Get.lazyPut(() => ChatController());


    final now = new DateTime.now();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
            side: BorderSide(color: Colors.grey[300]!, width: 2),
          ),
          title: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: size.width,
              height: 50,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/setting.png'), width: 16,),
                ],
              ),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(75),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/images/dudy.png'), width: 60,),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('듀디', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),),
                      SizedBox(height: 10,),
                      Container(
                        alignment: Alignment.center,
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //     color: Colors.grey[300]!,
                          // ),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300]!,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                        child: Text('조금 천천히 가도 괜찮아', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 5,
            bottom: 80,
          ),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: controller.chatList.length,
                  itemBuilder: (context, index){
                  return Column(
                    children: [
                      if(index == 4)
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: size.width * 0.35,
                                height: 0.5,
                                color: Color(0xff8C8C8C)
                              ),
                              Text('  오늘  ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),),
                              Container(
                                  width: size.width * 0.35,
                                  height: 0.5,
                                  color: Color(0xff8C8C8C)
                              ),
                            ],
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: controller.chatList[index].isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          controller.chatList[index].isSender ? Container()
                              : Image(image: AssetImage('assets/images/dudy.png'), width: 40,),
                          BubbleSpecialOne(
                            isSender: !controller.chatList[index].isSender,
                            text: controller.chatList[index].message,
                            textStyle: TextStyle(
                              fontSize: 12,
                              color: controller.chatList[index].isSender ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400
                            ),
                            tail: false,
                            color: controller.chatList[index].isSender ? subColor : Color(0xffEAF6FF),
                            sent: false,
                            constraints: BoxConstraints(
                              maxWidth: size.width * 0.6,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                    ],
                  );
                }
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 30,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: Color(0xffEAF6FF),
            border: Border(
              top: BorderSide(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: TextField(
                      // controller: _textController,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 3,
                      // onChanged: onTextChanged,
                      // style: textFieldTextStyle,
                      decoration: InputDecoration(
                        // hintText: messageBarHintText,
                        hintMaxLines: 1,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 10),
                        // hintStyle: messageBarHintStyle,
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 0.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: InkWell(
                    child: Image(image: AssetImage('assets/images/send.png'), width: 30,),
                    onTap: () {
                      // if (_textController.text.trim() != '') {
                      //   if (onSend != null) {
                      //     onSend!(_textController.text.trim());
                      //   }
                      //   _textController.text = '';
                      // }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
