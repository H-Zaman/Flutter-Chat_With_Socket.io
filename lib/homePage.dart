import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/GRAPHQL/config/gqlClient.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'package:chat_app/global.dart';
import 'package:chat_app/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'GRAPHQL/loginPage.dart';
import 'global.dart';
import 'models/user.dart';

enum ChatService { socket, graphql }

showNotification() async {

  print('A service found!');

  GraphQLClient client = GQL.getSocketClient();
  Operation operation = Operation(
      documentNode: gql(GSubscription.newUsers),
      operationName: 'newUsers'
  );
  Stream<FetchResult> response = client.subscribe(operation);

  response.forEach((element) {
    print(element.data);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        Get.dialog(CupertinoAlertDialog(
          title: Text('Camera Permission'),
          content:
          Text('App requires photo storage permission to access in gallery'),
          actions: <Widget>[
            CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Get.back()
            ),
            CupertinoDialogAction(
              child: Text('Allow'),
              onPressed: () {
                AwesomeNotifications().requestPermissionToSendNotifications();
              },
            ),
          ],
        ));
      } else {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 1,
                channelKey: 'basic_channel',
                title: 'A New Challenger Has Arrived!',
                body: element.data['userAdded']['email']));
      }
    });
  });


}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatService groupValue = ChatService.socket;
  final GetUserData userToken = Get.find();

  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return;
    } else {
      AndroidAlarmManager.oneShot(Duration(seconds: 5), 0, showNotification);
      AwesomeNotifications().actionStream.listen((receivedNotification) {
        Get.to(LoginPage());
      });
    }
  }

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
                      fit: BoxFit.cover)),
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
                      onChanged: (va) {
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
                      onChanged: (va) {
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
                  onPressed: () {
                    print('asd0');
                    login(G.dummyUser[0]);
                  },
                ),
                UserButton(
                  color: Colors.cyanAccent,
                  title: 'B',
                  onPressed: () {
                    login(G.dummyUser[1]);
                  },
                ),
                UserButton(
                  color: Colors.indigoAccent,
                  title: 'C',
                  onPressed: () {
                    login(G.dummyUser[2]);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  login(User user) {
    G.loggedInUser = user;
    Get.to(HomeScreen());
  }
}

class UserButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;

  const UserButton({this.color, this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1111)),
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 34, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
