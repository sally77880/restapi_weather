// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// STATES
// abstract class WeatherState {}

// class WeatherInitial extends WeatherState {}

// class WeatherLoading extends WeatherState {}

// class WeatherSuccess extends WeatherState {
//   final WeatherResponse data;
//   WeatherSuccess(this.data);
// }

// class WeatherError extends WeatherState {}

// /// EVENTS
// abstract class WeatherEvent {}

// class WeatherLoadEvent extends WeatherEvent {}

// /// BLOC
// class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
//   final dio = Dio();

//   WeatherBloc() : super(WeatherInitial()) {
//     on<WeatherLoadEvent>(_onLoad);
//   }

//   FutureOr<void> _onLoad(
//     WeatherLoadEvent event,
//     Emitter<WeatherState> emit,
//   ) async {
//     if (state is WeatherLoading) return;

//     emit(WeatherLoading());

//     try {
//       final response = await dio.get(
//         'https://api.open-meteo.com/v1/forecast?latitude=55.75&longitude=37.61&current_weather=true',
//       );

//       final weather = WeatherResponse.fromJson(response.data);
//       emit(WeatherSuccess(weather));
//     } catch (e) {
//       emit(WeatherError());
//     }
//   }
// }

// /// RESPONSE MODEL
// class WeatherResponse {
//   final double temperature;
//   final double windSpeed;

//   WeatherResponse({
//     required this.temperature,
//     required this.windSpeed,
//   });

//   factory WeatherResponse.fromJson(Map<String, dynamic> json) {
//     final current = json['current_weather'];

//     return WeatherResponse(
//       temperature: (current['temperature'] as num).toDouble(),
//       windSpeed: (current['windspeed'] as num).toDouble(),
//     );
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// STATES
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final String city;
  final double temperature;
  final double windSpeed;

  WeatherSuccess({
    required this.city,
    required this.temperature,
    required this.windSpeed,
  });
}

class WeatherError extends WeatherState {}

/// EVENTS
abstract class WeatherEvent {}

class WeatherLoadEvent extends WeatherEvent {
  final String city;

  WeatherLoadEvent(this.city);
}

/// BLOC
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
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true",
      );

      final current = weatherResponse.data["current_weather"];

      emit(
        WeatherSuccess(
          city: cityName,
          temperature: (current["temperature"] as num).toDouble(),
          windSpeed: (current["windspeed"] as num).toDouble(),
        ),
      );
    } catch (e) {
      emit(WeatherError());
    }
  }
}
