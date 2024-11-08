import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl;
  final String weatherApiKey;

  ApiService()
      : baseUrl = dotenv.env['BASE_URL'] ?? 'default_url',
        weatherApiKey = dotenv.env['WEATHER_API_KEY'] ?? 'default_key';


  Future<void> fetchData() async {
    final url = '$baseUrl/data?api_key=$weatherApiKey';
  }
}
