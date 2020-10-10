import 'package:chat_app/chatScreen.dart';
import 'package:chat_app/controller/message.dart';
import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/models/chatMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'global.dart';
import 'models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<User> userList;

  String connectionStatus = 'Connecting...';

  GetOnlineUsers _getOnlineUsers = Get.find();
  GetMessage _getMessage = Get.find();

  @override
  void initState() {
    super.initState();
    userList = G.getUserList(G.loggedInUser);
    G.initSocket();
    connectSocket();
  }

  connectSocket() async{
    await G.socketUtils.initSocket(G.loggedInUser);
    G.socketUtils.connectToSocket();

    G.socketUtils.onlineUserList(onlineUserList);

    G.socketUtils.setOnChatMessageReceivedListener(onChatMessageReceived);
    G.socketUtils.setOnMessageBackFromServer(onMessageBackFromServer);


    G.socketUtils.setConnectListener(onConnect);
    G.socketUtils.setOnDisconnectListener(onDisconnect);
    G.socketUtils.setOnErrorListener(onError);
    G.socketUtils.setOnConnectionErrorListener(onConnectError);
  }

  onChatMessageReceived(data){
    print('onChatMessageReceived');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    _getMessage.messages.add(chatMessageModel);
    showNotification(chatMessageModel.from);
  }

  onMessageBackFromServer(data){
    print('onMessageBackFromServer');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    _getMessage.messages.add(chatMessageModel);
  }

  onlineUserList(data){
    _getOnlineUsers.clearList();
    setState(() {
      data.forEach((e){
        _getOnlineUsers.addUser(int.parse(e));
      });
    });
  }

  showNotification(int id){
    String userName = getUserName(id);
    Get.snackbar(
      'New Message',
      'From $userName'
    );
  }

  getUserName(int id){
    String name;
    userList.forEach((element) {
      if(element.id == id){
        name = element.name;
      }
    });
    return name ?? "a friend";
  }

  onConnect(data) {
    print('Connected $data');
    setState(() {
      connectionStatus = 'Connected';
    });
  }

  onConnectError(data) {
    print('onConnectError $data');
    setState(() {
      connectionStatus = 'Failed to Connect';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      connectionStatus = 'Connection Failed';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      connectionStatus = 'Disconnected';
    });
  }

  @override
  void dispose() {
    G.socketUtils.closeConnection();
    _getMessage.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: connectionStatus == 'Connected' ? Colors.green : Colors.red,
                radius: 10
              ),
            ),
            SizedBox(width: 1,),
            Text(connectionStatus,style: TextStyle(color: connectionStatus == 'Connected' ? Colors.green : Colors.red),),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10
            ),
            itemCount: userList.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            itemBuilder: (context, index){
              User user = userList[index];
              return GestureDetector(
                onTap: (){
                  _getMessage.clearAll();
                  G.toUser = user;
                  Get.to(ChatScreen());
                },
                child: GridTile(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(user.image),
                        radius: 50,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11),),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: _getOnlineUsers.onlineUserList.contains(user.id) ? Colors.green : Colors.red,
                                    shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(user.name,
                                style: TextStyle(
                                  fontSize: 20
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }
}
