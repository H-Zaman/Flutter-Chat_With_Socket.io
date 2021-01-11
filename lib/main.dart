import 'dart:convert';

import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'package:chat_app/controller/message.dart';
import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/homeScreen.dart';
import 'package:chat_app/utility/localNotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'GRAPHQL/loginPage.dart';
import 'global.dart';
import 'models/user.dart';

import 'package:http/http.dart' as http;
String uniqueName = "AndBazaar";
Stream<FetchResult> response;
const simplePeriodicTask = "Welcome User";

void callbackDispatcher() {

  Workmanager.executeTask((task, inputData) async {
    // LocalNotification.initializer();
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: notificationSelected);
    showNotification('Notification', _flutterLocalNotificationsPlugin);
    print('hellllllllooooooooooo');
    return Future.value(true);
  });
}

void showNotification(String message, _flutterLocalNotificationsPlugin) async {
  var android = AndroidNotificationDetails(
      "111", "Background_task_Channel", "Channel to test background task",
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await _flutterLocalNotificationsPlugin.show(
      01,
      message,
      '100% Sale for unlimited time!',
      platform,
      payload: 'You got TRICKED!...bwahahaha!!');

  uniqueName+=uniqueName;
}

Future notificationSelected(String payload) async {
  Get.snackbar('Notification', payload,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM);
}


registerTask() async {
  await Workmanager.registerPeriodicTask(
    'newUsers',
    'A new user!',
    existingWorkPolicy: ExistingWorkPolicy.replace,
    initialDelay: Duration(seconds: 5),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  print('task added');
}

void main() async {
  Get.put(GetOnlineUsers());
  Get.put(GetMessage());
  Get.put(GetUserData());

  WidgetsFlutterBinding.ensureInitialized();
  // response = await GSubscription.newUserSubs();
  final GetUserData userToken = Get.find();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    defaultTransition: Transition.zoom,
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xffBDF3F0),
      appBarTheme: AppBarTheme(color: Color(0xff6FECE4)),
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: GraphQLProvider(
      client: GQL.initClient(userToken.token.value),
      child: Scaffold(
        body: Subscription(
          'newUsers',
          GSubscription.newUsers,
          builder: ({error, bool loading, payload}) {
            if(payload != null){
              // registerTask();
              LocalNotification.initializer();
            }
            return HomePage();
          },
        ),
      ),
    ),
  ));
}

enum ChatService{
  socket,
  graphql
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
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
