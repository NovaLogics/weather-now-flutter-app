import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_now/bloc/weather/weather_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/thunderstorm.png', scale: 1.8);
      case >= 300 && < 400:
        return Image.asset('assets/drizzle.png', scale: 1.8);
      case >= 500 && < 600:
        return Image.asset('assets/rain.png', scale: 1.8);
      case >= 600 && < 700:
        return Image.asset('assets/snow.png', scale: 1.8);
      case >= 700 && < 800:
        return Image.asset('assets/atmosphere.png', scale: 1.8);
      case == 800:
        return Image.asset('assets/clear_sky.png', scale: 1.8);
      case > 800 && <= 804:
        return Image.asset('assets/clouds.png', scale: 1.8);
      default:
        return Image.asset('assets/clouds.png', scale: 1.8);
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return '☀️ Good Morning';
    } else if (hour >= 12 && hour < 16) {
      return '🌞 Good Afternoon';
    } else if (hour >= 16 && hour < 21) {
      return '🌤️ Good Evening';
    } else {
      return '🌙 Have a Peaceful Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _buildBackgroundCircles(),
              _buildBackdropFilter(),
              _buildWeatherInfo(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  Widget _buildBackgroundCircles() {
    return Stack(
      children: [
        _buildCircle(const AlignmentDirectional(3, -0.3), Colors.deepPurple),
        _buildCircle(const AlignmentDirectional(-3, -0.3), Colors.deepPurple),
        _buildRectangle(
            const AlignmentDirectional(0, -1.2), Colors.orange, 300, 600),
      ],
    );
  }

  Widget _buildCircle(AlignmentDirectional alignment, Color color) {
    return Align(
      alignment: alignment,
      child: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildRectangle(AlignmentDirectional alignment, Color color,
      double height, double width) {
    return Align(
      alignment: alignment,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: color),
      ),
    );
  }

  Widget _buildBackdropFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherSuccess) {
          return _buildWeatherDetails(state);
        } else {
          return Container(); // Show empty container while loading or failure
        }
      },
    );
  }

  Widget _buildWeatherDetails(WeatherSuccess state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationInfo(state),
          _buildWeatherGreeting(),
          _buildWeatherIcon(state),
          _buildTemperature(state),
          _buildWeatherCondition(state),
          _buildDate(state),
          customDivider(space: 20),
          _buildSunTimes(state),
          _buildTemperatureDetails(state),
        ],
      ),
    );
  }

  Widget customDivider({double space = 20.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space),
      child: const Divider(
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildLocationInfo(WeatherSuccess state) {
    return Text(
      "📍 ${state.weather.areaName}",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildWeatherGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          getGreeting(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon(WeatherSuccess state) {
    return Center(child: getWeatherIcon(state.weather.weatherConditionCode!));
  }

  Widget _buildTemperature(WeatherSuccess state) {
    return Center(
      child: Text(
        "${state.weather.temperature!.celsius?.round()}°C",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildWeatherCondition(WeatherSuccess state) {
    return Center(
      child: Text(
        state.weather.weatherMain!.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDate(WeatherSuccess state) {
    return Center(
      child: Text(
        DateFormat("EEEE dd -").add_jm().format(state.weather.date!),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildSunTimes(WeatherSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSunTime("Sunrise", state.weather.sunrise!,"assets/ic_sun.png"),
        _buildSunTime("Sunset", state.weather.sunset!,"assets/ic_moon.png"),
      ],
    );
  }

  Widget _buildSunTime(String label, DateTime time, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, scale: 8),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 3),
            Text(
              DateFormat().add_jm().format(time),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTemperatureDetails(WeatherSuccess state) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Divider(color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTemperatureDetail("Temp Max", state.weather.tempMax!,"assets/ic_temp_max.png"),
            _buildTemperatureDetail("Temp Min", state.weather.tempMin!, "assets/ic_temp_min.png"),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureDetail(String label, Temperature temp, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, scale: 8),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 3),
            Text(
              "${temp.celsius?.toStringAsFixed(1)}°C",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
