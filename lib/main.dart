import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_bloc.dart';
import 'weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WeatherBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WeatherScreen(),
      ),
    );
  }
}
