import 'dart:convert';

import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/mutations.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'package:chat_app/GRAPHQL/model/chatMessageModel.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

import 'chatBubble.dart';

class GChat extends StatefulWidget {
  @override
  _GChatState createState() => _GChatState();
}

class _GChatState extends State<GChat> {

  final _formKey = GlobalKey<FormState>();

  GetUserData userData = Get.find();

  TextEditingController chatMessage = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  final String name = Get.arguments['name'];
  final String id = Get.arguments['id'];

  List<MessageModel> chatMessageList = [];

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQL.initClient(userData.token.value),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('${userData.name} > $name'),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              flex: 9,
              child: Subscription(
                'onlineUsers',
                GSubscription.onlineUsers,
                variables: {"userId" : userData.id.value},
                builder: ({error, bool loading, payload}) {
                  if(loading){
                    return Text('Loading...');
                  }else if (payload == null){
                    return Text('Empty...');
                  }else{
                    if(scrollController.hasClients){
                      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
                    }
                    ChatMessageModel data = chatMessageModelFromJson(jsonEncode(payload));
                    chatMessageList.add(data.messageAdded);
                    return ListView.builder(
                      itemCount: chatMessageList.length,
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (_, index){
                        MessageModel data = chatMessageList[index];
                        return ChatBubble(
                          isMine: data.sender == userData.id.value,
                          message: data.message,
                          time: DateFormat().add_jms().format(DateTime.now()),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Flexible(
              flex: 1,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onEditingComplete: sendMessage,
                        controller: chatMessage,
                        validator: (val) => val.isEmpty ? 'Enter Message' : null,
                        decoration: InputDecoration(
                          labelText: 'Enter Message',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    if(_formKey.currentState.validate()){
      QueryResult result = await GQL().graphQLClient.mutate(MutationOptions(
        documentNode: gql(GMutation.sendMessage),
        variables:{
          "message": chatMessage.text,
          "sender": userData.id.value,
          "receiver": id
        }
      ));
      if(result.hasException){
        sendFailed(result.exception.toString());
      }else if(result.data == null){
        sendFailed('Failed to send');
      }else{
        SentChatModel data = sentChatModelFromJson(jsonEncode(result.data));
        addMessageToList(data.addMessage);
        Get.snackbar('Sent', 'Message sent');
        chatMessage.clear();
      }
    }
  }

  addMessageToList(MessageModel message){
    setState(() {
      chatMessageList.add(message);
    });
  }

  sendFailed(String reason)=> Get.dialog(Dialog(child: Padding(padding: EdgeInsets.all(20),child: Text('Send failed > $reason'),),));
}
