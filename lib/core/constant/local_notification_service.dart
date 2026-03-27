// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma("vm:entry-point")
class LocalNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future<void> createNotification() async {
    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //         id: 1,
    //         channelKey: 'basic_channel',
    //         title: 'testing fff',
    //         body: 'testin awseome',
    //         notificationLayout: NotificationLayout.Default));
  }

  static Future<void> createReminderNotifications(
      {required DateTime date,
      required int id,
      required title,
      required body,
      required payload}) async {
    // String localTimeZone =
    //     await AwesomeNotifications().getLocalTimeZoneIdentifier();

    // await AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       category: NotificationCategory.Reminder,
    //       id: id,
    //       channelKey: 'scheduled_channel',
    //       title: title,
    //       body: body,
    //       notificationLayout: NotificationLayout.Default,
    //       payload: payload,
    //     ),
    //     schedule: NotificationCalendar.fromDate(
    //       date: date,
    //       allowWhileIdle: true,
    //       preciseAlarm: true,
    //     ));
  }

  static Future<void> cancelAllScheduleNotification() async {
    // await AwesomeNotifications().cancelAll();
  }

  static Future<void> cancelScheduleNotification({required int id}) async {
    // await AwesomeNotifications().cancel(id);
  }

  static Future init({bool initScheduled = false}) async {
    final android =
        AndroidInitializationSettings('assets/soccer_club_logo.png');
    final iOS = DarwinInitializationSettings(onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
      didReceiveLocalNotificationSubject.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    });

    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        onNotifications.add(payload.payload);
      },
    );
    // tz.initializeDatabase([]);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future showScheduledNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
    required DateTime date,
  }) async {
    // return _notifications.zonedSchedule(id, title, body,
    //     tz.TZDateTime.from(date, tz.local), await _notificationDetails(),
    //     payload: payload,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future cancelNotification({
    required int id,
  }) async {
    return _notifications.cancel(id);
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
