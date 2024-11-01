import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var log = Logger();
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});

     notificationsPlugin // requesting permission for all notifications from user
         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
         ?.requestNotificationsPermission();

     //requesting permission for scheduled notification from user
    bool? isScheduleNotificationPermissionGranted = await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestExactAlarmsPermission();
    
    if(isScheduleNotificationPermissionGranted!= null  && isScheduleNotificationPermissionGranted){
      log.i("Schedule notification Permission Granted");
    }
    else{
      log.i("Schedule notification Permission Denied");
    }
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }


  Future scheduleNotification(
      {int id = 0, String? title, String? body, String? payLoad,
        required DateTime scheduledDateTime
      }) async {
    return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        await notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }

}
