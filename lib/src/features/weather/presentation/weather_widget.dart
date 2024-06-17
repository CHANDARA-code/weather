import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherData weatherData;

  WeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
            'http://openweathermap.org/img/wn/${weatherData.weather[0].icon}.png'),
        title: Text(
            '${weatherData.weather[0].description} - ${weatherData.main.temp}°C'),
        subtitle: Text('Feels like: ${weatherData.main.feelsLike}°C'),
      ),
    );
  }
}

class WeatherResponse {
  final List<WeatherData> weatherList;
  final City city;

  WeatherResponse({required this.weatherList, required this.city});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) =>
      WeatherResponse(
        weatherList: List<WeatherData>.from(
            json["list"].map((x) => WeatherData.fromJson(x))),
        city: City.fromJson(json["city"]),
      );
}

class WeatherData {
  final int dt;
  final Main main;
  final List<Weather> weather;
  final Wind wind;
  final int visibility;
  final Clouds clouds;
  final double pop; // Probability of precipitation
  final Rain? rain;
  final String dtTxt;

  WeatherData({
    required this.dt,
    required this.main,
    required this.weather,
    required this.wind,
    required this.visibility,
    required this.clouds,
    required this.pop,
    this.rain,
    required this.dtTxt,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        dt: json["dt"],
        main: Main.fromJson(json["main"]),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        wind: Wind.fromJson(json["wind"]),
        visibility: json["visibility"],
        clouds: Clouds.fromJson(json["clouds"]),
        pop: json["pop"].toDouble(),
        rain: json["rain"] != null ? Rain.fromJson(json["rain"]) : null,
        dtTxt: json["dt_txt"],
      );
}

class Main {
  final double temp;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final int humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        feelsLike: json["feels_like"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
        pressure: json["pressure"],
        humidity: json["humidity"],
      );
}

class Weather {
  final String main;
  final String description;
  final String icon;

  Weather({required this.main, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );
}

class Wind {
  final double speed;
  final int deg;

  Wind({required this.speed, required this.deg});

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"],
      );
}

class Clouds {
  final int all;

  Clouds({required this.all});

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"],
      );
}

class Rain {
  final double amount;

  Rain({required this.amount});

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        amount: json["3h"].toDouble(),
      );
}

class City {
  final String name;
  final String country;

  City({required this.name, required this.country});

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        country: json["country"],
      );
}
