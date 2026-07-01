import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 1. iOS Başlatma Ayarlarını Ekliyoruz
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false, // İzni birazdan manuel isteyeceğiz
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings, // iOS ayarını InitializationSettings içine koyduk
    );

    await _notificationsPlugin.initialize(settings: settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'sync_channel',
          'Background Sync',
          channelDescription: 'Notifications for background sync tasks',
          importance: Importance.max,
          priority: Priority.high,
        );

    // 2. iOS Bildirim Detaylarını Ekliyoruz
    //const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const DarwinNotificationDetails iosDetails =
    DarwinNotificationDetails(
      presentAlert: true, 
      presentBanner: true, // iOS 14+ için ön planda banner gösterimi (KRİTİK)
      presentList: true,   
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails, // iOS ayarını platform detaylarına koyduk
    );

    await _notificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      payload: '',
      notificationDetails: platformDetails,
    );
  }

  static Future<void> requestPermission() async {
    // Android 13 ve üzeri için bildirim izni
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // 3. iOS için Bildirim İzni İsteme
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}