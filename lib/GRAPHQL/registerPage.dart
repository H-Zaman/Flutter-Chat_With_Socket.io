import 'dart:convert';

import 'package:chat_app/GRAPHQL/gqlQuerys/mutations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'config/gqlClient.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register user'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key:_formKey ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (v)=> v.isEmpty ? 'Can not be empty' : null,
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Enter email',
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                validator: (v)=> v.isEmpty ? 'Can not be empty' : null,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Enter password',
                    border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                    color: Colors.red,
                    onPressed: registerUser,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    )
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                    color: Colors.red,
                    onPressed: () => Get.back(),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white,fontSize: 20),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() async{
    if(_formKey.currentState.validate()){
      QueryResult result = await GQL().graphQLClient.mutate(MutationOptions(
          documentNode: gql(GMutation.registerUser),
          variables: {
            "email" : emailController.text,
            "password" : passwordController.text
          }
      )
      );
      if(result.hasException){
        print(result.exception.toString());
      }else{
        Get.dialog(Dialog(child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'User id: ${result.data['addUser']}'
              ),
              IconButton(
                icon: Icon(
                  Icons.next_plan_outlined
                ),
                onPressed: (){
                  Get.back();
                  Get.back();
                },
              )
            ],
          ),
        ),));
      }
    }
  }
}
