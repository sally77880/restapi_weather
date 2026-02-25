import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_bloc.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(
              onPressed: () {
                context.read<WeatherBloc>().add(
                  WeatherLoadEvent(controller.text),
                );
              },
              child: const Text("Получить погоду"),
            ),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is WeatherSuccess) {
                    return Text(
                      "Темп: ${state.temperature}, ветер: ${state.windSpeed}",
                    );
                  }
                  if (state is WeatherError) {
                    return const Text("Ошибка");
                  }
                  return const Text("Введите город");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
