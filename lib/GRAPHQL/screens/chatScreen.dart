import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GChat extends StatefulWidget {
  @override
  _GChatState createState() => _GChatState();
}

class _GChatState extends State<GChat> {

  final _formKey = GlobalKey<FormState>();

  final String id = '5fa130db7e0a0d2bbc6820ac';

  GetUserToken userToken = Get.find();

  @override
  void dispose() {
    super.dispose();
  }

  final String userID = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQL.initClient(userToken.token.value),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text(Get.arguments),),
        body: Column(
          children: [
            Expanded(
              flex: 9,
              child: Subscription(
                'onlineUsers',
                GSubscription.onlineUsers,
                variables: {"userId" : Get.arguments},
                builder: ({error, bool loading, payload}) {
                  print(payload);
                  if(loading){
                    return Text('Loading...');
                  }else if (payload == null){
                    return Text('Empty...');
                  }else{
                    return Text('payload');
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter Message' : null,
                        decoration: InputDecoration(
                          labelText: 'Enter Message',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: sendMessage,
                          child: Container(
                            height: double.infinity,
                            color: Colors.blueGrey,
                            child: Center(
                              child: Text(
                                'Send Message',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if(_formKey.currentState.validate()){

    }
  }
}
