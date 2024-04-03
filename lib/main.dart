import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/repositories/weather_repo.dart';
import 'package:weather_app/screens/homepage.dart';

void main() {
  final weatherRepo = WeatherRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WeatherBloc>(
        create: (context) => WeatherBloc(
          weatherRepository: weatherRepo,
        ),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    ),
  ));
}