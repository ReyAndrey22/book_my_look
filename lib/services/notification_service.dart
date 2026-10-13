import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, // Parametrul trebuie să fie numit
    );

    // Versiunea 17+ folosește un parametru numit pentru setări
    await _notificationsPlugin.initialize(
      settings: initializationSettings, // Transmis ca prim argument pozițional
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'loyalty_points_channel',
      'Puncte Loialitate',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // Toți parametrii pentru metoda .show() trebuie să fie numiți (named)
    await _notificationsPlugin.show(
      id: 0, 
      title: title, 
      body: body, 
      notificationDetails: platformDetails,
    );
  }
}