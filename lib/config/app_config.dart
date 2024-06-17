import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String apiUrl;
  final bool featureFlag;
  final String openWeatherAPIKey;
  static AppConfig? _instance;

  AppConfig._({
    required this.apiUrl,
    required this.featureFlag,
    required this.openWeatherAPIKey,
  });

  static Future<void> load(String environment) async {
    final configString =
        await rootBundle.loadString('assets/config_$environment.json');
    final configData = json.decode(configString);
    _instance = AppConfig._(
      apiUrl: configData['apiUrl'],
      featureFlag: configData['featureFlag'],
      openWeatherAPIKey: configData['openWeatherAPIKey'],
    );
  }

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig is not loaded. Call AppConfig.load() first.');
    }
    return _instance!;
  }
}
