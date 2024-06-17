import 'package:flutter/material.dart';
import 'package:weather/src/constants/app_colors.dart';
import 'package:weather/src/features/weather/presentation/city_search_box.dart';
import 'package:weather/src/features/weather/presentation/current_weather.dart';
import 'package:weather/src/features/weather/presentation/hourly_weather.dart';
import 'package:weather/src/features/weather/presentation/hourly_weather_v2.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Welcome 👋',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColors.rainBlueLight,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.rainGradient,
          ),
        ),
        child: const SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                CitySearchBox(),
                SizedBox(height: 20),
                CurrentWeather(),
                SizedBox(height: 20),
                HourlyWeather(),
                SizedBox(height: 40),
                HourlyWeatherV2(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
