// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'weather_bloc.dart';

// class WeatherScreen extends StatefulWidget {
//   const WeatherScreen({super.key});

//   @override
//   State<WeatherScreen> createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => WeatherBloc(),
//       child: Scaffold(
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: BlocBuilder<WeatherBloc, WeatherState>(
//               builder: (context, state) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 40),

//                     if (state is WeatherInitial)
//                       Container(
//                         height: 200,
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       )
//                     else if (state is WeatherLoading)
//                       const SizedBox(
//                         height: 200,
//                         child: Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       )
//                     else if (state is WeatherSuccess)
//                       Container(
//                         height: 200,
//                         padding: const EdgeInsets.all(20),
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Температура: ${state.data.temperature}°C',
//                               style: const TextStyle(
//                                   fontSize: 22, color: Colors.white),
//                             ),
//                             Text(
//                               'Ветер: ${state.data.windSpeed} м/с',
//                               style: const TextStyle(
//                                   fontSize: 22, color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       )
//                     else if (state is WeatherError)
//                       const SizedBox(
//                         height: 200,
//                         child: Center(child: Text('Ошибка загрузки')),
//                       ),

//                     const Spacer(),

//                     ElevatedButton(
//                       onPressed: () {
//                         context.read<WeatherBloc>().add(
//                               WeatherLoadEvent(),
//                             );
//                       },
//                       child: const Text('Получить погоду'),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_bloc.dart';

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
      appBar: AppBar(title: const Text("Weather App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Введите город",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<WeatherBloc>().add(
                  WeatherLoadEvent(controller.text),
                );
              },
              child: const Text("Получить погоду"),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return const Center(child: Text("Введите город"));
                  } else if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherSuccess) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.city, style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 10),
                        Text(
                          "Температура: ${state.temperature}°C",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Ветер: ${state.windSpeed} м/с",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return const Center(
                      child: Text("Город не найден или ошибка"),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
