import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather/services/permission_manager.dart';
import 'package:weather/src/constants/app_colors.dart';
import 'package:weather/src/features/condition/condition_screen.dart';
import 'package:weather/src/features/weather/presentation/city_search_box.dart';
import 'package:weather/src/features/weather/presentation/current_weather.dart';
import 'package:weather/src/features/weather/presentation/hourly_weather.dart';
import 'package:weather/src/features/weather/presentation/hourly_weather_v2.dart';

class WeatherPage extends HookConsumerWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future<void> requestPermission() async {
        final permissionManager = ref.read(permissionManagerProvider);
        bool isGranted = await permissionManager
            .requestPermission(DeviceAppPermission.notification);
        if (isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notification permission granted')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notification permission denied')));
        }
      }

      requestPermission();
      return null; // No cleanup needed
    }, []);
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConditionScreen()),
              );
            },
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
