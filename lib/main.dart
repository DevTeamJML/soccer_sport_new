import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/constant/local_notification_service.dart';
import 'package:soccer_sport/core/widgets/splash.dart';
import 'package:soccer_sport/landingPage/presentation/page/home_page.dart';
import 'package:soccer_sport/league/presentation/bloc/league_bloc.dart';
import 'package:soccer_sport/league/presentation/page/leagues_page.dart';
import 'package:soccer_sport/news/presentation/pages/news_page.dart';
import 'package:soccer_sport/setting/presentation/page/about_us.dart';
import 'package:soccer_sport/setting/presentation/page/setting.dart';
import 'package:soccer_sport/setting/presentation/page/terms_condition.dart';
import 'footballMatch/presentation/bloc/football_match_bloc.dart';
import 'footballMatch/presentation/page/football_match_page.dart';
import 'injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart';
import 'package:timezone/data/latest.dart' as ltz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          databaseURL:
              "https://ssc-soccersport-default-rtdb.asia-southeast1.firebasedatabase.app",
          apiKey: 'AIzaSyDBUOSuDKPeI7pI8ASDWb0xD9cN4_OSMto',
          measurementId: "G-JDX5SXW3LS",
          appId: '1:748191188018:web:f6742c7675b869aa6ee82b',
          messagingSenderId: '748191188018',
          projectId: 'ssc-soccersport'));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseHandler);
  await di.init();
  // await initUniLinks();

  // AwesomeNotifications().initialize(
  //     // 'resource://drawable/soccer_club_logo.png',
  //     null,
  //     [
  //       NotificationChannel(
  //         channelKey: 'basic_channel',
  //         channelName: 'Basic Notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //         importance: NotificationImportance.High,
  //         channelShowBadge: true,
  //       ),
  //       NotificationChannel(
  //         channelKey: 'scheduled_channel',
  //         channelName: 'Scheduled Notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //         importance: NotificationImportance.High,
  //         channelShowBadge: true,
  //       )
  //     ],
  //     debug: true);

  // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  //   if (!isAllowed) {
  //     // This is just a basic example. For real apps, you must show some
  //     // friendly dialog box before call the request method.
  //     // This is very important to not harm the user experience
  //     AwesomeNotifications().requestPermissionToSendNotifications();
  //   }
  // });

  // AwesomeNotifications().actionStream.listen((event) {
  //   if (Platform.isIOS) {
  //     AwesomeNotifications().getGlobalBadgeCounter().then(
  //           (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1),
  //         );
  //   }
  // });

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).then(
    (_) => runApp(FootballScoreApp()),
  );
}

// Future<void> initUniLinks() async {
//   // Get the initial link and handle it if there is one
//   final initialUri = await getInitialUri();
// }

class FootballScoreApp extends StatefulWidget {
  @override
  _FootballScoreAppState createState() => _FootballScoreAppState();
}

class _FootballScoreAppState extends State<FootballScoreApp> {


  @override
  void initState() {
    super.initState();

    // _initUniLinksSafe();
  }

  // Future<void> _initUniLinksSafe() async {
  //   try {
  //     final uri = await getInitialUri();
  //     print("Initial URI: $uri");
  //   } catch (e) {
  //     print("UniLinks error: $e");
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // AwesomeNotifications().actionSink.close();
  //   // AwesomeNotifications().createdSink.close();
  //   AwesomeNotifications().cancelAll();
  //   AwesomeNotifications().dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        // serviceLocator<AnalyticsService>().getAnalyticsObserver()
      ],
      title: 'Football score',
      theme: ThemeData(
        scaffoldBackgroundColor: Constant.backgroundColor,
        primaryColor: Constant.color1,
        textTheme: TextTheme(
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
          titleMedium: TextStyle(),
          titleSmall: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        // dialogTheme:
        //     DialogTheme(contentTextStyle: TextStyle(color: Colors.black)),
        
        // dialogTheme: DialogTheme(
        //   titleTextStyle: TextStyle(color: Colors.black),
        //   contentTextStyle: TextStyle(color: Colors.black),
        // ),

        appBarTheme: AppBarTheme(backgroundColor: Constant.color1),
        // bottomAppBarColor: Constant.backgroundColor,
        tabBarTheme: const TabBarThemeData(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: Colors.white,
              width: 1.5,
            ),
          ),
          labelColor: Colors.white,
        ),
        // tabBarTheme: TabBarTheme(
        //   indicator: BoxDecoration(
        //     border: Border(
        //       bottom: BorderSide(color: Colors.white, width: 1.5),
        //     ),
        //   ),
        //   labelColor: Colors.white,
        // ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: new TextStyle(color: Colors.white),
          floatingLabelStyle: new TextStyle(color: Colors.white),
          focusColor: Constant.color2,
          iconColor: Colors.white,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            //  when the TextFormField in unfocused
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Constant.color2),

            //  when the TextFormField in focused
          ),
          border: UnderlineInputBorder(),
          helperStyle: new TextStyle(color: Colors.white),
          counterStyle: new TextStyle(color: Colors.white),
          errorStyle: new TextStyle(color: Constant.color1),
        ),
      ),
      home: FootballMatchPage(),

      //  AnimatedSplashScreen(
      //   splash: Icons.home,
      //   duration: 3000,
      //   splashTransition: SplashTransition.scaleTransition,
      //   backgroundColor: Colors.white,
      //   nextScreen: HomePage(),
      // ),

      routes: {
        // '/homepage': (context) => HomePage(),
        // '/newspage': (context) => NewsPage(),
        // '/footballMatchPage': (context) => FootballMatchPage(),
        // '/statsPage': (context) => LeaguePage(),
        // '/settingPage': (context) => SettingPage(),
        // '/settingPage/term&conditions': (context) => TermsConditionPage(),
        // '/settingPage/aboutus': (context) => AboutUsPage(),
        // '/splash': (context) => Splash(),
      },
    );
  }
}

Future<void> _firebaseHandler(RemoteMessage message) async {
  // AwesomeNotifications().createNotificationFromJsonData(message.data);
}
