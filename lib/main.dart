import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_now/bloc/weather/weather_bloc.dart';
import 'package:weather_now/services/location_service.dart';
import 'package:weather_now/ui/screens/home_screen.dart';

void main() => runApp(const WeatherNowApp());

class WeatherNowApp extends StatelessWidget {
  const WeatherNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<WeatherBloc>(
        create: (context) => WeatherBloc(),
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
        } 
        else if (snap.hasData) {
          final position = snap.data as Position;
          context.read<WeatherBloc>().add(FetchWeather(position));
          return const HomeScreen();
        } 
        else {
          return Scaffold(
            body: Center(child: Text(snap.error.toString())),
          );
        }
      },
    );
  }
}
