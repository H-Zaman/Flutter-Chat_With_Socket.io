import 'package:chat_app/GRAPHQL/gqlQuerys/query.dart';
import 'package:chat_app/GRAPHQL/registerPage.dart';
import 'package:chat_app/GRAPHQL/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'config/gqlClient.dart';
import 'getControolers/userToken.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController(text: 'taz');
  final TextEditingController passwordController = TextEditingController(text: '123');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to continue'),
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
                      onPressed: loginUser,
                      child: Text(
                        'Login',
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
                      onPressed: () => Get.to(RegisterUser()),
                      child: Text(
                        'Register user',
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      )
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  void loginUser() async{
    if(_formKey.currentState.validate()){
      QueryResult result = await GQL().graphQLClient.query(
          QueryOptions(
              documentNode: gql(GQuery.loginUser),
              variables: {
                "email" : emailController.text,
                "password" : passwordController.text
              }
          )
      );

      if(!result.hasException){
        Get.offAll(GQLHomePage());
        GetUserData userToken = Get.find();
        userToken.setToken(result.data['userLogin']['token']);
        userToken.setName(emailController.text);
      }else{
        Get.snackbar('Error', 'Login Failed!');
      }
    }
  }
}
