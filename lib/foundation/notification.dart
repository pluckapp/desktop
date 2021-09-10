//
// notification.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final macInitializationSettings = MacOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  static final initializationSettings = InitializationSettings(
    macOS: macInitializationSettings,
  );

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final _service = NotificationService._internal();

  factory NotificationService() {
    return _service;
  }

  NotificationService._internal();

  static Future<void> initialize() async {
    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> requestPermission() async {
    _localNotificationsPlugin
    .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
      alert: true,
      badge: false,
      sound: false
    );
  }

  static Future<void> show({required String title, required String body}) async {
    const macOSDetails = MacOSNotificationDetails();
    
    const details = NotificationDetails(
      macOS: macOSDetails
    );

    await _localNotificationsPlugin.show(
      0, 
      title, 
      body, 
      details
    );
  }
}