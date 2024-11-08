part of 'weather_bloc.dart';

/// Base state for WeatherBloc.
sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

/// Initial state of the WeatherBloc.
final class WeatherInitial extends WeatherState {}

/// Loading state, indicating data is being fetched.
final class WeatherLoading extends WeatherState {}

/// Failure state, indicating an error occurred.
final class WeatherFailure extends WeatherState {}

/// Success state, containing weather data.
final class WeatherSuccess extends WeatherState {
  final Weather weather;

  const WeatherSuccess(this.weather);

  @override
  List<Object> get props => [weather];
}
