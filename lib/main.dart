import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/controller/message.dart';
import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'GRAPHQL/loginPage.dart';
import 'global.dart';
import 'models/user.dart';

void main() {
  final GetOnlineUsers getOnlineUsers = Get.put(GetOnlineUsers());
  final GetMessage message = Get.put(GetMessage());
  final GetUserToken getUserToken = Get.put(GetUserToken());
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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


enum ChatService{
  socket,
  graphql
}

class _HomePageState extends State<HomePage> {

  ChatService groupValue = ChatService.socket;

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
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: ChatService.socket,
                      groupValue: groupValue,
                      title: Text('Socket'),
                      onChanged: (va){
                        setState(() {
                          groupValue = va;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: ChatService.graphql,
                      groupValue: groupValue,
                      title: Text('Graphql'),
                      onChanged: (va){
                        Get.to(LoginPage());
                      },
                    ),
                  ),
                ],
              ),
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
