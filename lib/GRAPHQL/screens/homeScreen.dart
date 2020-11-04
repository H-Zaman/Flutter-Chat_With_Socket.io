import 'dart:convert';

import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/query.dart';
import 'package:chat_app/GRAPHQL/loginPage.dart';
import 'package:chat_app/GRAPHQL/model/userList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'chatScreen.dart';
import 'newUser.dart';

class GQLHomePage extends StatefulWidget {
  @override
  _GQLHomePageState createState() => _GQLHomePageState();
}

class _GQLHomePageState extends State<GQLHomePage> {
  GetUserData token = Get.find();

  String subscriptionName = 'onlineUsers';


  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQL.initClient(token.token.value),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome : ${token.name.value.toUpperCase()}'),
          actions: [
            IconButton(
              onPressed: ()=> Get.to(NewUser()),
              icon: Icon(Icons.person_add),
            ),
            IconButton(
              onPressed: ()=> Get.offAll(LoginPage()),
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Query(
          options: QueryOptions(
            documentNode: gql(GQuery.getAllUser)
          ),
          builder: (QueryResult result, {dynamic Function(FetchMoreOptions) fetchMore, Future<QueryResult> Function() refetch}) {
            if(result.hasException){
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      result.exception.toString()
                    ),
                  ),
                ),
              );
            }
            else if(result.data == null){
              return Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                        'Empty data'
                    ),
                  ),
                ),
              );
            }
            else{
              UserList users = userListFromJson(jsonEncode(result.data));

              User loggedInUser ;
              users.users.forEach((element) {
                if(element.email == token.name.value){
                  loggedInUser = element;
                }
              });

              token.setId(loggedInUser.id);
              users.users.remove(loggedInUser);

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10
                ),
                shrinkWrap: true,
                itemCount: users.users.length,
                itemBuilder: (_,i){
                  User user = users.users[i];
                  return GestureDetector(
                    onTap: (){
                      Get.to(GChat(),arguments: {'id':user.id, 'name':user.email});
                    },
                    child: Card(
                      child: Center(
                        child: Text(user.email),
                      ),
                    ),
                  );
                },
              );
            }
          },
        )
      ),
    );
  }
}
