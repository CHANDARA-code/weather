import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather/src/features/weather/application/providers.dart';
import 'package:weather/src/features/weather/domain/weather/weather_data.dart';
import 'package:weather/src/features/weather/presentation/weather_icon_image.dart';

class HourlyWeatherV2 extends ConsumerWidget {
  const HourlyWeatherV2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(hourlyWeatherProvider);

    return forecastDataValue.when(
      data: (forecastData) {
        var filteredData = forecastData.list.where((data) {
          return data.date.hour >= 12 && data.date.hour <= 24;
        }).toList();

        return HourlyWeatherRow(weatherDataItems: filteredData);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Text(e.toString()),
    );
  }
}

class HourlyWeatherRow extends StatelessWidget {
  const HourlyWeatherRow({super.key, required this.weatherDataItems});
  final List<WeatherData> weatherDataItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130, // Set a fixed height for the ListView
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataItems.length,
        itemBuilder: (context, index) {
          final data = weatherDataItems[index];
          return HourlyWeatherItem(data: data);
        },
      ),
    );
  }
}

class HourlyWeatherItem extends ConsumerWidget {
  const HourlyWeatherItem({super.key, required this.data});
  final WeatherData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    const fontWeight = FontWeight.normal;
    final temp = data.temp.celsius.toInt().toString();
    return Expanded(
      child: Column(
        children: [
          Text(
            DateFormat.E().format(data.date),
            style: textTheme.bodySmall!.copyWith(fontWeight: fontWeight),
          ),
          Text(
            DateFormat('HH:mm').format(data.date),
            style: textTheme.bodySmall!.copyWith(fontWeight: fontWeight),
          ),
          const SizedBox(height: 8),
          WeatherIconImage(iconUrl: data.iconUrl, size: 48),
          const SizedBox(height: 8),
          Text(
            '$temp°',
            style: textTheme.bodyLarge!.copyWith(fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }
}
