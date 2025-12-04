import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = flutterLocalNotificationsPlugin;

  Future<void> showTestNotification() async {
    await _plugin.show(
      0,
      'Recipe of the Day',
      'Open the app to see today\'s random recipe!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleDailyRecipeNotification() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(const Duration(seconds: 10)); // тест за 10 секунди

    await _plugin.zonedSchedule(
      1,
      'Recipe of the Day',
      'Open the app to see today\'s random recipe!',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_recipe_channel',
          'Daily Recipe',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
