import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_now/bloc/weather/weather_bloc.dart';
import 'package:weather_now/services/api_service.dart';
import 'package:weather_now/services/location_service.dart';
import 'package:weather_now/services/weather_service.dart';
import 'package:weather_now/ui/screens/home_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await _loadEnvVariables();

  runApp(
    WeatherNowApp(
      weatherService: WeatherService(apiKey: ApiService().weatherApiKey),
    ),
  );
}

class WeatherNowApp extends StatelessWidget {
  final WeatherService weatherService;

  const WeatherNowApp({super.key, required this.weatherService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<WeatherBloc>(
        create: (context) =>
            WeatherBloc(weatherFactory: weatherService.weatherFactory),
        child: const WeatherHomeScreen(),
      ),
    );
  }
}

class WeatherHomeScreen extends StatelessWidget {
  const WeatherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService.determinePosition(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snap.hasData) {
          final position = snap.data as Position;
          context.read<WeatherBloc>().add(FetchWeather(position));
          return const HomeScreen();
        } else {
          return Scaffold(
            body: Center(child: Text(snap.error.toString())),
          );
        }
      },
    );
  }
}

/// Load environment variables from the .env file.
/// Throws an exception if there is an error loading the file.
Future<void> _loadEnvVariables() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    throw Exception('Error loading .env file: $e');
  }
}
