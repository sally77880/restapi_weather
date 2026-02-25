import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_bloc.dart';
import 'weather_utils.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2d5b8c),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Введите город",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () {
                  context
                      .read<WeatherBloc>()
                      .add(WeatherLoadEvent(controller.text));
                },
                child: const Text("Получить погоду"),
              ),

              const SizedBox(height: 30),

              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is WeatherSuccess) {
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff4e8ac7),
                                  Color(0xff3b6fa5)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.city,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "${state.temperature}°",
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children:
                                state.daily.map((day) {
                              return Container(
                                width: 100,
                                height: 140,
                                padding:
                                    const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(0xff6fa6e8),
                                      Color(0xff4e8ac7)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                  children: [
                                    Text(
                                      getWeatherIcon(
                                          day.weatherCode),
                                      style:
                                          const TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                    Text(
                                      "${day.temp}°",
                                      style:
                                          const TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      getDay(day.date),
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is WeatherError) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          "Ошибка",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}