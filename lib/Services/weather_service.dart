import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:fish_app/Services/location_service.dart';

class WeatherService
{
  static final String _keys = "177eb4d07afbea51309a0446083410ce";
  double latitude = 0;
  double longitude = 0;
  final WeatherFactory weatherFactory;
  WeatherService(): weatherFactory = WeatherFactory(getKey());
  static String getKey()
  {
    return _keys;
  }
  Future<Weather?>  GetWeatherOnline() async
  {
    Position position = await determinePosition();
    longitude = position.longitude;
    latitude  = position.latitude;
    Weather weather = await weatherFactory.currentWeatherByLocation(latitude, longitude);

    return weather;
  }


}

