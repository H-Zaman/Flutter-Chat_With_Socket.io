import 'package:chat_app/controller/message.dart';
import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'global.dart';
import 'models/user.dart';

void main() {
  final GetOnlineUsers getOnlineUsers = Get.put(GetOnlineUsers());
  final GetMessage message = Get.put(GetMessage());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffBDF3F0),
        appBarTheme: AppBarTheme(color: Color(0xff6FECE4)),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.height * .5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/gifs/tenor.gif'),
                  fit: BoxFit.cover
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Login as :',style: TextStyle(fontSize: 30),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UserButton(
                  color: Colors.purpleAccent,
                  title: 'A',
                  onPressed: (){
                    print('asd0');
                    login(G.dummyUser[0]);
                  },
                ),
                UserButton(
                  color: Colors.cyanAccent,
                  title: 'B',
                  onPressed: (){
                    login(G.dummyUser[1]);
                  },
                ),
                UserButton(
                  color: Colors.indigoAccent,
                  title: 'C',
                  onPressed: (){
                    login(G.dummyUser[2]);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  login(User user){
    G.loggedInUser = user;
    Get.to(HomeScreen());
  }

}

class UserButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;

  const UserButton({
    this.color,
    this.title,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1111)),
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3
            )
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
                color: color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
