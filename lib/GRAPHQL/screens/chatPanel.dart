import 'package:chat_app/GRAPHQL/UserModel/AllUsersModel.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatPanel extends StatefulWidget {

  String userName;
 ChatPanel({this.userName});
  @override
  _ChatPanelState createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();

  GetAllUsers getAllUsers;
  GetUserValue getUserToken = Get.find();

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
    else{
      return ;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(scrollController.hasClients){
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
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
                  color: Colors.red
              ),
            ),
            SizedBox(width: 5,),
            Text(
              '${getUserToken.name.value}',
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
/*            messageList(),
            txtField(),*/
          ],
        ),
      ),
    );
  }

/*  Widget messageList() => Flexible(
    child: ListView.builder(
      controller: scrollController,
      itemCount: _getMessage.messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 20),
      itemBuilder: chatBubble,
    ),
  );

  Widget chatBubble(BuildContext context, int index) {
    ChatMessageModel msg = _getMessage.messages[index];
    bool fromMe = msg.from == G.loggedInUser.id;
    return Align(
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipPath(
          clipper: fromMe ? SendClip() : ReceiveClip(),
          child: Container(
            decoration: BoxDecoration(
              color: fromMe ? Colors.pinkAccent : Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 18),
              child: Text(
                msg.message,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
  }*/
}

class ReceiveClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width * .04, size.height * .3);
    path.lineTo(size.width * .04, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class SendClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width * .96, size.height * .3);
    path.lineTo(size.width * .96, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
