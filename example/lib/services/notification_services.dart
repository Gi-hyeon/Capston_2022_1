import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotifyHelper{
  FlutterLocalNotificationsPlugin 
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); 

  initializeNotification() async {
    _configureLocalTimezone();
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
         requestSoundPermission: false,
         requestBadgePermission: false,
         requestAlertPermission: false,
         onDidReceiveLocalNotification: onDidReceiveLocalNotification
         );
     
    final AndroidInitializationSettings initializationSettingsAndroid =
     AndroidInitializationSettings("@mipmap/ic_launcher");

    // 이 객체를 실제 알림에 사용함
    final InitializationSettings initializationSettings =
        InitializationSettings(
       iOS: initializationSettingsIOS,
       android:initializationSettingsAndroid,
       );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: selectNotification);

  }

  Future<void> displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 
        channelDescription:'your channel description',

        importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, 
        iOS: iOSPlatformChannelSpecifics);
         
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Defalut_Sound',
    );
  }

  scheduledNotification( int hour, int minutes, Task task ) async {
     await flutterLocalNotificationsPlugin.zonedSchedule(
       0,
       'scheduled title',
       'theme changes 5 seconds ago',
       _convertTime(hour, minutes),
       //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
       const NotificationDetails(
         android: AndroidNotificationDetails('your channel id', 
         'your channel name', 
         channelDescription:'your channel description')),
         androidAllowWhileIdle: true,
         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
         matchDateTimeComponents: DateTimeComponents.time
         );

   }

   tz.TZDateTime _convertTime(int hour, int minutes){
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate= 
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    
    if(scheduleDate.isBefore(now)){
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async{
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
    IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
     Get.to(()=>Container(color:Colors.white));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
        Get.dialog(Text("Welcome to flutter"));
  }
}