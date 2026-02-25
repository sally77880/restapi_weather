import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {}

class DailyWeather {
  final String date;
  final double temp;
  final int weatherCode;

  DailyWeather({
    required this.date,
    required this.temp,
    required this.weatherCode,
  });
}

class WeatherSuccess extends WeatherState {
  final String city;
  final double temperature;
  final double windSpeed;
  final List<DailyWeather> daily;

  WeatherSuccess({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.daily,
  }) : assert(daily.isNotEmpty, 'Daily forecast cannot be empty');
}

abstract class WeatherEvent {}

class WeatherLoadEvent extends WeatherEvent {
  final String city;
  WeatherLoadEvent(this.city);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final dio = Dio();

  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherLoadEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    WeatherLoadEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (event.city.isEmpty) return;

    emit(WeatherLoading());

    try {
      final geoResponse = await dio.get(
        "https://geocoding-api.open-meteo.com/v1/search?name=${event.city}&count=1",
      );

      final results = geoResponse.data["results"];
      if (results == null || results.isEmpty) {
        emit(WeatherError());
        return;
      }

      final lat = results[0]["latitude"];
      final lon = results[0]["longitude"];
      final cityName = results[0]["name"];

      final weatherResponse = await dio.get(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$lat"
        "&longitude=$lon"
        "&current_weather=true"
        "&daily=temperature_2m_max,weathercode"
        "&timezone=auto",
      );

      final current = weatherResponse.data["current_weather"];
      final daily = weatherResponse.data["daily"];

      if (current == null || daily == null) {
        emit(WeatherError());
        return;
      }

      List<DailyWeather> forecast = [];

      for (int i = 0; i < 3; i++) {
        forecast.add(
          DailyWeather(
            date: daily["time"][i] ?? "",
            temp: ((daily["temperature_2m_max"][i] ?? 0) as num).toDouble(),
            weatherCode: daily["weathercode"][i] ?? 0,
          ),
        );
      }

      emit(
        WeatherSuccess(
          city: cityName,
          temperature: (current["temperature"] as num).toDouble(),
          windSpeed: (current["windspeed"] as num).toDouble(),
          daily: forecast,
        ),
      );
    } catch (e) {
      emit(WeatherError());
    }
  }
}
