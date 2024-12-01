import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_now/src/bloc/weather/weather_bloc.dart';
import 'package:weather_now/src/services/api_service.dart';
import 'package:weather_now/src/services/location_service.dart';
import 'package:weather_now/src/services/weather_service.dart';
import 'package:weather_now/src/ui/screens/home_screen.dart';

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
          return _loadingIndicator();
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

Widget _loadingIndicator() {
  return  const Scaffold(
    backgroundColor: Colors.black, // Set background color to black
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center both vertically and horizontally
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20), // Space between the progress indicator and text
          Text(
            'Loading weather info...',
            style: TextStyle(
              color: Colors.white, // White text color
              fontSize: 16, // Adjust font size as needed
              fontWeight: FontWeight.w400, // Adjust font weight as needed
            ),
          ),
        ],
      ),
    ),
  );
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
