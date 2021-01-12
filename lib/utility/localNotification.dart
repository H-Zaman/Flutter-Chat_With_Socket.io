import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


int channelId = 1;
String channelName = "NewUser";
String channelDescription = "Welcome User";

class LocalNotification {

  static showNotification(notificationTitle,notificationBody) async {

    //set plugin variable
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    //init plugin platform settings
    _flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: IOSInitializationSettings()),
        onSelectNotification: notificationSelected);

    //init plugin platform Details
    var platform = NotificationDetails(
        android: AndroidNotificationDetails(
            channelId.toString(), channelName, channelDescription,
            priority: Priority.high, importance: Importance.max),
        iOS: IOSNotificationDetails());
    await _flutterLocalNotificationsPlugin.show(
        channelId, notificationTitle, notificationBody, platform,
        payload: 'Minions Has Spawned!');
  }

  static Future notificationSelected(String payload) async {
    Get.snackbar('Notification', payload,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }
}
