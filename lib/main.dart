import 'package:flutter/material.dart';
import 'package:weather_now/screens/home_screen.dart';

void main() => runApp(const WeatherNowApp());

class WeatherNowApp extends StatelessWidget {
  const WeatherNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
