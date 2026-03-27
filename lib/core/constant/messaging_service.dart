import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:developer';

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token

  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      // alert: true,
      // announcement: false,
      // badge: true,
      // carPlay: false,
      // criticalAlert: true,
      // provisional: false,
      // sound: true,
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    var testotken = await _fcm.getAPNSToken();
    if (testotken != null) {}

    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // if (message.notification != null) {
      //   if (message.notification!.title != null &&
      //       message.notification!.body != null) {
      //     final notificationData = message.data;
      //     int? screen = notificationData['screen'] != null
      //         ? notificationData['screen']
      //         : null;
      //     int? argument = notificationData['params'] != null
      //         ? notificationData['params']
      //         : null;
      //     final url =
      //         notificationData["url"] != null ? notificationData["url"] : null;
      //     if (screen != null && argument != null) {
      //       Constant.pageController!.jumpToPage(screen);
      //       // Navigator.of(context).pushNamed(screen, arguments: {"page": 1});
      //     }

      //     if (url != null) {
      //       if (await canLaunch(url)) {
      //         await launch(url);
      //       } else {
      //         throw "Could not launch ${url}";
      //       }
      //     }
      //   }
      // }
    });
    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  Future<void> _handleNotificationClick(
      BuildContext context, RemoteMessage message) async {
    if (message.notification != null) {
      if (message.notification!.title != null &&
          message.notification!.body != null) {
        final notificationData = message.data;
        int? screen = notificationData['screen'] != null
            ? int.parse(notificationData['screen'])
            : null;
        int? argument = notificationData['params'] != null
            ? int.parse(notificationData['params'])
            : null;
        final url =
            notificationData["url"] != null ? notificationData["url"] : null;
        if (screen != null && argument != null) {
          Constant.pageController!.jumpToPage(screen);
          Constant.initialIndex = argument;
          // Navigator.of(context).pushNamed(screen, arguments: {"page": 1});
        }

        if (url != null) {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw "Could not launch ${url}";
          }
        }
      }
    }
    // if (notificationData.containsKey('screen')) {
    //   final screen = notificationData['screen'];
    //   Navigator.of(context).pushNamed(screen);
    // }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message: ${message.notification!.title}');
}
