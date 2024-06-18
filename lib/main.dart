import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/config/app_config.dart';
import 'package:weather/services/notification_service.dart';
import 'package:weather/src/app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const environment = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await AppConfig.load(environment);
  await PushNotificationManager.initNotification();
  runApp(ProviderScope(child: MyApp()));
}
