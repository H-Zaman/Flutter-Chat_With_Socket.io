import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:chat_app/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'global.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GetOnlineUsers _getOnlineUsers = Get.find();
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getOnlineUsers.onlineUserList.contains(G.toUser.id) ? Colors.green : Colors.red
              ),
            ),
            SizedBox(width: 5,),
            Text(
              G.toUser.name,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlineButton(onPressed: () async{
              await G.socketUtils.closeConnection();
              Get.offAll(HomePage());
            },
                borderSide: BorderSide(color: Colors.white,width: 3),
                child: Row(children: [
              Text('Logout',style: TextStyle(color: Colors.white,fontSize: 18),),
              SizedBox(width: 5,),
              Icon(Icons.exit_to_app_outlined,color: Colors.white,)
            ],)),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageList(),
            txtField(),
          ],
        ),
      ),
    );
  }

  Widget messageList() => Expanded(
    child: Container(
      color: Colors.pink,
    ),
  );

  Widget txtField() => Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
            color: Colors.white,
            width: 5
        )
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextField(
              minLines: 1,
              maxLines: 3,
              style: TextStyle(fontSize: 20),
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: 'Enter message',
                  fillColor: Color(0xffBDF3FF).withOpacity(.1),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide.none
                  )
              ),
            ),
          ),
          SizedBox(width: 4,),
          Expanded(
            flex: 3,
            child: FlatButton(
              onPressed: sendMessage,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Send',style: TextStyle(fontSize: 18,color: Colors.white),),
                    SizedBox(width: 3,),
                    Icon(Icons.send,color: Colors.white,size: 18,)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );

  void sendMessage() {

    if(textEditingController.text.isNotEmpty){
      DateTime now = DateTime.now();
      String time = DateFormat().add_jm().format(now);
      ChatMessageModel messageModel = ChatMessageModel(
        chatId: 100,
        chatType: SocketUtils.SINGLE_CHAT,
        from: G.loggedInUser.id,
        to: G.toUser.id,
        message: textEditingController.text,
        toUserOnlineStatus: true,
        time: time
      );
      G.socketUtils.sendSingleChatMessage(messageModel, G.toUser);
      textEditingController.clear();
    }
  }
}
