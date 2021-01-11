import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/GRAPHQL/gqlQuerys/subscriptions.dart';
import 'dart:convert';
class LocalNotification {
  /*
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: notificationSelected);

    var response = await http.get(GSubscription.newUsers);

    var convert = json.decode(response.body);
    if (convert['userAdded']['email'] != null) {
      showNotification(convert['userAdded']['email'].toString(), _flutterLocalNotificationsPlugin);
    } else {
      print("no message");
    }


    void showNotification(String message, _flutterLocalNotificationsPlugin) async {
  var android = AndroidNotificationDetails('channel id', 'channel NAME', 'CHANNEL DESCRIPTION', priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await _flutterLocalNotificationsPlugin.show(
      0,
      'A new user has joined!',
      'Welcome user',
      platform,
      payload: 'You got TRICKED!...bwahahaha!!');
}

Future notificationSelected(String payload) async {
  Get.snackbar('Notification', payload,
      backgroundColor: Colors.black,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM);
}
    */

  static var platform;
  static initializer() async {
    FlutterLocalNotificationsPlugin flutterNotificationPlugin = FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidSettings = AndroidNotificationDetails(
        "111", "Background_task_Channel", "Channel to test background task",
        importance: Importance.high, priority: Priority.max);
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    platform = InitializationSettings(android: android, iOS: iOS);
    flutterNotificationPlugin.initialize(platform, onSelectNotification: notificationSelected);

    var response = await http.get(GSubscription.newUserSubs);
    var convert = json.decode(response.body);

    if (convert['userAdded']['email'] != null) {
      await flutterNotificationPlugin.show(
          0,
          'A new user has joined!',
          'Welcome user',
          platform,
          payload: 'You got TRICKED!...bwahahaha!!');
    } else {
      print("no message");
    }
  }

  static Future notificationSelected(String payload) async {
    Get.snackbar('Notification', payload,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }


}
