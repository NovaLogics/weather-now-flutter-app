part of 'weather_bloc.dart';

/// Base event for WeatherBloc.
sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch weather data for a given position.
final class FetchWeather extends WeatherEvent {
  final Position position;

  const FetchWeather(this.position);

  @override
  List<Object> get props => [position];
}
