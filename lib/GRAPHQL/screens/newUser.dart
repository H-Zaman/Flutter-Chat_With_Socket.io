import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';

class NewUser extends StatelessWidget {
  final GetUserToken userToken = Get.find();
  final List<NewUserModel> userList = [];

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQL.initClient(userToken.token.value),
      child: Scaffold(
        body: Subscription(
          'newUsers',
          GSubscription.newUsers,
          builder: ({error, bool loading, payload}) {
            if(loading){
              return Center(child: CircularProgressIndicator());
            }else if(error != null){
              return Center(child: Text('Error occured'));
            }else if(payload == null){
              return Center(child: Text('Empty'));
            }else{
              userList.add(NewUserModel(
                name: payload['userAdded']['email'],
                time: DateFormat('dd MMM').add_jms().format(DateTime.now())
              ));
              return ListView.builder(
                itemCount: userList.length,
                shrinkWrap: true,
                itemBuilder: (_, index){
                  return Card(
                    child: ListTile(
                      leading: Text((index+1).toString()),
                      title: Text(userList[index].name),
                      subtitle: Text(userList[index].time),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class NewUserModel{
  String name;
  String time;
  NewUserModel({
    this.name,
    this.time
});
}