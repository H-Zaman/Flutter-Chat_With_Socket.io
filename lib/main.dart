import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chat_app/GRAPHQL/getControolers/userToken.dart';
import 'package:chat_app/controller/message.dart';
import 'package:chat_app/controller/onlineUsers.dart';
import 'package:chat_app/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void main() async {
  Get.put(GetOnlineUsers());
  Get.put(GetMessage());
  Get.put(GetUserData());

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ]);

  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.zoom,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffBDF3F0),
        appBarTheme: AppBarTheme(color: Color(0xff6FECE4)),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage()));
}
