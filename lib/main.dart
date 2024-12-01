import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_now/src/app.dart';
import 'package:weather_now/src/core/services/api_service.dart';
import 'package:weather_now/src/core/services/weather_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvVariables();
  _launchApp();
}

void _launchApp() {
  runApp(
    WeatherNowApp(
      weatherService: WeatherService(apiKey: ApiService().weatherApiKey),
    ),
  );
}

/// Load environment variables from the .env file.
Future<void> _loadEnvVariables() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
}
