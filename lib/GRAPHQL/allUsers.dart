import 'dart:convert';

import 'package:chat_app/GRAPHQL/UserModel/AllUsersModel.dart';
import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/query.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {


  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  GetAllUsers getAllUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
    child: Center(child: Text('${getAllUsers.users.length}')),
        ),
    );
  }

  getAllUser() async{
    QueryResult result = await GQL().graphQLClient.query(
        QueryOptions(
            documentNode: gql(GQuery.getAllUsers),
        )
    );

    if(!result.hasException){
      print(jsonEncode(result.data));
   setState(() {
     getAllUsers = getAllUsersFromJson(jsonEncode(result.data));
   });

    }else{
      print(result.data);
    }
  }
}



