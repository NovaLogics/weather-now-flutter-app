import 'package:weather/weather.dart';

class WeatherService {
  final WeatherFactory weatherFactory;

  WeatherService({required String apiKey})
      : weatherFactory = WeatherFactory(
          apiKey,
          language: Language.ENGLISH,
        );

  Future<Weather> fetchWeather(double latitude, double longitude) async {
    return await weatherFactory.currentWeatherByLocation(latitude, longitude);
  }
}
