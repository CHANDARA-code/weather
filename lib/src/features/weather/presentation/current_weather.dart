import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/services/notification_service.dart';
import 'package:weather/src/features/weather/application/providers.dart';
import 'package:weather/src/features/weather/domain/weather/weather_data.dart';
import 'package:weather/src/features/weather/presentation/weather_icon_image.dart';

class CurrentWeather extends HookConsumerWidget {
  const CurrentWeather({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCloudsSelected = useState(false);
    final isRainSelected = useState(false);
    final areAlertsEnabled = useState(false);

    useEffect(() {
      Future<void> loadPreferences() async {
        final prefs = await SharedPreferences.getInstance();
        final conditionsString = prefs.getString('conditions');

        if (conditionsString != null) {
          final conditions = jsonDecode(conditionsString) as List;
          for (var condition in conditions) {
            if (condition['name'] == 'Clouds') {
              isCloudsSelected.value = true;
              areAlertsEnabled.value = condition['isToAlert'];
            } else if (condition['name'] == 'Rain') {
              isRainSelected.value = true;
              areAlertsEnabled.value = condition['isToAlert'];
            }
          }
        }
      }

      loadPreferences();
      return null;
    }, []);
    final weatherDataValue = ref.watch(currentWeatherProvider);
    final city = ref.watch(cityProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(city, style: Theme.of(context).textTheme.headlineMedium),
        weatherDataValue.when(
          data: (weatherData) => CurrentWeatherContents(
            data: weatherData,
            isCloudsSelected: isCloudsSelected.value,
            isRainSelected: isRainSelected.value,
            areAlertsEnabled: areAlertsEnabled.value,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, __) => Text(e.toString()),
        ),
      ],
    );
  }
}

class CurrentWeatherContents extends ConsumerWidget {
  const CurrentWeatherContents({
    super.key,
    required this.data,
    required this.isCloudsSelected,
    required this.isRainSelected,
    required this.areAlertsEnabled,
  });
  final WeatherData data;
  final bool isCloudsSelected;
  final bool isRainSelected;
  final bool areAlertsEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    if (areAlertsEnabled) {

      if (isCloudsSelected) {
        alert();
      } else if (isCloudsSelected) {
        alert();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: 120),
        Text(temp, style: textTheme.displayMedium),
        Text(data.description, style: textTheme.bodySmall),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }

  void alert() {
    PushNotificationManager.showNotification(
      id: 0,
      title: 'Weather Update',
      body: 'It is ${data.description.toLowerCase()} today.',
    );
  }
}
