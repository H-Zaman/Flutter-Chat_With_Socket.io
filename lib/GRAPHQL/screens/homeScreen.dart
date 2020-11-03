import 'dart:convert';

import 'package:chat_app/GRAPHQL/UserModel/AllUsersModel.dart';
import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/query.dart';
import 'package:chat_app/GRAPHQL/screens/chatPanel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GQLHomePage extends StatefulWidget {
  @override
  _GQLHomePageState createState() => _GQLHomePageState();
}


class _GQLHomePageState extends State<GQLHomePage> {

  GetAllUsers getAllUsers;

  GetUserValue getUserToken = Get.find();

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GQL.initClient(getUserToken.token.value),
      child: Scaffold(
        appBar: AppBar(title: Text('Users'),),
    body: Query(
      options: QueryOptions(
        documentNode: gql(GQuery.getAllUsers),
      ),
      builder: (QueryResult result,
          {dynamic Function(FetchMoreOptions) fetchMore,
              Future<QueryResult> Function() refetch}) {
        if(result.hasException){
          return Text('Error');
        }
        else if(result.data == null){
          return Text('No data');
        }
        else{
          getAllUsers = getAllUsersFromJson(jsonEncode(result.data));
          return ListView.builder(
            itemCount: getAllUsers.users.length,
            itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Get.to(ChatPanel());
              },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle,color: Colors.red,),
                        SizedBox(width: 10,),
                        Text('${getAllUsers.users[index].email}'),
                      ],
                    ),
                  )),
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
