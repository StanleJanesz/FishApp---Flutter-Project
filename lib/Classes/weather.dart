import 'package:weather/weather.dart';
class WeatherLocal {
  int id;
  final double temperature;
  final String description;
  final double windSpeed;
  final double? humidity;
  final double? pressure;
  final double? windDegree;
  final double? windGust;
  final double? cloudiness;
  final double? rainLastHour;
  final double? rainLast3Hours;
  final double? snowLastHour;
  final double? snowLast3Hours;

  WeatherLocal({
    required this.id,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    this.pressure,
    this.windDegree,
    this.windGust,
    this.cloudiness,
    this.rainLastHour,
    this.rainLast3Hours,
    this.snowLastHour,
    this.snowLast3Hours,
  });

  factory WeatherLocal.fromJson(Map<String, dynamic> json) {
    return WeatherLocal  (
      id: json['id'],
      temperature: json['temperature'],
      description: json['description'],
      windSpeed: json['windSpeed'],
      humidity: json['humidity'],
      pressure: json['pressure'],
      windDegree: json['windDegree'],
      windGust: json['windGust'],
      cloudiness: json['cloudiness'],
      rainLastHour: json['rainLastHour'],
      rainLast3Hours: json['rainLast3Hours'],
      snowLastHour: json['snowLastHour'],
      snowLast3Hours: json['snowLast3Hours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'description': description,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'pressure': pressure,
      'windDegree': windDegree,
      'windGust': windGust,
      'cloudiness': cloudiness,
      'rainLastHour': rainLastHour,
      'rainLast3Hours': rainLast3Hours,
      'snowLastHour': snowLastHour,
      'snowLast3Hours': snowLast3Hours,
    };
  }
  static WeatherLocal adaptFromWeather(Weather weather) {
    return WeatherLocal(
      id: weather.weatherConditionCode!,
      temperature: weather.temperature?.celsius ?? 0.0,
      description: weather.weatherDescription!,
      windSpeed: weather.windSpeed!,
      humidity: weather.humidity!,
      pressure: weather.pressure,
      windDegree: weather.windDegree,
      windGust: weather.windGust,
      cloudiness: weather.cloudiness,
      rainLastHour: weather.rainLastHour,
      rainLast3Hours: weather.rainLast3Hours,
      snowLastHour: weather.snowLastHour,
      snowLast3Hours: weather.snowLast3Hours,
    );
  }
}