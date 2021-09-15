import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_important_channel",
  "High importnace notification",
  "this channel is used for importan notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

//If I want to do something when notif is selected
Future notificationSelected(String payload) async {}

class FirebaseNotifications {
  initialize() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitialize = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSinitialize,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: notificationSelected,
    );

    // Handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message after background: ${message.data}');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification apple = message.notification?.apple;

      if (notification != null && android != null && apple != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(),
          ),
        );
      }
    });
  }

  Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  /// Get any messages which caused the application to open from
  /// a terminated state.
  void getInitialMessage() async {
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('Message after terminated: ${initialMessage.data}');
    }
  }
}

class NotificationSettingsLocal {
  AuthorizationStatus authorizationStatus;

  AuthorizationStatus setAuthorizationStatus(AuthorizationStatus value) =>
      authorizationStatus = value;
}
