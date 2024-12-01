import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_now/src/features/weather/bloc/weather/weather_bloc.dart';
import 'package:weather_now/src/core/services/location_service.dart';
import 'package:weather_now/src/core/services/weather_service.dart';
import 'package:weather_now/src/features/weather/ui/screens/home_screen.dart';

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