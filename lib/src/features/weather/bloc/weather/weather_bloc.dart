import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherFactory weatherFactory;

  WeatherBloc({required this.weatherFactory}) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
      FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());

    try {
      final Weather weather = await weatherFactory.currentWeatherByLocation(
        event.position.latitude,
        event.position.longitude,
      );

      if (kDebugMode) {
        debugPrint('Fetched Weather: $weather');
      }

      emit(WeatherSuccess(weather));
    } catch (error) {
      emit(WeatherFailure(error.toString()));
    }
  }
}
